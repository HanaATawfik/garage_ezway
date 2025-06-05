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
class _TopNavigationBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color(0xFF121212),
      elevation: 0,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(Icons.menu, color: Colors.grey[300]),
              RichText(
                text: TextSpan(
                  text: 'GARAGE ',
                  style: TextStyle(
                    fontFamily: 'Pacifico',
                    fontSize: 20,
                    color: Colors.grey[300],
                  ),
                  children: const [
                    TextSpan(
                      text: 'Ezwaq',
                      style: TextStyle(color: Colors.white),
                    )
                  ],
                ),
              ),
              CircleAvatar(
                backgroundImage: AssetImage('assets/user.jpg'), // put image in assets
                radius: 18,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _TabItem(title: 'HOME'),
              _TabItem(title: 'MY SESSION', selected: true),
              _TabItem(title: 'HISTORY'),
              _TabItem(title: 'SETTINGS'),
            ],
          ),
        ],
      ),
    );
  }
}

class _TabItem extends StatelessWidget {
  final String title;
  final bool selected;

  const _TabItem({required this.title, this.selected = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      decoration: selected
          ? BoxDecoration(
              color: Colors.grey[800],
              borderRadius: BorderRadius.circular(12),
            )
          : null,
      child: Text(title, style: TextStyle(color: Colors.grey[300])),
    );
  }
}
class _ReceiptBody extends StatelessWidget {
  const _ReceiptBody();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: CircleAvatar(
              backgroundColor: Colors.grey[700],
              child: Icon(Icons.chevron_left, color: Colors.white),
            ),
          ),
          const SizedBox(height: 16),
          const Text('TICKET',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              )),
          const SizedBox(height: 20),
          _ReceiptCard(),
        ],
      ),
    );
  }
}
