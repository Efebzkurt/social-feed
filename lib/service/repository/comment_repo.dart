import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fstore/models/comment.dart';
import 'package:fstore/service/collections/collections.dart';

class CommentRepository {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  // Yorum ekleme
  Future<void> addComment(
      String postId, String commentText, String userId) async {
    try {
      DocumentReference commentRef = _firebaseFirestore
          .collection(Collections.POSTS)
          .doc(postId)
          .collection(Collections.COMMENTS)
          .doc();

      Comment newComment = Comment(
        commentId: commentRef.id,
        postId: postId,
        userId: userId,
        commentText: commentText,
        createdAt: DateTime.now(),
      );

      await commentRef.set(newComment.toMap());
    } catch (e) {
      print('Error adding comment: $e');
    }
  }

  // Yorumları alma
  Stream<List<Comment>> getComments(String postId) {
    return _firebaseFirestore
        .collection(Collections.POSTS)
        .doc(postId)
        .collection(Collections.COMMENTS)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => Comment.fromMap(doc.data())).toList();
    });
  }
}
