import 'dart:async';
import '../main.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import '../components/OTPLoginComponent.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:quizapp_flutter/utils/ModelKeys.dart';
import 'package:quizapp_flutter/utils/constants.dart';
import 'package:quizapp_flutter/models/UserModel.dart';

class AuthService {
  static FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  GoogleSignIn? buildGoogleSignInScope() {
    return GoogleSignIn(
      scopes: [
        'https://www.googleapis.com/auth/plus.me',
        'https://www.googleapis.com/auth/userinfo.email',
        'https://www.googleapis.com/auth/userinfo.profile',
      ],
    );
  }

  Future<UserModel> signInWithGoogle() async {
    try {
      AuthCredential credential = await getGoogleAuthCredential();
      UserCredential authResult = await _auth.signInWithCredential(credential);

      final User user = authResult.user!;

      await _auth.signOut();

      // await buildGoogleSignInScope()?.signOut();
      try {
        return await loginFromFirebaseUser(user, LoginTypeGoogle);
      } catch (e) {
        print("Error Second Level->" + e.toString());
        throw errorSomethingWentWrong;
      }
    } catch (e) {
      print("Error->" + e.toString());
      throw errorSomethingWentWrong;
    }
  }

  Future<AuthCredential> getGoogleAuthCredential() async {
    // GoogleSignInAccount? googleAccount =
    //     await (buildGoogleSignInScope()?.signIn());
    // GoogleSignInAuthentication? googleAuthentication =
    //     await googleAccount!.authentication;
    // AuthCredential credential = GoogleAuthProvider.credential(
    //   idToken: googleAuthentication.idToken,
    //   accessToken: googleAuthentication.accessToken,
    // );
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser!.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    return credential;
  }

  // Future<void> signUpWithEmailPassword(
  //     {required String email, required String password, String? name, String? age}) async {
  //   UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
  //       email: email, password: password).then(
  //
  //   final User user = value.user!;
  //
  //   UserModel userModel = UserModel();
  //
  //   userModel.email = user.email;
  //   userModel.id = user.uid;
  //   userModel.name = displayName.validate();
  //   userModel.age = age.validate();
  //   userModel.password = password.validate();
  //   userModel.createdAt = DateTime.now();
  //   userModel.photoUrl = user.photoURL.validate();
  //   userModel.loginType = LoginTypeEmail;
  //   userModel.isAdmin = false;
  //   userModel.isTestUser = false;
  //   //userModel.masterPwd = '';
  //
  //
  //       (value) async {
  //     await signInWithEmailPassword(email: value.user!.email!,
  //         password: password,
  //         displayName: name,
  //         age: age);
  //   }
  //   ,
  //   ).catchError(
  //   (error) {
  //   throw 'Email already exists';
  //   },
  //   );
  // }

  Future<void> signUpWithEmailPassword(
      {String? name, String? email, String? password, String? age}) async {
    UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email!, password: password!);

    if (userCredential != null && userCredential.user != null) {
      User currentUser = userCredential.user!;
      UserModel userModel = UserModel(isTestUser: false);

      /// Create user

      userModel.email = currentUser.email;
      userModel.id = currentUser.uid;
      userModel.name = name.validate();
      userModel.age = age.validate();
      userModel.password = password.validate();
      userModel.createdAt = DateTime.now();
      userModel.updatedAt = DateTime.now();
      userModel.photoUrl = currentUser.photoURL.validate();
      userModel.loginType = LoginTypeEmail;
      userModel.isAdmin = false;
      userModel.isTestUser = false;
      userModel.referCode = currentUser.uid.substring(0, 8).toUpperCase();
      //userModel.masterPwd = '';

      await userDBService
          .addDocumentWithCustomId(currentUser.uid, userModel.toJson())
          .then((value) async {
        log('Signed up');
        await signInWithEmailPassword(email: email, password: password)
            .then((value) {
//
        });
      }).catchError((e) {
        throw e;
      });
    } else {
      throw errorSomethingWentWrong;
    }
  }

  Future<void> signInWithEmailPassword(
      {required String email,
      required String password,
      String? displayName,
      String? age}) async {
    await _auth
        .signInWithEmailAndPassword(email: email, password: password)
        .then(
      (value) async {
        return userDBService.getUserByEmail(email).then(
          (user) async {
            await setValue(USER_ID, user.id);
            await setValue(USER_DISPLAY_NAME, user.name);
            await setValue(USER_EMAIL, user.email);
            await setValue(PASSWORD, password);
            await setValue(USER_AGE, user.age.validate());
            await setValue(USER_POINTS, user.points.validate());
            await setValue(USER_PHOTO_URL, user.photoUrl.validate());
            await setValue(USER_CLASS, user.classe.validate());
            // await setValue(USER_MASTER_PWD, user.masterPwd.validate());
            await setValue(LOGIN_TYPE, user.loginType.validate());
            await setValue(IS_LOGGED_IN, true);
            appStore.setLoggedIn(true);
            appStore.setUserId(user.id);
            appStore.setName(user.name);
            appStore.setProfileImage(user.photoUrl);
            appStore.setUserEmail(user.email);
            appStore.setUserAge(user.age);
            appStore.setUserClasse(user.classe);
            await userDBService.updateDocument(
                {CommonKeys.updatedAt: DateTime.now()}, user.id);
          },
        ).catchError(
          (e) {
            throw e;
          },
        );
      },
    ).catchError(
      (error) async {
        if (!await isNetworkAvailable()) {
          throw 'Please check network connection';
        }
        log(error.toString());
        throw 'Enter valid email and password';
      },
    );
  }

  Future<void> logout() async {
    await removeKey(USER_DISPLAY_NAME);
    if (getBoolAsync(IS_REMEMBERED) == false) {
      await removeKey(USER_EMAIL);
      await removeKey(PASSWORD);
    }
    await removeKey(USER_PHOTO_URL);
    await removeKey(IS_LOGGED_IN);
    await removeKey(LOGIN_TYPE);
    await removeKey(USER_AGE);
    await removeKey(USER_POINTS);
    await removeKey(USER_CLASS);

    appStore.setLoggedIn(false);
    appStore.setUserId('');
    appStore.setName('');
    appStore.setUserClasse('');
    appStore.setUserEmail('');
    appStore.setProfileImage('');
  }

  Future<void> setUserDetailPreference(UserModel user) async {
    await setValue(USER_ID, user.id);
    await setValue(USER_DISPLAY_NAME, user.name);
    await setValue(USER_EMAIL, user.email);
    await setValue(USER_POINTS, user.points);
    await setValue(USER_AGE, user.age.validate());
    await setValue(USER_CLASS, user.classe.validate());
    await setValue(USER_PHOTO_URL, user.photoUrl.validate());
    await setValue(IS_TESTER, user.isTestUser);
    appStore.setLoggedIn(true);
    appStore.setUserId(user.id);
    appStore.setName(user.name);
    appStore.setProfileImage(user.photoUrl);
    appStore.setUserEmail(user.email);
    appStore.setUserAge(user.age);
    appStore.setUserClasse(user.classe);
    // await setValue(USER_MASTER_PWD, user.masterPwd.validate());
    await setValue(IS_LOGGED_IN, true);
  }

  Future<UserModel> loginFromFirebaseUser(User currentUser, String loginType,
      {String? fullName}) async {
    UserModel userModel = UserModel(isTestUser: false);

    if (await userDBService.isUserExist(currentUser.email, loginType)) {
      ///Return user data
      await userDBService.getUserByEmail(currentUser.email).then(
        (user) async {
          log('value');
          userModel = user;
        },
      ).catchError(
        (e) {
          print("Error Level 2.1 ->" + e.toString());
          throw e;
        },
      );
    } else {
      /// Create user
      userModel.id = currentUser.uid;
      userModel.email = currentUser.email;
      userModel.photoUrl = currentUser.photoURL;
      userModel.name = (currentUser.displayName) ?? fullName;
      userModel.loginType = loginType;
      userModel.updatedAt = DateTime.now();
      userModel.createdAt = DateTime.now();
      await userDBService
          .addDocumentWithCustomId(currentUser.uid, userModel.toJson())
          .then(
        (value) {
          //
        },
      ).catchError(
        (e) {
          print("Error Level 2.2 ->" + e.toString());
          throw e;
        },
      );
    }
    await setValue(LOGIN_TYPE, loginType);

    try {
      appStore.setLoggedIn(true);
      appStore.setUserId(userModel.id);
      appStore.setName(userModel.name);
      appStore.setProfileImage(userModel.photoUrl);
      appStore.setUserEmail(userModel.email);
      appStore.setUserClasse(userModel.classe);
      await setUserDetailPreference(userModel);
    } catch (e) {
      print("Error Level 2.3 ->" + e.toString());
      throw e;
    }

    return userModel;
  }

  Future<void> forgotPassword({required String email}) async {
    await _auth.sendPasswordResetEmail(email: email).then(
      (value) {
        //
      },
    ).catchError(
      (error) {
        throw error.toString();
      },
    );
  }

  Future<void> resetPassword({required String newPassword}) async {
    await _auth.currentUser!.updatePassword(newPassword).then(
      (value) {
        //
      },
    ).catchError(
      (error) {
        throw error.toString();
      },
    );
  }

  Future deleteUserPermenant({String? uid}) async {
    FirebaseAuth.instance.currentUser!.delete();
    await removeKey(USER_DISPLAY_NAME);
    await removeKey(USER_EMAIL);
    await removeKey(PASSWORD);
    await removeKey(USER_PHOTO_URL);
    await removeKey(IS_LOGGED_IN);
    await removeKey(LOGIN_TYPE);
    await removeKey(USER_AGE);
    await removeKey(USER_POINTS);
    await removeKey(USER_CLASS);

    appStore.setLoggedIn(false);
    appStore.setUserId('');
    appStore.setName('');
    appStore.setUserEmail('');
    appStore.setProfileImage('');
    appStore.setUserClasse('');
    await userDBService.removeDocument(uid!).then((value) async {
      _auth.currentUser!.delete();
      await _auth.signOut();
    }).catchError((e) {
      log(e);
    });
  }

  Future<void> loginWithOTP(BuildContext context, String phoneNumber) async {
    return await auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {},
      verificationFailed: (FirebaseAuthException e) {
        if (e.code == 'invalid-phone-number') {
          toast('The provided phone number is not valid.');
          throw 'The provided phone number is not valid.';
        } else {
          toast(e.toString());
          appStore.setLoading(false);
          throw e.toString();
        }
      },
      codeSent: (String verificationId, int? resendToken) async {
        finish(context);
        appStore.setLoading(false);
        await showDialog(
            context: context,
            builder: (context) => OTPDialog(
                verificationId: verificationId,
                isCodeSent: true,
                phoneNumber: phoneNumber),
            barrierDismissible: false);
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        //
      },
    );
  }

// End of classe.
}
