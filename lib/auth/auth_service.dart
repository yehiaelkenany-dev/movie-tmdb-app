import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get current User
  User? getCurrentUser() {
    return _firebaseAuth.currentUser;
  }

  // Sign In Method
  Future<UserCredential?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential userCredential = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);

      _firestore.collection("users").doc(userCredential.user!.uid).set(
          {"uid": userCredential.user!.uid, "email": email},
          SetOptions(merge: true));
      return userCredential;
    } on FirebaseAuthException {
      rethrow;
    } catch (e) {
      print(e);
      throw Exception("An unexpected error occurred: $e");
    }
  }

  // Sign UP Method
  Future<UserCredential> signUpWithEmailAndPassword(
    String email,
    String password,
    String name,
  ) async {
    try {
      // 1. Create auth user first
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      // 2. Now check email in Firestore (authenticated)
      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: email)
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty) {
        await userCredential.user!.delete(); // Rollback
        throw FirebaseAuthException(
          code: 'email-already-in-use',
          message: 'Email already registered',
        );
      }

      // 3. Create user document
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .set({
        'uid': userCredential.user!.uid,
        'email': email,
        'name': name,
        'createdAt': FieldValue.serverTimestamp(),
      });

      return userCredential;
    } catch (e) {
      print('Signup error: $e');
      rethrow;
    }
  }

  // Sign Out Method

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}
