// lib/pages/model/user_model.dart
import 'vehicle_model.dart';
import 'booking.dart';

class User {
  final String id;
  final String name;
  final String email;
  final String password;
  final String? phoneNumber;
  final List<Vehicle> vehicles;
  final List<Booking> bookings;
  final bool? isBlacklisted;  // Changed to nullable

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    this.phoneNumber,
    this.vehicles = const [],
    this.bookings = const [],
    this.isBlacklisted = false,  // Default remains false
  });

  // copyWith method remains the same
  User copyWith({
    String? id,
    String? name,
    String? email,
    String? password,
    String? phoneNumber,
    List<Vehicle>? vehicles,
    List<Booking>? bookings,
    bool? isBlacklisted,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      vehicles: vehicles ?? this.vehicles,
      bookings: bookings ?? this.bookings,
      isBlacklisted: isBlacklisted ?? this.isBlacklisted,
    );
  }

  // toJson and fromJson methods remain the same
  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'email': email,
    'password': password,
    'phoneNumber': phoneNumber,
    'vehicles': vehicles.map((v) => v.toJson()).toList(),
    'bookings': bookings.map((b) => b.toJson()).toList(),
    'isBlacklisted': isBlacklisted,
  };

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json['id'],
    name: json['name'],
    email: json['email'],
    password: json['password'],
    phoneNumber: json['phoneNumber'],
    vehicles: (json['vehicles'] as List?)?.map((v) => Vehicle.fromJson(v as Map<String, dynamic>)).toList() ?? [],
    bookings: (json['bookings'] as List?)?.map((b) => Booking.fromJson(b as Map<String, dynamic>)).toList() ?? [],
    isBlacklisted: json['isBlacklisted'] ?? false,
  );
}