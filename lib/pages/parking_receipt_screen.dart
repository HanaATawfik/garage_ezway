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
class _ReceiptCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey[900],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Text("PARKING RECEIPT", style: TextStyle(color: Colors.grey, fontSize: 18)),
            ),
            const SizedBox(height: 10),
            const Center(
              child: Text("12/11/2024", style: TextStyle(color: Colors.grey)),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Icon(Icons.local_parking, color: Colors.white),
                const SizedBox(width: 12),
                const Text("Mall of Egypt Parking", style: TextStyle(color: Colors.grey, fontSize: 16)),
              ],
            ),
            const SizedBox(height: 20),
            const Text("FROM : 7:45 1/1/25", style: TextStyle(color: Colors.grey)),
            const Text("TO : 9:52 1/1/25", style: TextStyle(color: Colors.grey)),
            const Text("SLOT : A3 , Floor 1", style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 20),
            Align(
              alignment: Alignment.centerRight,
              child: Text("TOTAL: 24.00",
                  style: TextStyle(
                    color: Colors.grey[300],
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  )),
            ),
            const SizedBox(height: 20),
            Container(
              height: 60,
              width: double.infinity,
              color: Colors.grey[700], // Placeholder for barcode
              alignment: Alignment.center,
              child: const Text("|| ||| ||||| |", style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
