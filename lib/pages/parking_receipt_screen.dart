import 'package:flutter/material.dart';

class ParkingReceiptScreen extends StatelessWidget {
  final String mallName;
  final int floor;
  final String slotId;
  final DateTime startTime;
  final DateTime? endTime;

  const ParkingReceiptScreen({
    Key? key,
    required this.mallName,
    required this.floor,
    required this.slotId,
    required this.startTime,
    this.endTime,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Calculate end time if not provided (default: start time + 2 hours)
    final DateTime calculatedEndTime = endTime ?? startTime.add(const Duration(hours: 2));

    return Scaffold(
      backgroundColor: const Color(0xFF0F1E2F),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Garage EZway",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: _ReceiptBody(
        mallName: mallName,
        floor: floor,
        slotId: slotId,
        startTime: startTime,
        endTime: calculatedEndTime,
      ),
      bottomNavigationBar: _BottomPayButton(),
    );
  }
}

class _ReceiptBody extends StatelessWidget {
  final String mallName;
  final int floor;
  final String slotId;
  final DateTime startTime;
  final DateTime endTime;

  const _ReceiptBody({
    required this.mallName,
    required this.floor,
    required this.slotId,
    required this.startTime,
    required this.endTime,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _ReceiptCard(
              mallName: mallName,
              floor: floor,
              slotId: slotId,
              startTime: startTime,
              endTime: endTime,
            ),
          ],
        ),
      ),
    );
  }
}

class _ReceiptCard extends StatelessWidget {
  final String mallName;
  final int floor;
  final String slotId;
  final DateTime startTime;
  final DateTime endTime;

  const _ReceiptCard({
    required this.mallName,
    required this.floor,
    required this.slotId,
    required this.startTime,
    required this.endTime,
  });

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
              child: Text(
                "PARKING RECEIPT",
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Center(
              child: Text(
                "${startTime.day}/${startTime.month}/${startTime.year}",
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 18,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                const Icon(Icons.local_parking, color: Colors.white, size: 36),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    "$mallName Parking",
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 20,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              "FROM: ${_formatDateTime(startTime)}",
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 18,
              ),
            ),
            Text(
              "TO: ${_formatDateTime(endTime)}",
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 18,
              ),
            ),
            Text(
              "SLOT: $slotId, ${_getFloorText(floor)}",
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 20),
            const Align(
              alignment: Alignment.center,
              child: Text(
                "TOTAL: EGP 10.00",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                color: Colors.grey[800],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  const Text(
                    "PAYMENT STATUS",
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "PENDING",
                    style: TextStyle(
                      color: Colors.orange,
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    return "${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')} ${dateTime.day}/${dateTime.month}/${dateTime.year}";
  }

  String _getFloorText(int floor) {
    if (floor == 1) return "1st Floor";
    if (floor == 2) return "2nd Floor";
    if (floor == 3) return "3rd Floor";
    return "${floor}th Floor";
  }
}

class _BottomPayButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: ElevatedButton.icon(
        onPressed: () {
          // Handle payment
          Navigator.pop(context);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF46B1A1),
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        icon: const Icon(Icons.arrow_forward, color: Colors.white, size: 26),
        label: const Text(
          "PAY TICKET",
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          )
        ),
      ),
    );
  }
}