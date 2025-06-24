import 'package:flutter/material.dart';
      import '../model/user_model.dart';
      import '../model/booking.dart'; // Import the Booking model
      import '../service/user_service.dart';
      import 'admin_home.dart';

      class AdminDashboard extends StatefulWidget {
        const AdminDashboard({Key? key}) : super(key: key);

        @override
        _AdminDashboardState createState() => _AdminDashboardState();
      }

      class _AdminDashboardState extends State<AdminDashboard> {
        final UserService _userService = UserService();
        List<User> _users = [];
        bool _isLoading = true;

        @override
        void initState() {
          super.initState();
          _loadUsers();
        }

        Future<void> _loadUsers() async {
          setState(() => _isLoading = true);
          try {
            final users = await _userService.getAllUsers();
            if (mounted) {
              setState(() => _users = users);
            }
          } catch (e) {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Error loading users: $e')),
              );
            }
          } finally {
            if (mounted) {
              setState(() => _isLoading = false);
            }
          }
        }

        Future<void> _toggleBlacklist(User user) async {
          try {
            final updatedUser = user.copyWith(
              isBlacklisted: !(user.isBlacklisted ?? false),
            );

            await _userService.updateUser(updatedUser);
            await _loadUsers();

            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    '${user.name} has been ${updatedUser.isBlacklisted! ? 'blacklisted' : 'removed from blacklist'}',
                  ),
                  backgroundColor:
                  updatedUser.isBlacklisted! ? Colors.red : Colors.green,
                ),
              );
            }
          } catch (e) {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Failed to update user status: $e')),
              );
            }
          }
        }

        void _showBookingDetails(BuildContext context, Booking booking) {
          showDialog(
            context: context,
            builder: (context) => Dialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF0F1E2F),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        "BOOKING DETAILS",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Card(
                        color: Colors.grey[900],
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ListTile(
                                leading: const Icon(Icons.location_on, color: Colors.white),
                                title: const Text("Location", style: TextStyle(color: Colors.grey)),
                                subtitle: Text(booking.location, style: const TextStyle(color: Colors.white)),
                              ),
                              ListTile(
                                leading: const Icon(Icons.access_time, color: Colors.white),
                                title: const Text("Time", style: TextStyle(color: Colors.grey)),
                                subtitle: Text(booking.time.toString().substring(0, 16),
                                    style: const TextStyle(color: Colors.white)),
                              ),
                              ListTile(
                                leading: const Icon(Icons.attach_money, color: Colors.white),
                                title: const Text("Amount", style: TextStyle(color: Colors.grey)),
                                subtitle: Text("\$${booking.amount.toStringAsFixed(2)}",
                                    style: const TextStyle(color: Colors.white)),
                              ),
                              // Add any additional booking details that exist in your model
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF46B1A1),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          child: Text("CLOSE", style: TextStyle(color: Colors.white)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }

        @override
        Widget build(BuildContext context) {
          return Scaffold(
            appBar: AppBar(
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () {
                  if (Navigator.of(context).canPop()) {
                    Navigator.of(context).pop();
                  } else {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (_) => const AdminHomePage()),
                    );
                  }
                },
              ),
              title: const Text(
                'Admin Dashboard',
                style: TextStyle(color: Colors.white),
              ),
              backgroundColor: const Color(0xFF0F1E2F),
              iconTheme: const IconThemeData(color: Colors.white),
              foregroundColor: Colors.white,
            ),
            body: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _users.isEmpty
                ? const Center(
              child: Text('No users registered yet',
                  style: TextStyle(fontSize: 18)),
            )
                : ListView.builder(
              itemCount: _users.length,
              itemBuilder: (context, index) {
                final user = _users[index];
                final isBlacklisted = user.isBlacklisted ?? false;

                return Card(
                  margin: const EdgeInsets.all(8.0),
                  child: ExpansionTile(
                    title: Row(
                      children: [
                        Expanded(child: Text(user.name)),
                        if (isBlacklisted)
                          const Chip(
                            label: Text('Blacklisted'),
                            backgroundColor: Colors.red,
                            labelStyle: TextStyle(color: Colors.white),
                          ),
                      ],
                    ),
                    subtitle: Text(user.email),
                    children: [
                      if (user.phoneNumber != null)
                        ListTile(
                          title: const Text('Phone Number'),
                          subtitle: Text(user.phoneNumber!),
                        ),
                      if (user.vehicles.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Vehicles',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold)),
                              const SizedBox(height: 8),
                              ...user.vehicles.map((vehicle) => ListTile(
                                title: Text(vehicle.model),
                                subtitle: Text(
                                    'License: ${vehicle.licensePlate}'),
                                leading:
                                const Icon(Icons.directions_car),
                              )),
                            ],
                          ),
                        ),
                      if (user.bookings.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Bookings',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold)),
                              const SizedBox(height: 8),
                              ...user.bookings.map((booking) => InkWell(
                                onTap: () => _showBookingDetails(context, booking),
                                child: Card(
                                  color: Colors.grey.shade100,
                                  margin: const EdgeInsets.only(bottom: 8),
                                  child: ListTile(
                                    title: Text(
                                        'Location: ${booking.location}'),
                                    subtitle: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Time: ${booking.time.toString().substring(0, 16)}',
                                        ),
                                        Text(
                                          'Amount: \$${booking.amount.toStringAsFixed(2)}',
                                        ),
                                      ],
                                    ),
                                    leading: const Icon(Icons.local_parking),
                                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                                    isThreeLine: true,
                                  ),
                                ),
                              )),
                            ],
                          ),
                        ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 8.0),
                        child: ElevatedButton(
                          onPressed: () => _toggleBlacklist(user),
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                            isBlacklisted ? Colors.green : Colors.red,
                            foregroundColor: Colors.white,
                          ),
                          child: Text(isBlacklisted
                              ? 'Remove from Blacklist'
                              : 'Blacklist User'),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: _loadUsers,
              backgroundColor: const Color(0xFF0F1E2F),
              child: const Icon(Icons.refresh),
            ),
          );
        }
      }