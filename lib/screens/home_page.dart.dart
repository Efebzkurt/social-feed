import 'dart:io';
import 'dart:core';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fstore/service/repository/comment_repo.dart';
import 'package:fstore/constants/colors/colors.dart';
import 'package:fstore/core/size/device_size.dart';
import 'package:intl/intl.dart';
import 'package:fstore/models/comment.dart';
import 'package:fstore/models/user_model.dart';
import 'package:fstore/service/repository/post_repo.dart';
import 'package:fstore/service/auth.dart';
import 'package:fstore/service/collections/collections.dart';
import 'package:fstore/service/repository/storage_repo.dart';
import 'package:fstore/service/repository/user_repo.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:image_picker/image_picker.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  XFile? image;
  String? userName;
  bool isImageUploaded = false;
  String? downloadUrl;
  TextEditingController descriptionController = TextEditingController();
  final StorageRepository storageRepository = StorageRepository();
  final UserRepository userRepository = UserRepository();
  final Auth authRepository = Auth();
  final CommentRepository commentRepository = CommentRepository();
  final PostRepository postRepository = PostRepository();
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  TextEditingController commentController = TextEditingController();
  final ImagePicker picker = ImagePicker();
  final double? deviceWidth = DeviceSize.width;

  @override
  void initState() {
    super.initState();
    fetchUserName;
  }

  Future<void> fetchUserName() async {
    try {
      UserModel currentUser = await userRepository.fetchCurrentUser();
      setState(() {
        userName = currentUser.userName;
      });
    } catch (e) {
      print('Error fetching user name: $e');
    }
  }

  Future<void> pickImage() async {
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null && mounted) {
      String? userId = await authRepository.getCurrentUserId();

      String? postId = firebaseFirestore.collection(Collections.POSTS).doc().id;
      String? url = await storageRepository.uploadPhoto(
        File(pickedImage.path),
        userId,
        postId,
      );

      if (mounted) {
        setState(() {
          image = pickedImage;
          downloadUrl = url;
          isImageUploaded = true;
        });
      }

      if (url != null) {
        if (mounted) {
          setState(() {
            downloadUrl = url;
            isImageUploaded = true;
          });
        }

        Future.delayed(const Duration(seconds: 5), () {
          if (mounted) {
            setState(() {
              isImageUploaded = false;
            });
          }
        });
      }
    }
  }

  Future<void> openImagePicker(BuildContext context) async {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.photo),
              title: const Text('Select an image'),
              onTap: () {
                pickImage();
              },
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: descriptionController,
                decoration:
                    const InputDecoration(labelText: 'Write a caption...'),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                if (image != null) {
                  await postRepository.savePost(
                      image!, descriptionController.text);
                  Navigator.pop(context);
                }
                setState(() {
                  image = null;
                  descriptionController.clear();
                });
              },
              child: const Text('Share'),
            ),
            SizedBox(
              height: 50,
            )
          ],
        );
      },
    );
  }

  Future<String?> fetchUserNameById(String userId) async {
    try {
      final userDoc = await firebaseFirestore
          .collection(Collections.USERS)
          .doc(userId)
          .get();
      return userDoc.data()?['userId'] ?? //TODO Change userId to userName
          'No userId';
    } catch (e) {
      print("Error fetching user name by ID: $e");
      return 'No userId';
    }
  }

  void addComment(String postId, String commentText) async {
    UserModel currentUser = await userRepository.fetchCurrentUser();
    await commentRepository.addComment(
        postId, commentText, currentUser.userId!);
  }

  @override
  void dispose() {
    super.dispose();
    descriptionController.clear();
    descriptionController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    void showCommentsPanel(String postId) {
      showModalBottomSheet(
        backgroundColor: Colors.white,
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        builder: (BuildContext context) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Comments',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Expanded(
                  child: StreamBuilder<List<Comment>>(
                    stream: commentRepository.getComments(postId),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (snapshot.hasError) {
                        return const Text("Comments could not be loaded");
                      }

                      final comments = snapshot.data ?? [];

                      return ListView.builder(
                        itemCount: comments.length,
                        itemBuilder: (context, index) {
                          final comment = comments[index];
                          return FutureBuilder<String?>(
                            future: fetchUserNameById(comment.userId!),
                            builder: (context, userSnapshot) {
                              if (userSnapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const ListTile(
                                  title: Text("Loading..."),
                                );
                              }

                              return ListTile(
                                title:
                                    Text(userSnapshot.data ?? 'Unknown user'),
                                subtitle: Text(comment.commentText!),
                              );
                            },
                          );
                        },
                      );
                    },
                  ),
                ),
                TextField(
                  controller: commentController,
                  decoration: const InputDecoration(
                    labelText: 'Write a comment...',
                    suffixIcon: Icon(Icons.send),
                  ),
                  onSubmitted: (value) async {
                    if (value.isNotEmpty) {
                      addComment(postId, value);
                      commentController.clear();
                    }
                  },
                ),
              ],
            ),
          );
        },
      );
    }

    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      appBar: AppBar(
        title: Text(
          "Social Feed",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: HexColor(AppColors.textFieldTextColor),
      ),
      body: Center(
          child: FutureBuilder(
              future: authRepository.getCurrentUserId(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const CircularProgressIndicator();
                }
                final String userId = snapshot.data!;
                return StreamBuilder<QuerySnapshot>(
                  stream: firebaseFirestore
                      .collection(Collections.POSTS)
                      .where('isUploaded', isEqualTo: true)
                      .orderBy('createdAt', descending: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      print(snapshot.error);
                      return const Center(child: Text("Bir hata oluştu"));
                    }
                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      print(
                          "Snapshot has data?:" + snapshot.hasData.toString());
                      print("Snapshot.data.docs.isEmpty?:" +
                          snapshot.data!.docs.isEmpty.toString()); //TRUE !!!!
                      return const Center(child: Text("No posts"));
                    }

                    final posts = snapshot.data!.docs;

                    return ListView.builder(
                      itemCount: posts.length,
                      itemBuilder: (context, index) {
                        final post =
                            posts[index].data() as Map<String, dynamic>;

                        final String? postId = post['postId'];
                        if (postId == null) {
                          print("Error: Post ID is missing.");
                          return Container();
                        }

                        final DateTime createdAt =
                            post['createdAt'] is Timestamp
                                ? (post['createdAt'] as Timestamp).toDate()
                                : DateTime.tryParse(post['createdAt']) ??
                                    DateTime.now();
                        final String postDate =
                            DateFormat.yMMMMd().format(createdAt);
                        final List<dynamic> likes = post['likes'] ?? [];
                        final int likesCount = likes.length;
                        return Padding(
                          padding: EdgeInsets.all(15),
                          child: Card(
                              color: Colors.white,
                              elevation: 3,
                              child: Column(children: [
                                SizedBox(
                                  height: 30,
                                ),
                                Row(children: [
                                  //User Id
                                  Expanded(
                                    flex: 3,
                                    child: FutureBuilder<String?>(
                                      future: fetchUserNameById(post['userId']),
                                      builder: (context, userSnapshot) {
                                        return Text(
                                          overflow: TextOverflow.clip,
                                          userSnapshot.data ?? 'No username',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        );
                                      },
                                    ),
                                  ),
                                  Expanded(flex: 2, child: Text(postDate))
                                ]),
                                //Description
                                Padding(
                                    padding: EdgeInsets.only(top: 10),
                                    child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(post['description']))),
                                post['photoUrl'] != null
                                    ? Center(
                                        child: Image.network(post['photoUrl'],
                                            height: 250, fit: BoxFit.cover),
                                      )
                                    : const SizedBox(),
                                Row(
                                  children: [
                                    IconButton(
                                      icon: Icon(
                                        likes.contains(userId)
                                            ? Icons.favorite
                                            : Icons.favorite_border,
                                        color: likes.contains(userId)
                                            ? Colors.red
                                            : null,
                                      ),
                                      onPressed: () async {
                                        await postRepository.toggleLike(
                                            postId: postId, userId: userId);
                                      },
                                    ),
                                    Text('$likesCount likes'),
                                    IconButton(
                                      icon: const Icon(
                                          Icons.mode_comment_outlined),
                                      onPressed: () {
                                        showCommentsPanel(postId);
                                      },
                                    ),
                                    StreamBuilder<QuerySnapshot>(
                                      stream: firebaseFirestore
                                          .collection(Collections.POSTS)
                                          .doc(postId)
                                          .collection(Collections.COMMENTS)
                                          .snapshots(),
                                      builder: (context, snapshot) {
                                        if (snapshot.hasData) {
                                          final commentsCount =
                                              snapshot.data!.docs.length;
                                          return Text(
                                              '$commentsCount comments');
                                        } else {
                                          return const Text("0 comment");
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              ])),
                        );
                      },
                    );
                  },
                );
              })),
      //Floating button
      floatingActionButton: SizedBox(
        width: deviceWidth,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: FloatingActionButton.extended(
            elevation: 0,
            onPressed: () {
              openImagePicker(context);
            },
            label: Text("Upload Post"),
            icon: Icon(Icons.add_circle_rounded),
          ),
        ),
      ),
    );
  }
}
