import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:pumppal/screens/get_started_screen.dart';
import 'package:pumppal/screens/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthController  extends GetxController{

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  final TextEditingController loginEmailController = TextEditingController();
  final TextEditingController loginPasswordController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  String email = '';
  String password = '';

  Future<void> signUp()async{
    if (passwordController.text == confirmPasswordController.text){
      email = emailController.text;
      password = passwordController.text;
      try {
        final newUser = await _auth.createUserWithEmailAndPassword(email: email, password: password);
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('user', newUser.user!.uid);
        Get.to(GetStartedScreen());
      }
      on FirebaseAuthException catch (e) {
        print(e);
      }
    }
    else{
      print("Password and Confirm password are not matched");
    }
    emailController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
  }

  Future<void> logIn()async{
    email = emailController.text;
    password = passwordController.text;
    try {
      final user = await _auth.signInWithEmailAndPassword(email: email, password: password);
      if (user != null) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('user', user.user!.uid);
        print(prefs.getString('user'));
        print("$email is in.");
        Get.to(() => HomeScreen());

      } else {
        print("Login failed");
      }
    }
    on FirebaseAuthException catch (e) {
      print(e);
    }
    emailController.clear();
    passwordController.clear();
  }

  Future<void> logOut()async {
    print("$email is logging out.");
    await _auth.signOut();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
    Get.offAll(HomeScreen());
  }



}