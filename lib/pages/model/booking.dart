class Booking {
  final DateTime time;
  final String location;
  final double amount;

  Booking({required this.time, required this.location, required this.amount});

  Map<String, dynamic> toJson() => {
    'time': time.toIso8601String(),
    'location': location,
    'amount': amount,
  };

  static Booking fromJson(Map<String, dynamic> json) => Booking(
    time: DateTime.parse(json['time']),
    location: json['location'],
    amount: json['amount'],
  );
}
