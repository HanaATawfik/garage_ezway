// lib/pages/user/login.dart
                    import 'package:flutter/material.dart';
                    import '../../utils/admin_credentials.dart';
                    import 'signup.dart';
                    import 'home_page.dart'; // Changed from home_page.dart to match our implementation
                    import '../../pages/admin/admin_home.dart';

                    class LoginScreen extends StatefulWidget {
                      const LoginScreen({super.key});

                      @override
                      State<LoginScreen> createState() => _LoginScreenState();
                    }

                    class _LoginScreenState extends State<LoginScreen> {
                      final TextEditingController _emailController = TextEditingController();
                      final TextEditingController _passwordController = TextEditingController();
                      bool _isFormValid = false;
                      bool _showPassword = false;
                      String? _emailError;
                      String? _passwordError;

                      @override
                      void initState() {
                        super.initState();
                        _emailController.addListener(_validateForm);
                        _passwordController.addListener(_validateForm);
                      }

                      void _validateForm() {
                        final email = _emailController.text.trim();
                        final password = _passwordController.text;

                        final emailRegex = RegExp(
                          r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
                        );
                        bool emailValid = emailRegex.hasMatch(email);

                        bool passwordValid = RegExp(
                          r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[^A-Za-z\d]).{8,}$',
                        ).hasMatch(password);

                        setState(() {
                          _emailError =
                              emailValid ? null : "Enter a valid email (e.g., user@example.com)";
                          _passwordError =
                              passwordValid
                                  ? null
                                  : "Password must contain:\n- 8+ characters\n- 1 uppercase\n- 1 lowercase\n- 1 number\n- 1 special character";
                          _isFormValid = emailValid && passwordValid;
                        });
                      }

                      @override
                      Widget build(BuildContext context) {
                        return Scaffold(
                          backgroundColor: const Color(0xFF0F1E2F),
                          body: Center(
                            child: SingleChildScrollView(
                              padding: const EdgeInsets.symmetric(horizontal: 30),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const SizedBox(height: 40),
                                  const Text(
                                    "Welcome Back!",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 26,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  const Text(
                                    "Login to continue",
                                    style: TextStyle(color: Colors.white70, fontSize: 16),
                                  ),
                                  const SizedBox(height: 30),
                                  _buildEmailField(),
                                  if (_emailError != null) _buildErrorText(_emailError!),
                                  const SizedBox(height: 15),
                                  _buildPasswordField(),
                                  if (_passwordError != null) _buildErrorText(_passwordError!),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: TextButton(
                                      onPressed: () {},
                                      child: const Text(
                                        "Forgot Password?",
                                        style: TextStyle(color: Colors.blueGrey),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 10),

                                  _buildButton(
                                    context,
                                    "Login",
                                    _isFormValid
                                        ? () async {
                                            final email = _emailController.text.trim();
                                            final password = _passwordController.text;

                                            final savedEmail = await AdminCredentials.getEmail();
                                            final savedPassword =
                                                await AdminCredentials.getPassword();

                                            if (email == savedEmail && password == savedPassword) {
                                              Navigator.pushReplacement(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => const AdminHomePage(),
                                                ),
                                              );
                                            } else {
                                              Navigator.pushReplacement(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>  HomePage(),
                                                ),
                                              );
                                            }
                                          }
                                        : null,
                                  ),

                                  const SizedBox(height: 20),
                                  _buildSocialLogin(),
                                  const SizedBox(height: 15),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Text(
                                        "Don't have an account?",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>  const RegisterScreen(),
                                            ),
                                          );
                                        },
                                        child: const Text(
                                          "Sign up",
                                          style: TextStyle(color: Colors.blue),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          drawer: _buildDrawer(context),
                        );
                      }

                      // Implementation of missing methods
                      Widget _buildEmailField() {
                        return TextField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            labelText: "Email",
                            labelStyle: const TextStyle(color: Colors.white70),
                            prefixIcon: const Icon(Icons.email, color: Colors.white70),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(color: Colors.white30),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(color: Colors.teal),
                            ),
                            filled: true,
                            fillColor: Colors.white.withOpacity(0.1),
                          ),
                        );
                      }

                      Widget _buildPasswordField() {
                        return TextField(
                          controller: _passwordController,
                          obscureText: !_showPassword,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            labelText: "Password",
                            labelStyle: const TextStyle(color: Colors.white70),
                            prefixIcon: const Icon(Icons.lock, color: Colors.white70),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _showPassword ? Icons.visibility_off : Icons.visibility,
                                color: Colors.white70,
                              ),
                              onPressed: () {
                                setState(() {
                                  _showPassword = !_showPassword;
                                });
                              },
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(color: Colors.white30),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(color: Colors.teal),
                            ),
                            filled: true,
                            fillColor: Colors.white.withOpacity(0.1),
                          ),
                        );
                      }

                      Widget _buildErrorText(String errorText) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 8.0, left: 12.0),
                          child: Text(
                            errorText,
                            style: const TextStyle(color: Colors.redAccent, fontSize: 12),
                          ),
                        );
                      }

                      Widget _buildButton(
                          BuildContext context, String text, VoidCallback? onPressed) {
                        return SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: onPressed,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF46B1A1),
                              disabledBackgroundColor: Colors.grey,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                            child: Text(
                              text,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        );
                      }

                      Widget _buildSocialLogin() {
                        return Column(
                          children: [
                            const Text(
                              "Or login with",
                              style: TextStyle(color: Colors.white70),
                            ),
                            const SizedBox(height: 15),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                _socialButton(
                                  icon: Icons.g_mobiledata,
                                  color: Colors.red,
                                  onPressed: () {},
                                ),
                                _socialButton(
                                  icon: Icons.facebook,
                                  color: Colors.blue,
                                  onPressed: () {},
                                ),
                                _socialButton(
                                  icon: Icons.apple,
                                  color: Colors.white,
                                  onPressed: () {},
                                ),
                              ],
                            ),
                          ],
                        );
                      }

                      Widget _socialButton({
                        required IconData icon,
                        required Color color,
                        required VoidCallback onPressed,
                      }) {
                        return IconButton(
                          onPressed: onPressed,
                          icon: Icon(icon, color: color, size: 36),
                          style: IconButton.styleFrom(
                            backgroundColor: Colors.white.withOpacity(0.1),
                            fixedSize: const Size(50, 50),
                          ),
                        );
                      }

                      Widget _buildDrawer(BuildContext context) {
                        return Drawer(
                          backgroundColor: const Color(0xFF1A2A3F),
                          child: ListView(
                            padding: EdgeInsets.zero,
                            children: [
                              DrawerHeader(
                                decoration: const BoxDecoration(
                                  color: Color(0xFF0F1E2F),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: const [
                                    CircleAvatar(
                                      radius: 40,
                                      backgroundColor: Colors.teal,
                                      child: Icon(Icons.person, color: Colors.white, size: 40),
                                    ),
                                    SizedBox(height: 10),
                                    Text(
                                      "ParkEZ",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 24,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              ListTile(
                                leading: const Icon(Icons.home, color: Colors.white),
                                title: const Text("Home", style: TextStyle(color: Colors.white)),
                                onTap: () {
                                  Navigator.pop(context);
                                },
                              ),
                              ListTile(
                                leading: const Icon(Icons.person, color: Colors.white),
                                title: const Text("Profile", style: TextStyle(color: Colors.white)),
                                onTap: () {
                                  Navigator.pop(context);
                                },
                              ),
                              ListTile(
                                leading: const Icon(Icons.settings, color: Colors.white),
                                title:
                                    const Text("Settings", style: TextStyle(color: Colors.white)),
                                onTap: () {
                                  Navigator.pop(context);
                                },
                              ),
                              const Divider(color: Colors.white30),
                              ListTile(
                                leading: const Icon(Icons.logout, color: Colors.white),
                                title: const Text("Logout", style: TextStyle(color: Colors.white)),
                                onTap: () {
                                  Navigator.pop(context);
                                },
                              ),
                            ],
                          ),
                        );
                      }
                    }