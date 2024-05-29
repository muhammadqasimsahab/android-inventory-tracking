import 'package:android_inventory_system/ui/auth/login_activity.dart';
import 'package:android_inventory_system/ui/auth/signup.dart';
import 'package:android_inventory_system/widgets/reusable_botton.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RoleScreen extends StatefulWidget {
  const RoleScreen({super.key});

  @override
  State<RoleScreen> createState() => _RoleScreenState();
}

class _RoleScreenState extends State<RoleScreen> {
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
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/images/splash_image1.png', width: 280),
              const SizedBox(height: 40),
              const Text('Product inventory Tracking',
                  style: TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.w800,
                      color: Color.fromARGB(255, 7, 106, 187))),
              const SizedBox(height: 40),
              InkWell(
                onTap: () {
                  Get.to(() => const LoginScreen());
                },
                child: const ReusableButton(
                    icon: Icons.person,
                    text: 'Log In',
                    containerColor: Color(0xffFFE5DE)),
              ),
              const SizedBox(height: 20),
              InkWell(
                onTap: () {
                  Get.to(() => const SignUpScreen());
                },
                child: const ReusableButton(
                    icon: Icons.person_add,
                    text: 'Sign Up',
                    containerColor: Color.fromARGB(255, 244, 237, 226)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
