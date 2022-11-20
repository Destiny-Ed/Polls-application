import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:my_polls/firebase_options.dart';

class AuthProvider extends ChangeNotifier {
  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn(
            clientId: DefaultFirebaseOptions.currentPlatform.iosClientId)
        .signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  Future<void> logOut() async {
    // try {
      await FirebaseAuth.instance.signOut();

      await GoogleSignIn(
              clientId: DefaultFirebaseOptions.currentPlatform.iosClientId)
          .signOut();

      // return true;
    // } catch (e) {
    //   print(e);
    //   return false;
    // }
  }
}
