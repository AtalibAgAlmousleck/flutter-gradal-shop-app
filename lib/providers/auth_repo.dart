import 'package:firebase_auth/firebase_auth.dart';

class AuthRepo {
  static Future<void> singUpWithEmailAndPassword(email, password) async {
    await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);
  }

  static Future<void> singInWithEmailAndPassword(email, password) async {
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
  }

  static Future<void> sendEmailVerification() async {
    try {
      //send email verification to the user
      await FirebaseAuth.instance.currentUser!.sendEmailVerification();
    } catch (e) {
      print(e);
    }
  }

  static get uid {
    FirebaseAuth.instance.currentUser!.uid;
  }

  static Future<void> updateUserName(displayName) async {
    await FirebaseAuth.instance.currentUser!.updateDisplayName(displayName);
  }

  static Future<void> updateProfileImage(profileImage) async {
    await FirebaseAuth.instance.currentUser!.updatePhotoURL(profileImage);
  }

  static Future<void> reloadUserData() async {
    await FirebaseAuth.instance.currentUser!.reload();
  }

  static Future<bool> checkEmailVerification() async {
    try {
      bool emailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
      return emailVerified == true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  static Future<void> logOut() async {
    final auth = FirebaseAuth.instance;
    await auth.signOut();
  }
}
