import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Method to fetch the current user's data (name, email, profile photo)
  Future<Map<String, dynamic>?> getUserDataByID(String userID) async {
    try {
      // Get the current user's UID from Firebase Auth
      User? currentUser = _auth.currentUser;
      if (currentUser != null) {
        // Fetch the user's document from Firestore using their UID
        DocumentSnapshot userDoc =
            await _firestore.collection('users').doc(userID).get();

        if (userDoc.exists) {
          // Extract the user's name, email, and profile photo from the document
          String name = userDoc['name'] ?? 'Unknown Name';
          String email = userDoc['email'] ?? 'Unknown Email';
          // Return the fetched data as a map
          return {
            'name': name,
            'email': email,
          };
        } else {
          print("No user document found");
          return null; // Document doesn't exist
        }
      } else {
        print("No user is logged in");
        return null; // User is not logged in
      }
    } catch (e) {
      print("Error fetching user data: $e");
      return null; // Return null in case of an error
    }
  }

  Future<void> deleteUserAuth() async {
    try {
      User? currentUser = _auth.currentUser;
      if (currentUser != null) {
        await currentUser.delete();
      }
    } catch (e) {
      print("Error deleting user: $e");
      throw e;
    }
  }

  // Remove user data from Firestore
  Future<void> deleteUserFromFirestore(String userID) async {
    try {
      await _firestore.collection('users').doc(userID).delete();
      print("User data deleted from Firestore");
    } catch (e) {
      print("Error deleting user data: $e");
      throw e;
    }
  }

  // Full delete user method
  Future<void> deleteUser(String userID) async {
    try {
      await deleteUserFromFirestore(userID);
      await deleteUserAuth();
      print("User deleted successfully");
    } catch (e) {
      print("Error deleting user: $e");
    }
  }
}
