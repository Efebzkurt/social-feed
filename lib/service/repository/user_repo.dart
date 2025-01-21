import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fstore/models/user_model.dart';
import 'package:fstore/service/collections/collections.dart';

class UserRepository {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  Future<void> addUser(UserModel userModel) async {
    await _firebaseFirestore
        .collection(Collections.USERS)
        .doc(userModel.userId)
        .set(userModel.toMap());
  }

  Future<UserModel> fetchCurrentUser() async {
    final String userId = _firebaseAuth.currentUser!.uid;
    DocumentSnapshot documentSnapshot = await _firebaseFirestore
        .collection(Collections.USERS)
        .doc(userId)
        .get();

    if (documentSnapshot.exists) {
      return UserModel.fromMap(documentSnapshot.data() as Map<String, dynamic>);
    } else {
      return UserModel(userId: userId);
    }
  }

  Future<bool> doesUserExist(String userId) async {
    final userDoc = await _firebaseFirestore
        .collection(Collections.USERS)
        .doc(userId)
        .get();
    return userDoc.exists;
  }
}
