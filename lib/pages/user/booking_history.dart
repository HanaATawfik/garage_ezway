// lib/pages/user/booking_history.dart
    import 'package:flutter/material.dart';
    import '../model/booking.dart';
    import '../service/booking_storage.dart';

    class HistoryPage extends StatefulWidget {
      const HistoryPage({Key? key}) : super(key: key);

      @override
      State<HistoryPage> createState() => _HistoryPageState();
    }

    class _HistoryPageState extends State<HistoryPage> {
      List<Booking> bookings = [];
      bool isLoading = true;

      @override
      void initState() {
        super.initState();
        loadBookings();
      }

      Future<void> loadBookings() async {
        final history = await BookingStorage.getBookingHistory();
        setState(() {
          bookings = history;
          isLoading = false;
        });
      }

      @override
      Widget build(BuildContext context) {
        return Scaffold(
          backgroundColor: const Color(0xFF0F1E2F),
          appBar: AppBar(
            backgroundColor: const Color(0xFF0F1E2F),
            elevation: 0,
            title: const Text(
              'Booking History',
              style: TextStyle(color: Colors.white),
            ),
            iconTheme: const IconThemeData(color: Colors.white),
            actions: [
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: loadBookings,
              ),
            ],
          ),
          body: isLoading
              ? const Center(
                  child: CircularProgressIndicator(
                    color: Colors.teal,
                  ),
                )
              : bookings.isEmpty
                  ? const Center(
                      child: Text(
                        'No bookings yet.',
                        style: TextStyle(color: Colors.white70),
                      ),
                    )
                  : ListView.builder(
                      itemCount: bookings.length,
                      padding: const EdgeInsets.all(16),
                      itemBuilder: (context, index) {
                        final b = bookings[index];
                        return Card(
                          color: Colors.white.withOpacity(0.1),
                          margin: const EdgeInsets.only(bottom: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(16),
                            leading: const CircleAvatar(
                              backgroundColor: Colors.teal,
                              child: Icon(
                                Icons.local_parking,
                                color: Colors.white,
                              ),
                            ),
                            title: Text(
                              'Location: ${b.location}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(
                                'Time: ${b.time.toString().substring(0, 16)}\nAmount: \$${b.amount.toStringAsFixed(2)}',
                                style: const TextStyle(color: Colors.white70),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
        );
      }
    }