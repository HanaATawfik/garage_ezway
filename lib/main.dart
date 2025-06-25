import 'package:flutter/material.dart';
              import 'pages/user/home_page.dart';
              import 'pages/user/signup.dart';
              import 'pages/admin/admin_dashboard.dart';
              import 'pages/user/splash_screen.dart'; // Add this import

              void main() {
                runApp(const MyApp());
              }

              class MyApp extends StatelessWidget {
                const MyApp({super.key});

                @override
                Widget build(BuildContext context) {
                  return MaterialApp(
                    title: 'Parking App',
                    theme: ThemeData(
                      colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
                      useMaterial3: true,
                    ),
                    home: const SplashScreen(), // Changed to start with splash screen
                    routes: {
                      '/admin': (context) => AdminDashboard(),
                      '/home': (context) => const HomePage(),
                    },
                  );
                }
              }