import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../widgets/reusable_botton.dart';
import '../../widgets/reusable_textfiled.dart';
import '../home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false;
  final int _currentPage = 2;
  List colors = const [
    Color(0xffDAD3C8),
    Color(0xffFFE5DE),
    Color(0xffDCF6E6),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colors[_currentPage],
      body: Stack(
        children: [
          Center(
            child: Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),
                    ReUsableTextField(
                        hintText: 'Email',
                        icon1: Icons.email,
                        controller: _emailController),
                    const SizedBox(height: 20),
                    ReUsableTextField(
                        hintText: 'Password',
                        icon1: Icons.lock,
                        controller: _passwordController),
                    const SizedBox(height: 90),
                    InkWell(
                      onTap: () async {
                        if (_formKey.currentState!.validate()) {
                          setState(() {
                            _isLoading = true;
                          });

                          String email = _emailController.text.trim();
                          String password = _passwordController.text.trim();

                          try {
                            UserCredential userCredential = await FirebaseAuth
                                .instance
                                .signInWithEmailAndPassword(
                              email: email,
                              password: password,
                            );

                            if (userCredential.user != null) {
                              Get.off(() => const HomeScreen());
                            }
                          } catch (e) {
                            Get.snackbar('Error', '$e',
                                snackPosition: SnackPosition.BOTTOM,
                                backgroundColor: Colors.grey,
                                colorText: Colors.white);
                          } finally {
                            setState(() {
                              _isLoading = false;
                            });
                          }
                        }
                      },
                      child: const ReusableButton(
                        text: "Log In",
                        containerColor: Color.fromARGB(255, 244, 237, 226),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }
}
