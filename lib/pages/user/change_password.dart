// change_password.dart
      import 'package:flutter/material.dart';
      import 'profile.dart'; // Fixed import path

      class ChangePasswordPage extends StatefulWidget {
        const ChangePasswordPage({Key? key}) : super(key: key);

        @override
        _ChangePasswordPageState createState() => _ChangePasswordPageState();
      }

      class _ChangePasswordPageState extends State<ChangePasswordPage> {
        final TextEditingController _currentPasswordController =
            TextEditingController();
        final TextEditingController _newPasswordController = TextEditingController();

        bool _obscureCurrent = true;
        bool _obscureNew = true;
        String? _passwordError;

        bool _isPasswordValid(String password) {
          final passwordRegex = RegExp(
            r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[\W_]).{8,}$',
          );
          return passwordRegex.hasMatch(password);
        }

        String getPasswordRequirements() {
          return "Password must be at least 8 characters,\ninclude upper/lowercase letters,\na number, and a symbol.";
        }

        void _submitChange() {
          final newPassword = _newPasswordController.text;

          if (!_isPasswordValid(newPassword)) {
            setState(() {
              _passwordError = getPasswordRequirements();
            });
            return;
          }

          setState(() => _passwordError = null);

          // Simulate password change (no real backend here)
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              backgroundColor: const Color(0xFF1E2A38),
              title: const Text("Success", style: TextStyle(color: Colors.white)),
              content: const Text(
                "Password changed successfully!",
                style: TextStyle(color: Colors.white70),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) =>  ProfilePage()),
                    );
                  },
                  child: const Text(
                    "OK",
                    style: TextStyle(color: Colors.lightBlueAccent),
                  ),
                ),
              ],
            ),
          );
        }

        @override
        Widget build(BuildContext context) {
          return Scaffold(
            backgroundColor: const Color(0xFF0F1E2F),
            appBar: AppBar(
              backgroundColor: const Color(0xFF0F1E2F),
              elevation: 0,
              centerTitle: true,
              title: const Text("Change Password"),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) =>  ProfilePage()),
                  );
                },
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Change the account password",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 30),

                  /// Current Password
                  TextField(
                    controller: _currentPasswordController,
                    obscureText: _obscureCurrent,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: "Current Password",
                      labelStyle: const TextStyle(color: Colors.white70),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureCurrent ? Icons.visibility : Icons.visibility_off,
                          color: Colors.white70,
                        ),
                        onPressed:
                            () => setState(() => _obscureCurrent = !_obscureCurrent),
                      ),
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white30),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.lightBlueAccent),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  /// New Password
                  TextField(
                    controller: _newPasswordController,
                    obscureText: _obscureNew,
                    onChanged: (_) {
                      if (_isPasswordValid(_newPasswordController.text)) {
                        setState(() => _passwordError = null);
                      }
                    },
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: "New Password",
                      labelStyle: const TextStyle(color: Colors.white70),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureNew ? Icons.visibility : Icons.visibility_off,
                          color: Colors.white70,
                        ),
                        onPressed: () => setState(() => _obscureNew = !_obscureNew),
                      ),
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white30),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.lightBlueAccent),
                      ),
                      errorText: _passwordError,
                      errorStyle: const TextStyle(color: Colors.redAccent, fontSize: 12),
                    ),
                  ),

                  const SizedBox(height: 10),
                  if (_passwordError == null)
                    Text(
                      getPasswordRequirements(),
                      style: const TextStyle(color: Colors.white70, fontSize: 12),
                    ),

                  const SizedBox(height: 30),

                  Center(
                    child: ElevatedButton(
                      onPressed: _submitChange,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.lightBlueAccent,
                        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                      ),
                      child: const Text(
                        "Submit",
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      }