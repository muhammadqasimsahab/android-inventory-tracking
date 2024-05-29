import 'package:android_inventory_system/ui/add_product.dart';
import 'package:android_inventory_system/ui/auth/login_activity.dart';
import 'package:android_inventory_system/ui/delete_product.dart';
import 'package:android_inventory_system/ui/view_inventory.dart';
import 'package:android_inventory_system/ui/view_product.dart';
import 'package:android_inventory_system/widgets/home_container.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Color> colors = const [
    Color(0xffDAD3C8),
    Color(0xffFFE5DE),
    Color(0xffDCF6E6),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 243, 235, 233),
      appBar: AppBar(
        title: const Text('Androind Inventory',
            style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w500,
                fontSize: 18,
                height: 1)),
        centerTitle: true,
        toolbarHeight: 50,
        automaticallyImplyLeading: false,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(colors: [
              Color.fromARGB(255, 242, 231, 213),
              Color.fromARGB(255, 173, 250, 201),
            ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
          ),
        ),
        actions: [
          IconButton(
              padding: const EdgeInsets.only(right: 20),
              onPressed: () async {
                await AuthService.logout();

                Get.to(() => const LoginScreen());
              },
              icon: const Icon(Icons.logout, size: 25))
        ],
      ),
      body: Center(
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: Container(
                width: 100,
                height: 100,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(colors: [
                    Color.fromARGB(255, 242, 231, 213),
                    Color.fromARGB(255, 173, 250, 201),
                  ]),
                  borderRadius:
                      BorderRadius.only(bottomLeft: Radius.circular(90)),
                ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () {
                        Get.to(() => const AddProductScreen());
                      },
                      child: HomeContainer(
                          text: 'Add Product', image: 'assets/images/cart.png'),
                    ),
                    const SizedBox(width: 20),
                    InkWell(
                      onTap: () {
                        Get.to(const DeleteProductScreen());
                      },
                      child: HomeContainer(
                          text: 'Delete Product',
                          image: 'assets/images/remove-item.png'),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () {
                        Get.to(() => const ViewProductScreen());
                      },
                      child: HomeContainer(
                          text: 'View Product',
                          image: 'assets/images/application.png'),
                    ),
                    const SizedBox(width: 20),
                    InkWell(
                      onTap: () {
                        Get.to(() => const AllProductsScreen());
                      },
                      child: HomeContainer(
                          text: 'View Inventory',
                          image: 'assets/images/shopping.png'),
                    ),
                  ],
                )
              ],
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: Container(
                width: 100,
                height: 100,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color.fromARGB(255, 242, 231, 213),
                      Color.fromARGB(255, 173, 250, 201),
                    ],
                  ),
                  borderRadius:
                      BorderRadius.only(topRight: Radius.circular(90)),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(colors: [
            Color.fromARGB(255, 242, 231, 213),
            Color.fromARGB(255, 173, 250, 201),
          ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
        ),
        child: const Text(
          'Android Inventory Tracking',
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

class AuthService {
  static Future<void> logout() async {
    try {
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      print('Error occurred during logout: $e');
    }
  }
}
