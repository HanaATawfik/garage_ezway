import 'package:flutter/material.dart';

class PaymentPage extends StatelessWidget {
  const PaymentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2E5F65), // Set Background Color
      appBar: AppBar(
        title: const Text('Payment Page'),
        backgroundColor: Colors.black, // Optional
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Payment Successful!")),
            );
          },
          child: const Text('Pay Now'),
        ),
      ),
    );
  }
}
