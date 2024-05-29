import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class ViewProductScreen extends StatefulWidget {
  const ViewProductScreen({Key? key}) : super(key: key);

  @override
  State<ViewProductScreen> createState() => _ViewProductScreenState();
}

class _ViewProductScreenState extends State<ViewProductScreen> {
  TextEditingController barcodeController = TextEditingController();
  String productName = '';
  double productPrice = 0.0;
  String productCategory = '';
  String productBarcode = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 243, 235, 233),
      appBar: AppBar(
        title: const Text(
          'View Products',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w500,
            fontSize: 18,
            height: 1,
          ),
        ),
        centerTitle: true,
        toolbarHeight: 50,
        automaticallyImplyLeading: false,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 242, 231, 213),
                Color.fromARGB(255, 173, 250, 201),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: barcodeController,
                    style: const TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      hintText: 'Enter Barcode',
                      hintStyle: const TextStyle(color: Colors.grey),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                // ElevatedButton(
                //   onPressed: () async {
                //     await getProductData(barcodeController.text);
                //   },
                //   child: const Icon(Icons.search),
                // ),
                InkWell(
                  onTap: () async {
                    await getProductData(barcodeController.text);
                  },
                  child: Container(
                    width: 60,
                    height: 65,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      gradient: const LinearGradient(
                        colors: [
                          Color.fromARGB(255, 242, 231, 213),
                          Color.fromARGB(255, 173, 250, 201),
                        ],
                      ),
                    ),
                    child: const Icon(Icons.search),
                  ),
                ),
                SizedBox(width: 10),
                InkWell(
                  onTap: () async {
                    String barcodeScanResult =
                        await FlutterBarcodeScanner.scanBarcode(
                      '#ff6666', // background color
                      'Cancel', // cancel button text
                      true, // show flash icon
                      ScanMode.DEFAULT, // scan mode
                    );

                    if (!mounted) return;

                    barcodeController.text = barcodeScanResult;
                    await getProductData(barcodeScanResult);
                  },
                  child: Container(
                    width: 60,
                    height: 66,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      gradient: const LinearGradient(
                        colors: [
                          Color.fromARGB(255, 242, 231, 213),
                          Color.fromARGB(255, 173, 250, 201),
                        ],
                      ),
                    ),
                    child: const Icon(Icons.camera_alt_outlined),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            if (productName.isNotEmpty)
              Card(
                elevation: 5.0, // Add a slight shadow effect

                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0), // Rounded corners
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0), // Add some padding
                  child: SizedBox(
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start, // Align text to left
                      children: [
                        Text(
                          'Product Name:',
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold, // Bold for title
                          ),
                        ),
                        const SizedBox(height: 5.0), // Add some spacing
                        Text(productName),
                        const SizedBox(height: 5.0),
                        Text(
                          'Price: \$' +
                              productPrice.toStringAsFixed(2), // Format price
                        ),
                        const SizedBox(height: 5.0),
                        Text('Category: $productCategory'),
                        const SizedBox(height: 5.0),
                        Text('Barcode: $productBarcode'),
                      ],
                    ),
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }

  Future<void> getProductData(String barcode) async {
    try {
      final QuerySnapshot<Map<String, dynamic>> snapshot =
          await FirebaseFirestore.instance
              .collection('products')
              .where('barcodeNumber', isEqualTo: barcode)
              .get();

      if (snapshot.docs.isNotEmpty) {
        final productData = snapshot.docs.first.data();
        setState(() {
          productName = productData['productName'];
          productPrice = productData['price'];
          productCategory = productData['category'];
          productBarcode = productData['barcodeNumber'];
        });
      } else {
        setState(() {
          productName = 'Product not found';
          productPrice = 0.0;
          productCategory = '';
          productBarcode = '';
        });
      }
    } catch (error) {
      print('Error retrieving product data: $error');
      setState(() {
        productName = 'Error retrieving product data';
        productPrice = 0.0;
        productCategory = '';
        productBarcode = '';
      });
    }
  }
}
