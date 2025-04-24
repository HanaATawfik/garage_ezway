import 'package:flutter/material.dart';
import 'pages/home_page.dart';

import 'pages/payment_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Garage EZway',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        fontFamily: 'Roboto', // Optional if you want to match font style
      ),
      home: const PaymentPage(), // 👈 Set PaymentPage here
    );
  }
}
