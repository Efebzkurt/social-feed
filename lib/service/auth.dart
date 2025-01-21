import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fstore/models/user_model.dart';
import 'package:fstore/service/repository/user_repo.dart';

class Auth {
  final FirebaseAuth _fireBaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  User? get currentUser => _fireBaseAuth.currentUser;
  Stream<User?> get authStateChanges => _fireBaseAuth.authStateChanges();
  //Create user-register
  Future<void> createUser(
      {required String email, required String password}) async {
    try {
      UserCredential userCredential =
          await _fireBaseAuth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      await userCredential.user?.sendEmailVerification();

      final UserModel user = UserModel(
        userId: userCredential.user!.uid,
        email: userCredential.user!.email,
      );
      await UserRepository().addUser(user);
    } on FirebaseAuthException catch (e) {
      throw FirebaseAuthException(
          code: e.code, message: e.message ?? "Error occurred");
    }
  }

  //Signin user
  Future<void> loginUser({
    required String email,
    required String password,
  }) async {
    await _fireBaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
  }

  //Signout user
  Future<void> signOut() async {
    await _fireBaseAuth.signOut();
  }

  //Get current user id
  Future<String> getCurrentUserId() async {
    final user = _fireBaseAuth.currentUser;
    return user!.uid;
  }
}
