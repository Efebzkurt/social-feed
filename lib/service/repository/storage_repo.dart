// ignore_for_file: avoid_print

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fstore/service/collections/collections.dart';

class StorageRepository {
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  Future<String?> uploadPhoto(
      File photoFile, String? userId, String postId) async {
    try {
      User? loggedInUser = _firebaseAuth.currentUser;
      if (loggedInUser == null) {
        return null;
      }

      final reference =
          _firebaseStorage.ref().child('Users/$userId/Posts/$postId/photo.png');
      await reference.putFile(photoFile);

      final downloadUrl = await reference.getDownloadURL();

      await _firebaseFirestore
          .collection(Collections.USERS)
          .doc(loggedInUser.uid)
          .update({
        'photoUrl': downloadUrl,
        'userId': loggedInUser.uid,
      });

      return downloadUrl;
    } catch (e) {
      print('Error uploading photo: $e');
      return null;
    }
  }
}
