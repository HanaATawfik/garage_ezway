// services/booking_storage.dart
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/booking.dart';

class BookingStorage {
  static const _key = 'booking_history';

  static Future<void> saveBooking(Booking booking) async {
    final prefs = await SharedPreferences.getInstance();
    final history = await getBookingHistory();
    history.add(booking);

    final jsonList =
        history
            .map(
              (b) => jsonEncode({
                'time': b.time.toIso8601String(),
                'location': b.location,
                'amount': b.amount,
              }),
            )
            .toList();

    await prefs.setStringList(_key, jsonList);
  }

  static Future<List<Booking>> getBookingHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = prefs.getStringList(_key) ?? [];

    return jsonList.map((json) {
      final map = jsonDecode(json);
      return Booking(
        time: DateTime.parse(map['time']),
        location: map['location'],
        amount: map['amount'],
      );
    }).toList();
  }
}
