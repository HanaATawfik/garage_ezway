// lib/pages/admin/admin_dashboard.dart
                  import 'package:flutter/material.dart';
                  import '../model/user_model.dart';
                  import '../service/user_service.dart';

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
                      setState(() {
                        _isLoading = true;
                      });

                      try {
                        final users = await _userService.getAllUsers();
                        setState(() {
                          _users = users;
                        });
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Error loading users: $e')),
                        );
                      } finally {
                        setState(() {
                          _isLoading = false;
                        });
                      }
                    }

                    Future<void> _toggleBlacklist(User user) async {
                      try {
                        // Toggle the blacklist status
                        final updatedUser = user.copyWith(
                          isBlacklisted: !(user.isBlacklisted ?? false),
                        );

                        await _userService.updateUser(updatedUser);

                        // Refresh the user list to show updated status
                        _loadUsers();

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              '${user.name} has been ${updatedUser.isBlacklisted! ? 'blacklisted' : 'removed from blacklist'}'
                            ),
                            backgroundColor: updatedUser.isBlacklisted! ? Colors.red : Colors.green,
                          ),
                        );
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Failed to update user status: $e')),
                        );
                      }
                    }

                    @override
                    Widget build(BuildContext context) {
                      return Scaffold(
                        appBar: AppBar(
                          title: const Text('Admin Dashboard'),
                          backgroundColor: const Color(0xFF0F1E2F),
                        ),
                        body: _isLoading
                            ? const Center(child: CircularProgressIndicator())
                            : _users.isEmpty
                                ? const Center(child: Text('No users registered yet',
                                    style: TextStyle(fontSize: 18)))
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

                                            // Vehicles section
                                            if (user.vehicles.isNotEmpty)
                                              Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    const Text('Vehicles',
                                                      style: TextStyle(fontWeight: FontWeight.bold)),
                                                    const SizedBox(height: 8),
                                                    ...user.vehicles.map((vehicle) => ListTile(
                                                      title: Text(vehicle.model),
                                                      subtitle: Text('License: ${vehicle.licensePlate}'),
                                                      leading: const Icon(Icons.directions_car),
                                                    )),
                                                  ],
                                                ),
                                              ),

                                            // Bookings section
                                            if (user.bookings.isNotEmpty)
                                              Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    const Text('Bookings',
                                                      style: TextStyle(fontWeight: FontWeight.bold)),
                                                    const SizedBox(height: 8),
                                                    ...user.bookings.map((booking) => ListTile(
                                                      title: Text('Location: ${booking.location}'),
                                                      subtitle: Text('Time: ${booking.time.toString().substring(0, 16)}'),
                                                      trailing: Text('\$${booking.amount.toStringAsFixed(2)}'),
                                                      leading: const Icon(Icons.local_parking),
                                                    )),
                                                  ],
                                                ),
                                              ),

                                            // Blacklist toggle button
                                            Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                                              child: ElevatedButton(
                                                onPressed: () => _toggleBlacklist(user),
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: isBlacklisted ? Colors.green : Colors.red,
                                                  foregroundColor: Colors.white,
                                                ),
                                                child: Text(isBlacklisted ? 'Remove from Blacklist' : 'Blacklist User'),
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