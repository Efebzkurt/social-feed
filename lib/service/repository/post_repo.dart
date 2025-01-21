// ignore_for_file: avoid_print

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fstore/models/post.dart';
import 'package:fstore/models/user_model.dart';
import 'package:fstore/service/collections/collections.dart';
import 'package:fstore/service/repository/storage_repo.dart';
import 'package:fstore/service/repository/user_repo.dart';
import 'package:image_picker/image_picker.dart';

class PostRepository {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  final StorageRepository _storageRepository = StorageRepository();
  final UserRepository _userRepository = UserRepository();

  // Post kaydet
  Future<void> savePost(XFile image, String description) async {
    print("POST SAVE DEBUG");
    try {
      UserModel currentUser = await _userRepository.fetchCurrentUser();

      Post newPost = Post(
        postId: '',
        userId: currentUser.userId,
        description: description,
        createdAt: DateTime.now(),
        likes: [],
        comments: [],
        isUploaded: false,
      );

      // Yeni bir post belgesi oluştur ve post ID'sini al
      DocumentReference postRef =
          _firebaseFirestore.collection(Collections.POSTS).doc();
      newPost = newPost.copyWith(postId: postRef.id);
      await postRef.set(newPost.toMap());

      // Resmi Firebase Storage'a yükle
      String? imageUrl;
      try {
        imageUrl = await _storageRepository.uploadPhoto(
          File(image.path),
          currentUser.userId!,
          postRef.id,
        );
      } catch (e) {
        print("Error uploading photo: $e");
      }

      if (imageUrl != null) {
        try {
          await postRef.update({
            'photoUrl': imageUrl,
            'isUploaded': true,
          });
          print("Photo URL and isUploaded status updated successfully.");
        } catch (e) {
          print("Error updating photo URL in Firestore: $e");
        }
      } else {
        print("Failed to retrieve image URL.");
      }

      // Kullanıcının postIds listesini güncelle
      List<String> updatedPostIds = (currentUser.postIds ?? []).cast<String>();

      updatedPostIds.add(postRef.id);
      try {
        await _firebaseFirestore
            .collection(Collections.USERS)
            .doc(currentUser.userId)
            .update({
          'postIds': updatedPostIds,
        });
        print("Post successfully saved with ID: ${postRef.id}");
      } catch (e) {
        print("Error updating user's postIds: $e");
      }
    } catch (e) {
      print('Error saving post: $e');
    }
  }

  Future<void> toggleLike(
      {required String postId, required String userId}) async {
    final postRef =
        _firebaseFirestore.collection(Collections.POSTS).doc(postId);

    final postSnapshot = await postRef.get();
    final List likes = postSnapshot['likes'];

    if (likes.contains(userId)) {
      // Beğeni kaldır
      await postRef.update({
        'likes': FieldValue.arrayRemove([userId])
      });
    } else {
      // Beğeni ekle
      await postRef.update({
        'likes': FieldValue.arrayUnion([userId])
      });
    }
  }
}
