import 'dart:async';

import 'package:apple_sign_in/apple_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // Firebase user one-time fetch
  Future<User> get getUser async => _auth.currentUser;

  // Firebase user realtime stream
  Stream<User> get user => _auth.authStateChanges();

  // Determine if apple Signin is availble on device
  Future<bool> get appleSignInAvailable => AppleSignIn.isAvailable();

  // Sign in Anonymously
  Future<User> anonSignIn() async {
    User user = (await _auth.signInAnonymously()).user;
    updateUserData(user);
    return user;
  }

  /// Sign in with Google
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
    } catch (error) {
      print(error);
      return null;
    }
  }

  //Sign in with Apple
  Future<User> appleSignIn() async {
    try {
      final AuthorizationResult appleResult =
          await AppleSignIn.performRequests([
        AppleIdRequest(requestedScopes: [Scope.email, Scope.fullName])
      ]);

      if (appleResult.error != null) {
        // Handle errors from Apple
      }

      final OAuthCredential credential = OAuthProvider('apple.com').credential(
        accessToken:
            String.fromCharCodes(appleResult.credential.authorizationCode),
        idToken: String.fromCharCodes(appleResult.credential.identityToken),
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

  // Update user data in database
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
