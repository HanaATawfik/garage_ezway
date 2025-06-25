import 'package:flutter/material.dart';
              import 'signup.dart';  // Make sure to import the signup.dart file

              class SplashScreen extends StatefulWidget {
                const SplashScreen({super.key});

                @override
                _SplashScreenState createState() => _SplashScreenState();
              }

              class _SplashScreenState extends State<SplashScreen> {
                @override
                void initState() {
                  super.initState();
                  // Navigate to RegisterScreen after 3 seconds
                  Future.delayed(const Duration(seconds: 3), () {
                    if (mounted) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const RegisterScreen()),
                      );
                    }
                  });
                }

                @override
                Widget build(BuildContext context) {
                  return Scaffold(
                    backgroundColor: const Color(0xFF0F1E2F),
                    body: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          RichText(
                            textAlign: TextAlign.center,
                            text: const TextSpan(
                              children: [
                                TextSpan(
                                  text: "GARAGE ",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 36,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: 'Montserrat',
                                  ),
                                ),
                                TextSpan(
                                  text: "EZway",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 36,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: 'DancingScript',
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                          const CircularProgressIndicator(color: Colors.white),
                        ],
                      ),
                    ),
                  );
                }
              }