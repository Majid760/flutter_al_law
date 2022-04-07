import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_al_law/bloc/drawer_bloc.dart';
import 'package:flutter_al_law/controllers/controllers.dart';
import 'package:flutter_al_law/models/profile_model.dart';
import 'package:flutter_al_law/services/firestore_service.dart';
import 'package:flutter_al_law/ui/drawer/drawer.dart';
import 'package:flutter_al_law/utils/helpers.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_al_law/models/models.dart';
import 'package:flutter_al_law/ui/auth/auth.dart';

class AuthController extends GetxController {
  static AuthController to = Get.find();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  Rx<User> firebaseUser = Rx<User>();
  Rx<UserModel> firestoreUser = Rx<UserModel>();

  @override
  void onReady() async {
    //run every time auth state changes
    ever(firebaseUser, handleAuthChanged);
    firebaseUser.bindStream(user);

    super.onReady();
  }

  // void updateUserImage(String profileURl) {
  //   imageFilePath.value = profileURl;
  //   update();
  // }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  handleAuthChanged(_firebaseUser) async {
    print(_firebaseUser);
    //get user data from firestore
    if (_firebaseUser?.uid != null) {
      firestoreUser.bindStream(streamFirestoreUser());
    }

    Helpers.hideLoader();
    if (_firebaseUser == null) {
      print('Send to signin');
      Get.offAll(() => SignInUI());
    } else {
      Get.offAll(() => BlocProvider<DrawerBloc>(
            create: (context) => DrawerBloc(HomeUI()),
            child: DrawerLayout(),
          ));
    }
  }

  // Firebase user one-time fetch
  Future<User> get getUser async => _auth.currentUser;

  // Firebase user a realtime stream
  Stream<User> get user => _auth.authStateChanges();

  //Streams the firestore user from the firestore collection
  Stream<UserModel> streamFirestoreUser() {
    print('streamFirestoreUser()');
    return _db
        .doc('/users/${firebaseUser.value.uid}')
        .snapshots()
        .map((snapshot) => UserModel.fromMap(snapshot.data()));
  }

  //get the firestore user from the firestore collection
  Future<UserModel> getFirestoreUser() {
    return _db
        .doc('/users/${firebaseUser.value.uid}')
        .get()
        .then((documentSnapshot) => UserModel.fromMap(documentSnapshot.data()));
  }

  //Method to handle user sign in using email and password
  signInWithEmailAndPassword(BuildContext context) async {
    Helpers.showLoader(context);
    try {
      await _auth
          .signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      )
          .then((result) async {
        List<ScheduleModel> schedules = await FireStoreService(
          uid: result.user.uid,
        ).getAllFireStoreSchedules();
        if (schedules.isNotEmpty) {
          schedules.retainWhere(
            (element) => element.dateTime.isAfter(
              DateTime.now().add(
                Duration(seconds: 10),
              ),
            ),
          );
          NotificationsController.to.scheduleMultipleNotifications(schedules);
          print('uID: ' + result.user.uid);
        }
      });
      emailController.clear();
      passwordController.clear();
    } on FirebaseAuthException catch (error) {
      print(error.runtimeType);
      print(error.message);
      Helpers.hideLoader();
      String errorMsg;
      if (error.message.contains('Unable to resolve host')) {
        errorMsg = "No internet connection";
      }
      Get.snackbar(
        'Sign In Error',
        errorMsg ?? 'Login failed: email or password incorrect.',
        snackPosition: SnackPosition.BOTTOM,
        duration: Duration(seconds: 4),
        backgroundColor: Get.theme.snackBarTheme.backgroundColor,
        colorText: Get.theme.snackBarTheme.actionTextColor,
      );
    }
  }

  // User registration using email and password
  registerWithEmailAndPassword(BuildContext context) async {
    Helpers.showLoader(context);
    try {
      await _auth
          .createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      )
          .then((result) async {
        // await result.user.sendEmailVerification(); //Email verification
        print('uID: ' + result.user.uid.toString());
        print('email: ' + result.user.email.toString());
        //create the new user object
        UserModel _newUser = UserModel(
          uid: result.user.uid,
          email: result.user.email,
          name: nameController.text,
          experience: null,
          education: null,
          mobile: null,
          photoUrl: null,
          photoBlob: null,
          services: [],
          degrees: [],
          specialist: [],
        );
        ProfileModel _newProfile = new ProfileModel(
          name: nameController.text,
          email: result.user.email,
          mobile: null,
          education: null,
          experience: null,
          photoBlob: null,
          services: [],
          degrees: [],
          specialist: [],
          ratings: [],
          reviews: [],
        );
        //create the user in firestore
        _createUserFirestore(_newUser, _newProfile, result.user);
        emailController.clear();
        passwordController.clear();
        // Helpers.hideLoader();
      });
    } on FirebaseAuthException catch (error) {
      Helpers.hideLoader();
      Get.snackbar('Sign Up Failed.', error.message,
          snackPosition: SnackPosition.BOTTOM,
          duration: Duration(seconds: 6),
          backgroundColor: Get.theme.snackBarTheme.backgroundColor,
          colorText: Get.theme.snackBarTheme.actionTextColor);
    }
  }

  //handles updating the user when updating profile
  Future<void> updateUser(
      BuildContext context, UserModel user, String oldEmail, String password) async {
    try {
      Helpers.showLoader(context);
      await _auth
          .signInWithEmailAndPassword(email: oldEmail, password: password)
          .then((_firebaseUser) {
        _firebaseUser.user
            .updateEmail(user.email)
            .then((value) => _updateUserFirestore(user, _firebaseUser.user));
      });
      Helpers.hideLoader();
      Get.snackbar('User Updated', 'User information successfully updated.',
          snackPosition: SnackPosition.BOTTOM,
          duration: Duration(seconds: 5),
          backgroundColor: Get.theme.snackBarTheme.backgroundColor,
          colorText: Get.theme.snackBarTheme.actionTextColor);
    } on PlatformException catch (error) {
      Helpers.hideLoader();
      print(error.code);
      String authError;
      switch (error.code) {
        case 'ERROR_WRONG_PASSWORD':
          authError = 'The password does not match our records.';
          break;
        default:
          authError = 'Unknown Error';
          break;
      }
      Get.snackbar('Login Failed', authError,
          snackPosition: SnackPosition.BOTTOM,
          duration: Duration(seconds: 10),
          backgroundColor: Get.theme.snackBarTheme.backgroundColor,
          colorText: Get.theme.snackBarTheme.actionTextColor);
    } catch (error) {
      Helpers.hideLoader();
      print(error.code);
      String authError;
      switch (error.code) {
        case 'ERROR_WRONG_PASSWORD':
        case 'wrong-password':
          authError = 'The password does not match our records.';
          break;
        default:
          authError = 'Unknown Error';
          break;
      }
      Get.snackbar('Login Failed', authError,
          snackPosition: SnackPosition.BOTTOM,
          duration: Duration(seconds: 10),
          backgroundColor: Get.theme.snackBarTheme.backgroundColor,
          colorText: Get.theme.snackBarTheme.actionTextColor);
    }
  }

  //updates the firestore user in users collection
  void _updateUserFirestore(UserModel user, User _firebaseUser) {
    _db.doc('/users/${_firebaseUser.uid}').update(user.toJson());
    update();
  }

  //create the firestore user in users collection
  void _createUserFirestore(
    UserModel user,
    ProfileModel profile,
    User _firebaseUser,
  ) {
    _db.doc('/users/${_firebaseUser.uid}').set(user.toJson());
    _db.doc('/profiles/${_firebaseUser.uid}').set(profile.toJson());
    update();
  }

  //password reset email
  Future<void> sendPasswordResetEmail(BuildContext context) async {
    Helpers.showLoader(context);
    try {
      await _auth.sendPasswordResetEmail(email: emailController.text);
      Helpers.hideLoader();
      Get.snackbar('Password Reset Email Sent',
          'Check your email and follow the instructions to reset your password.',
          snackPosition: SnackPosition.BOTTOM,
          duration: Duration(seconds: 5),
          backgroundColor: Get.theme.snackBarTheme.backgroundColor,
          colorText: Get.theme.snackBarTheme.actionTextColor);
    } on FirebaseAuthException catch (error) {
      Helpers.hideLoader();
      Get.snackbar('Password Reset Email Failed', error.message,
          snackPosition: SnackPosition.BOTTOM,
          duration: Duration(seconds: 10),
          backgroundColor: Get.theme.snackBarTheme.backgroundColor,
          colorText: Get.theme.snackBarTheme.actionTextColor);
    }
  }

  Future<void> signOut() {
    nameController.clear();
    emailController.clear();
    passwordController.clear();
    NotificationsController.to.removeAllNotifications();
    return _auth.signOut();
  }
}
