import 'package:android_inventory_system/widgets/reusable_botton.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class DeleteProductScreen extends StatefulWidget {
  const DeleteProductScreen({Key? key}) : super(key: key);

  @override
  State<DeleteProductScreen> createState() => _DeleteProductScreenState();
}

class _DeleteProductScreenState extends State<DeleteProductScreen> {
  String _barcodeNumber = 'Barcode number';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Delete Products',
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
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  const Text(
                    'Number:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(color: Colors.white),
                      child: Center(child: Text(_barcodeNumber)),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 50),
              InkWell(
                onTap: () async {
                  await startBarcodeScanStream(context);
                },
                child: ReusableButton(
                  text: 'Scan',
                  containerColor: Color.fromARGB(255, 244, 237, 226),
                ),
              ),
              const SizedBox(height: 40),
              InkWell(
                onTap: () async {
                  if (_barcodeNumber.isNotEmpty) {
                    await deleteProduct(_barcodeNumber);
                    setState(() {
                      _barcodeNumber = 'Barcode number';
                    });
                  }
                },
                child: ReusableButton(
                  text: 'Delete Item',
                  containerColor: Color.fromARGB(255, 244, 237, 226),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> startBarcodeScanStream(BuildContext context) async {
    final barcodeScanResult = await FlutterBarcodeScanner.scanBarcode(
      '#ff6666',
      'Cancel',
      true,
      ScanMode.DEFAULT,
    );

    if (!mounted) return;

    setState(() {
      _barcodeNumber = barcodeScanResult;
    });

    await getProductData(_barcodeNumber);
  }

  Future<void> getProductData(String barcodeNumber) async {
    try {
      final QuerySnapshot<Map<String, dynamic>> snapshot =
          await FirebaseFirestore.instance
              .collection('products')
              .where('barcodeNumber', isEqualTo: barcodeNumber)
              .get();

      if (snapshot.docs.isNotEmpty) {
        final productData = snapshot.docs.first.data();
        setState(() {
          _barcodeNumber = productData['barcodeNumber'];
        });
      } else {
        setState(() {
          _barcodeNumber = 'Product not found';
        });
      }
    } catch (error) {
      print('Error retrieving product data: $error');
      setState(() {
        _barcodeNumber = 'Error retrieving product data';
      });
    }
  }

  Future<void> deleteProduct(String barcodeNumber) async {
    try {
      final QuerySnapshot<Map<String, dynamic>> snapshot =
          await FirebaseFirestore.instance
              .collection('products')
              .where('barcodeNumber', isEqualTo: barcodeNumber)
              .get();

      if (snapshot.docs.isNotEmpty) {
        final productId = snapshot.docs.first.id;
        await FirebaseFirestore.instance
            .collection('products')
            .doc(productId)
            .delete();
        print('Product deleted successfully');
      } else {
        print('Product not found');
      }
    } catch (error) {
      print('Error deleting product: $error');
    }
  }
}
