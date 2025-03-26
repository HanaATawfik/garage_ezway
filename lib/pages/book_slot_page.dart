import 'package:flutter/material.dart';

class BookSlotPage extends StatelessWidget {
  const BookSlotPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2E5F65), // Set Background Color
      appBar: AppBar(
        title: const Text('Book Slot'),
        backgroundColor: Colors.black, // Optional
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Slot Booked Successfully!")),
            );
          },
          child: const Text('Confirm Booking'),
        ),
      ),
    );
  }
}
