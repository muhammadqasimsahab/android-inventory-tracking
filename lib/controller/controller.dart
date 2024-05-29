import 'package:android_inventory_system/model/model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../utils/app_urls.dart';

class SignUpController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  var isHidden = true.obs;

  Future<UserCredential?> signUpMethod(
    String userName,
    String userEmail,
    String userPassword,
  ) async {
    try {
      EasyLoading.show(status: "Please wait");
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
              email: userEmail, password: userPassword);

      // send email verification
      await userCredential.user!.sendEmailVerification();

      UserModel userModel = UserModel(
        uId: userCredential.user!.uid,
        username: userName,
        email: userEmail,
        password: userPassword,
        createdOn: DateTime.now(),
      );

      // add data into database
      _firestore
          .collection('users')
          .doc(userCredential.user!.uid)
          .set(userModel.toMap());
      EasyLoading.dismiss();
      return userCredential;
    } on FirebaseAuthException catch (e) {
      EasyLoading.dismiss();
      Get.snackbar(
        "Error",
        "$e",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.grey,
        colorText: Colors.white,
      );
    }
  }

  Future<void> updateUsernameInFirestore(String userId, String username) async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(userId).update({
        'username': username,
      });
    } catch (e) {
      print('Error updating username in Firestore: $e');
    }
  }

  GlobalKey<FormState> login = GlobalKey<FormState>();

  FormValidation() {
    if (!login.currentState!.validate()) {
      print('Form is Not valid');
    } else {
      print("form are valid");
    }
  }

  String? validateMobile(String value) {
    // Indian Mobile number are of 10 digit only
    if (value.length != 10) {
      return 'Mobile Number must be of 10 digit';
    } else {
      return null;
    }
  }
}
