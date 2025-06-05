import 'package:flutter/material.dart';

class ParkingReceiptScreen extends StatelessWidget {
  const ParkingReceiptScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212), // dark theme
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100),
        child: _TopNavigationBar(),
      ),
      body: const _ReceiptBody(),
      bottomNavigationBar: _BottomPayButton(),
    );
  }
}
