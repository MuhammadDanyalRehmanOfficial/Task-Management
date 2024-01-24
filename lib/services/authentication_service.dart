import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthenticationService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String?> signUp(String email, String password, String role) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Save user details to Firestore
      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'email': email,
        'password': password,
        'role': role,
      });

      return role;
    } catch (e) {
      print("Error during signup: $e");
      return e.toString();
    }
  }

  Future<String?> login(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Fetch user role from Firestore
      DocumentSnapshot userDoc = await _firestore
          .collection('users')
          .doc(userCredential.user!.uid)
          .get();

      return userDoc['role'];
    } catch (e) {
      print("Error during login: $e");
      return e.toString();
    }
  }
  Future<void> signOut() async {
    return await FirebaseAuth.instance.signOut();
  }
}
