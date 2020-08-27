import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<User> get getUser async => _auth.currentUser;

  Stream<User> get user => _auth.authStateChanges();

  Future<User> anonSignIn() async {
    User user = (await _auth.signInAnonymously()).user;
    updateUserData(user);
    return user;
  }

  Future<User> googleSignIn() async {
    try {
      GoogleSignInAccount googleSignInAccount = await _googleSignIn.signIn();
      GoogleSignInAuthentication googleAuth =
          await googleSignInAccount.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential result = await _auth.signInWithCredential(credential);
      User user = result.user;

      // Update user data
      updateUserData(user);

      return user;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<void> updateUserData(User user) async {
    DocumentReference reportRef = _db.collection('reports').doc(user.uid);

    return reportRef.set({
      'uid': user.uid,
      'lastActivity': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  Future<void> signOut() {
    return _auth.signOut();
  }
}
