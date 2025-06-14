//personal_info.dart FIXED
            import 'package:flutter/material.dart';
            import 'package:shared_preferences/shared_preferences.dart';
            import 'profile.dart';
            import 'signup.dart';

            class SettingsPage extends StatefulWidget {
              const SettingsPage({super.key});

              @override
              _SettingsPageState createState() => _SettingsPageState();
            }

            class _SettingsPageState extends State<SettingsPage> {
              String _name = "User Name";
              bool _nameEdited = false;
              String _email = "Not Provided";
              String _phoneNumber = "+20 123456789";

              @override
              void initState() {
                super.initState();
                _loadSavedData();
              }

              Future<void> _loadSavedData() async {
                final prefs = await SharedPreferences.getInstance();
                setState(() {
                  _name = prefs.getString('name') ?? _name;
                  _email = prefs.getString('email') ?? _email;
                  _phoneNumber = prefs.getString('phone') ?? _phoneNumber;
                });
              }

              Future<void> _saveName(String name) async {
                final prefs = await SharedPreferences.getInstance();
                await prefs.setString('name', name);
              }

              Future<void> _savePhone(String phone) async {
                final prefs = await SharedPreferences.getInstance();
                await prefs.setString('phone', phone);
              }

              Future<void> _saveEmail(String email) async {
                final prefs = await SharedPreferences.getInstance();
                await prefs.setString('email', email);
              }

              void _editName() async {
                String tempName = _name;

                String? newName = await showDialog<String>(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text("Edit Name"),
                      content: TextField(
                        autofocus: true,
                        decoration: const InputDecoration(hintText: "Enter your name"),
                        onChanged: (value) {
                          tempName = value;
                        },
                        controller: TextEditingController(text: _name),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, null),
                          child: const Text("Cancel"),
                        ),
                        TextButton(
                          onPressed: () {
                            if (tempName.trim().isNotEmpty) {
                              Navigator.pop(context, tempName.trim());
                            }
                          },
                          child: const Text("Save"),
                        ),
                      ],
                    );
                  },
                );

                if (newName != null && newName.isNotEmpty) {
                  setState(() {
                    _name = newName;
                  });
                  await _saveName(newName);
                }
              }

              void _editEmail() async {
                String tempEmail = _email;
                final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

                String? newEmail = await showDialog<String>(
                  context: context,
                  builder: (context) {
                    String? errorText;
                    final controller = TextEditingController(text: _email);

                    return StatefulBuilder(
                      builder: (context, setState) {
                        return AlertDialog(
                          title: const Text("Edit Email"),
                          content: TextField(
                            controller: controller,
                            decoration: InputDecoration(
                              hintText: "Enter your email",
                              errorText: errorText,
                            ),
                            keyboardType: TextInputType.emailAddress,
                            onChanged: (value) {
                              if (!emailRegex.hasMatch(value)) {
                                setState(() {
                                  errorText = "Invalid email format";
                                });
                              } else {
                                setState(() {
                                  errorText = null;
                                });
                              }
                              tempEmail = value;
                            },
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context, null),
                              child: const Text("Cancel"),
                            ),
                            TextButton(
                              onPressed: () {
                                if (emailRegex.hasMatch(tempEmail.trim())) {
                                  Navigator.pop(context, tempEmail.trim());
                                }
                              },
                              child: const Text("Save"),
                            ),
                          ],
                        );
                      },
                    );
                  },
                );

                if (newEmail != null && newEmail.isNotEmpty) {
                  setState(() {
                    _email = newEmail;
                  });
                  await _saveEmail(newEmail);
                }
              }

              void _editPhoneNumber() async {
                String? newPhone = await showDialog<String>(
                  context: context,
                  builder: (context) {
                    final TextEditingController controller = TextEditingController(
                      text: _phoneNumber,
                    );
                    String? errorText;

                    return StatefulBuilder(
                      builder: (context, setState) {
                        void validateInput(String input) {
                          final regex = RegExp(r'^\+20\s?(\d\s?){10}$');
                          if (!regex.hasMatch(input)) {
                            setState(() {
                              errorText =
                                  'Invalid format. Must start with +20 followed by 10 digits.';
                            });
                          } else {
                            setState(() {
                              errorText = null;
                            });
                          }
                        }

                        return AlertDialog(
                          title: const Text("Edit Phone Number"),
                          content: TextField(
                            autofocus: true,
                            keyboardType: TextInputType.phone,
                            decoration: InputDecoration(
                              hintText: "Enter phone number",
                              errorText: errorText,
                            ),
                            controller: controller,
                            onChanged: validateInput,
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context, null),
                              child: const Text("Cancel"),
                            ),
                            TextButton(
                              onPressed: () {
                                if (errorText == null &&
                                    controller.text.trim().isNotEmpty) {
                                  Navigator.pop(context, controller.text.trim());
                                }
                              },
                              child: const Text("Next"),
                            ),
                          ],
                        );
                      },
                    );
                  },
                );

                if (newPhone != null && newPhone.isNotEmpty) {
                  // Simulate sending OTP here
                  String? otp = await showDialog<String>(
                    context: context,
                    builder: (context) {
                      final TextEditingController otpController = TextEditingController();
                      String? otpError;

                      return StatefulBuilder(
                        builder: (context, setState) {
                          return AlertDialog(
                            title: const Text("Verify OTP"),
                            content: TextField(
                              controller: otpController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                hintText: "Enter 6-digit code",
                                errorText: otpError,
                              ),
                              maxLength: 6,
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context, null),
                                child: const Text("Cancel"),
                              ),
                              TextButton(
                                onPressed: () {
                                  if (otpController.text.trim() == "123456") {
                                    Navigator.pop(context, otpController.text.trim());
                                  } else {
                                    setState(() {
                                      otpError = "Invalid OTP. Please try again.";
                                    });
                                  }
                                },
                                child: const Text("Verify"),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  );

                  if (otp != null && otp == "123456") {
                    setState(() {
                      _phoneNumber = newPhone;
                    });
                    await _savePhone(newPhone);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Phone number verified and saved')),
                    );
                  }
                }
              }

              void _deleteAccount() {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text("Delete Account"),
                      content: const Text(
                        "Are you sure you want to delete your account? This will remove your name, email, phone number, booking history, all added vehicles, your profile picture, saved cards, and payment history.",
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text("Cancel"),
                        ),
                        TextButton(
                          onPressed: () async {
                            final prefs = await SharedPreferences.getInstance();

                            // Remove personal info
                            await prefs.remove('default_vehicle_name');
                            await prefs.remove('phone');
                            await prefs.remove('name');
                            await prefs.remove('email');
                            await prefs.remove('profile_image');

                            // Remove vehicle list
                            await prefs.remove('vehicles');

                            // Remove booking history
                            await prefs.remove('booking_history');

                            // Remove saved cards and transactions
                            await prefs.remove('saved_cards');
                            await prefs.remove('payment_history');

                            // Update UI
                            setState(() {
                              _name = "User Name";
                              _phoneNumber = "+20 123456789";
                              _nameEdited = false;
                            });

                            Navigator.pop(context); // Close dialog

                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Account deleted successfully.')),
                            );

                            // Changed SignupPage to RegisterScreen
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(builder: (context) => RegisterScreen()),
                              (route) => false,
                            );
                          },
                          child: const Text("Delete", style: TextStyle(color: Colors.red)),
                        ),
                      ],
                    );
                  },
                );
              }

              @override
              Widget build(BuildContext context) {
                return Scaffold(
                  backgroundColor: const Color(0xFF0F1E2F),
                  appBar: AppBar(
                    backgroundColor: const Color(0xFF0F1E2F),
                    centerTitle: true,
                    leading: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => const ProfilePage()),
                        );
                      },
                    ),
                  ),
                  body: Column(
                    children: [
                      ListTile(
                        title: const Text("Name", style: TextStyle(color: Colors.white)),
                        trailing: Text(_name, style: const TextStyle(color: Colors.white)),
                        onTap: _editName,
                      ),
                      const Divider(color: Colors.grey),
                      ListTile(
                        title: const Text("Phone Number", style: TextStyle(color: Colors.white)),
                        trailing: Text(_phoneNumber, style: const TextStyle(color: Colors.grey)),
                        onTap: _editPhoneNumber,
                      ),
                      const Divider(color: Colors.grey),
                      ListTile(
                        title: const Text("Email", style: TextStyle(color: Colors.white)),
                        trailing: Text(_email, style: const TextStyle(color: Colors.grey)),
                        onTap: _editEmail,
                      ),
                      const Divider(color: Colors.grey),

                      const Spacer(),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          children: [
                            ElevatedButton(
                              onPressed: () async {
                                final prefs = await SharedPreferences.getInstance();
                                // Clear all saved user info on logout
                                await prefs.clear();

                                // Changed SignupPage to RegisterScreen
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(builder: (context) => RegisterScreen()),
                                  (route) => false,
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.grey[800],
                                minimumSize: const Size(double.infinity, 50),
                              ),
                              child: const Text("Log out", style: TextStyle(color: Colors.white)),
                            ),
                            const SizedBox(height: 10),
                            ElevatedButton(
                              onPressed: _deleteAccount,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                minimumSize: const Size(double.infinity, 50),
                              ),
                              child: const Text(
                                "Delete my account",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                );
              }
            }