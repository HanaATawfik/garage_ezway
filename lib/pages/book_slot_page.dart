import 'package:flutter/material.dart';

class BookSlotPage extends StatelessWidget {
  const BookSlotPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2E5F65),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Garage EZway",
          style: TextStyle(
            color: Colors.white,
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle, color: Colors.white, size: 30),
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 30),
            const Text(
              "Book a Slot",
              style: TextStyle(
                color: Colors.white,
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            _slotSelectionField("Select Date", Icons.date_range),
            const SizedBox(height: 15),
            _slotSelectionField("Select Time", Icons.access_time),
            const SizedBox(height: 15),
            _slotSelectionField("Choose Vehicle", Icons.directions_car),
            const SizedBox(height: 15),
            _slotSelectionField("Select Slot", Icons.local_parking),
            const Spacer(),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // action
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFabdbe3),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                ),
                child: const Text(
                  "Confirm Booking",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: const Color(0xFF2E5F65),
        shape: const CircularNotchedRectangle(),
        notchMargin: 10.0,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(icon: const Icon(Icons.home, color: Colors.white, size: 30), onPressed: () {}),
              IconButton(icon: const Icon(Icons.directions_car, color: Colors.white, size: 30), onPressed: () {}),
              IconButton(icon: const Icon(Icons.search, color: Colors.white, size: 30), onPressed: () {}),
            ],
          ),
        ),
      ),
    );
  }

  Widget _slotSelectionField(String label, IconData icon) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.3),
        borderRadius: BorderRadius.circular(15),
      ),
      child: ListTile(
        leading: Icon(icon, color: Colors.white),
        title: Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        trailing: const Icon(Icons.arrow_drop_down, color: Colors.white),
        onTap: () {
          // Implement onTap behavior here
        },
      ),
    );
  }
}
