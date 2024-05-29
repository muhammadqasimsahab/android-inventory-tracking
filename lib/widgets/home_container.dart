import 'package:flutter/material.dart';

class HomeContainer extends StatelessWidget {
  final String text;
  var image;
  HomeContainer({super.key, required this.text, required this.image});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        height: 150,
        width: 150,
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 80,
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border:
                      Border.all(color: const Color(0xffDAD3C8), width: 2.0)),
              child: Image.asset(image),
            ),
            const SizedBox(height: 20),
            Text(
              text,
              // ignore: prefer_const_constructors
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            )
          ],
        ),
      ),
    );
  }
}


//assets/images/remove-item.png