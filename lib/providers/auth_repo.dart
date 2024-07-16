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
    User user = FirebaseAuth.instance.currentUser!;
    return user.uid;
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

  static Future<void> sendPasswordResetEmail(email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
    } catch(e) {
      print(e);
    }
  }

  static Future<bool> checkOldPassword(email, password) async {
    AuthCredential authCredential = EmailAuthProvider.credential(email: email, password: password);
    try {
      var credentialResult = await FirebaseAuth.instance.currentUser!
          .reauthenticateWithCredential(authCredential);
      return credentialResult.user != null;
    } catch(e) {
      print(e);
      return false;
    }
  }

  static Future<void> updateUserPassword(newPassword) async {
    User user = FirebaseAuth.instance.currentUser!;
    try {
      await user.updatePassword(newPassword);
    }catch (e) {
      print(e);
    }
  }
}
