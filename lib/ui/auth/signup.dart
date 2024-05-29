import 'package:android_inventory_system/widgets/reusable_botton.dart';
import 'package:android_inventory_system/widgets/reusable_textfiled.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:android_inventory_system/ui/auth/login_activity.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  List<Color> colors = const [
    Color(0xffDAD3C8),
    Color(0xffFFE5DE),
    Color(0xffDCF6E6),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colors[2],
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Image.asset('assets/images/signup.png'), // Removed image widget
                ReUsableTextField(
                  hintText: 'Name',
                  icon1: Icons.person,
                  controller: _nameController,
                ),
                const SizedBox(height: 20),
                ReUsableTextField(
                  hintText: 'Email',
                  icon1: Icons.email,
                  controller: _emailController,
                ),
                const SizedBox(height: 20),
                ReUsableTextField(
                  hintText: 'Password',
                  icon1: Icons.lock,
                  controller: _passwordController,
                ),
                const SizedBox(height: 90),
                InkWell(
                  onTap: () async {
                    if (_formKey.currentState!.validate()) {
                      String name = _nameController.text.trim();
                      String email = _emailController.text.trim();
                      String password = _passwordController.text.trim();

                      try {
                        UserCredential userCredential = await FirebaseAuth
                            .instance
                            .createUserWithEmailAndPassword(
                          email: email,
                          password: password,
                        );

                        await userCredential.user!.sendEmailVerification();

                        Get.snackbar('Verification email sent',
                            'Please Check your email',
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: Colors.grey,
                            colorText: Colors.white);
                        FirebaseAuth.instance.signOut();
                        Get.offAll(() => const LoginScreen());
                      } catch (e) {
                        Get.snackbar('Error', '$e',
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: Colors.grey,
                            colorText: Colors.white);
                      }
                    }
                  },
                  child: const ReusableButton(
                    icon: null,
                    text: 'Register',
                    containerColor: Color.fromARGB(255, 244, 237, 226),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
