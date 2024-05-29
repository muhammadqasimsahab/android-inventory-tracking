import 'package:android_inventory_system/utils/constant_colors.dart';
import 'package:android_inventory_system/widgets/reusable_botton.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

import 'home_screen.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  String _barcodeNumber = 'Barcode number';
  bool _isLoading = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _productController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 243, 235, 233),
      appBar: AppBar(
        title: const Text('Add Products',
            style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 22,
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
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
            ),
          ),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    const Text('Product:',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(width: 20),
                    Expanded(
                      child: TextFormField(
                        controller: _productController,
                        decoration: const InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    const Text('Category:',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(width: 9),
                    Expanded(
                      child: TextFormField(
                        controller: _categoryController,
                        decoration: const InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            border: InputBorder.none),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    const Text('Price:',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(width: 43),
                    Expanded(
                      child: TextFormField(
                        controller: _priceController,
                        decoration: const InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            border: InputBorder.none),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    const Text(
                      'Number:',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(color: Colors.white),
                        child: Center(
                          child: Text(_barcodeNumber),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.bottomRight,
                  child: SizedBox(
                    height: 50,
                    width: 100,
                    child: ElevatedButton(
                      onPressed: () {
                        startBarcodeScanStream(context);
                      },
                      child: const Text('Scan'),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                InkWell(
                  onTap: () {
                    addProduct();
                  },
                  child: const ReusableButton(
                      text: 'Add Item',
                      containerColor: Color.fromARGB(255, 244, 237, 226)),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> startBarcodeScanStream(BuildContext context) async {
    final barcodeScanResult = await FlutterBarcodeScanner.scanBarcode(
      '#ff6666', // background color
      'Cancel', // cancel button text
      true, // show flash icon
      ScanMode.DEFAULT, // scan mode
    );

    if (!mounted) return;

    setState(() {
      _barcodeNumber = barcodeScanResult;
    });
  }

  Future<void> addProduct() async {
    // Validate form fields
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Extract data from text fields
    String productName = _productController.text.trim();
    String category = _categoryController.text.trim();
    String priceText = _priceController.text.trim();

    // Check if any field is empty
    if (productName.isEmpty || category.isEmpty || priceText.isEmpty) {
      // Show a snackbar if any field is empty
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill all the fields'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Convert price to double
    double price = double.tryParse(priceText) ?? 0.0;

    // Show loading overlay
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    try {
      // Get current user
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        // User not logged in
        Navigator.pop(context); // Dismiss loading overlay
        return;
      }

      // Get user ID
      String userId = user.uid;

      // Construct product data
      Map<String, dynamic> productData = {
        'productName': productName,
        'category': category,
        'price': price,
        'barcodeNumber': _barcodeNumber, // Add the barcode number here
        'userId': userId, // Associate the product with the user who added it
      };

      // Add product to Firestore
      await FirebaseFirestore.instance.collection('products').add(productData);

      // Hide loading overlay
      Navigator.pop(context);

      // Navigate to HomeScreen
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    } catch (error) {
      // Hide loading overlay
      Navigator.pop(context);

      // Handle error
      print('Error adding product: $error');
    }
  }
}
