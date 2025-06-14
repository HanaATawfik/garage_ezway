// lib/pages/service/user_service.dart
    import 'dart:convert';
    import 'package:shared_preferences/shared_preferences.dart';
    import '../model/user_model.dart';
    import '../model/vehicle_model.dart';
    import '../model/booking.dart'; // Changed to match existing file

    class UserService {
      static const String _usersKey = 'all_users';
      static const String _currentUserKey = 'current_user_id';

      // Get all users (for admin)
      Future<List<User>> getAllUsers() async {
        final prefs = await SharedPreferences.getInstance();
        final String? usersJson = prefs.getString(_usersKey);
        if (usersJson == null) return [];

        final List<dynamic> usersList = jsonDecode(usersJson);
        return usersList.map((json) => User.fromJson(json)).toList();
      }

      // Register new user
      Future<User> registerUser(String name, String email, String password) async {
        final prefs = await SharedPreferences.getInstance();

        // Create unique ID
        final String userId = DateTime.now().millisecondsSinceEpoch.toString();

        // Create new user
        final newUser = User(
          id: userId,
          name: name,
          email: email,
          password: password,
        );

        // Get existing users
        List<User> users = await getAllUsers();
        users.add(newUser);

        // Save all users
        await prefs.setString(_usersKey, jsonEncode(users.map((u) => u.toJson()).toList()));

        // Set current user ID
        await prefs.setString(_currentUserKey, userId);

        // Save individual user fields for backward compatibility
        await prefs.setString('name', name);
        await prefs.setString('email', email);

        return newUser;
      }

      // Get current logged in user
      Future<User?> getCurrentUser() async {
        final prefs = await SharedPreferences.getInstance();
        final String? userId = prefs.getString(_currentUserKey);
        if (userId == null) return null;

        final users = await getAllUsers();
        return users.firstWhere((user) => user.id == userId, orElse: () => throw Exception('User not found'));
      }

      // Update user information
      Future<User> updateUser(User updatedUser) async {
        final prefs = await SharedPreferences.getInstance();

        // Get all users
        List<User> users = await getAllUsers();

        // Replace the user with updated version
        final int userIndex = users.indexWhere((u) => u.id == updatedUser.id);
        if (userIndex == -1) throw Exception('User not found');

        users[userIndex] = updatedUser;

        // Save updated list
        await prefs.setString(_usersKey, jsonEncode(users.map((u) => u.toJson()).toList()));

        // Update individual fields for backward compatibility
        if (updatedUser.id == prefs.getString(_currentUserKey)) {
          await prefs.setString('name', updatedUser.name);
          await prefs.setString('email', updatedUser.email);
          if (updatedUser.phoneNumber != null) {
            await prefs.setString('phone', updatedUser.phoneNumber!);
          }
        }

        return updatedUser;
      }

      // Add vehicle to user
      Future<User> addVehicleToCurrentUser(Vehicle vehicle) async {
        final user = await getCurrentUser();
        if (user == null) throw Exception('No user logged in');

        final updatedVehicles = [...user.vehicles, vehicle];
        final updatedUser = user.copyWith(
          vehicles: updatedVehicles,
        );

        return updateUser(updatedUser);
      }

      // Add booking to user with your existing Booking model
      Future<User> addBookingToCurrentUser(Booking booking) async {
        final user = await getCurrentUser();
        if (user == null) throw Exception('No user logged in');

        final updatedBookings = [...user.bookings, booking];
        final updatedUser = user.copyWith(
          bookings: updatedBookings,
        );

        return updateUser(updatedUser);
      }

      // Login user
      Future<User> loginUser(String email, String password) async {
        final users = await getAllUsers();
        final user = users.firstWhere(
          (u) => u.email == email && u.password == password,
          orElse: () => throw Exception('Invalid email or password'),
        );

        // Set as current user
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(_currentUserKey, user.id);

        // For backward compatibility
        await prefs.setString('name', user.name);
        await prefs.setString('email', user.email);
        if (user.phoneNumber != null) {
          await prefs.setString('phone', user.phoneNumber!);
        }

        return user;
      }

      // Logout
      Future<void> logout() async {
        final prefs = await SharedPreferences.getInstance();
        await prefs.remove(_currentUserKey);
      }
    }