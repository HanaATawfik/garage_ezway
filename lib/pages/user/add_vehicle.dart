// lib/pages/user/add_vehicle.dart
    import 'package:flutter/material.dart';
    import '../model/vehicle_model.dart';
    import '../service/user_service.dart';
    import 'home_page.dart';

    class AddVehiclePage extends StatefulWidget {
      const AddVehiclePage({super.key});

      @override
      _AddVehiclePageState createState() => _AddVehiclePageState();
    }

    class _AddVehiclePageState extends State<AddVehiclePage> {
      final modelController = TextEditingController();
      final licensePlateController = TextEditingController();
      final UserService _userService = UserService();
      bool _isLoading = false;

      @override
      Widget build(BuildContext context) {
        return Scaffold(
          backgroundColor: const Color(0xFF0F1E2F),
          appBar: AppBar(
            backgroundColor: const Color(0xFF0F1E2F),
            title: const Text('Add Vehicle'),
            centerTitle: true,
          ),
          body: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                TextField(
                  controller: modelController,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: 'Car Model',
                    labelStyle: TextStyle(color: Colors.white70),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white38),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: licensePlateController,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: 'License Plate',
                    labelStyle: TextStyle(color: Colors.white70),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white38),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _addVehicle,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            "Add Vehicle",
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                  ),
                ),
              ],
            ),
          ),
        );
      }

      void _addVehicle() async {
        if (modelController.text.trim().isEmpty ||
            licensePlateController.text.trim().isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Please fill in all fields')),
          );
          return;
        }

        setState(() {
          _isLoading = true;
        });

        try {
          final vehicle = Vehicle(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            model: modelController.text.trim(),
            licensePlate: licensePlateController.text.trim(),
          );

          await _userService.addVehicleToCurrentUser(vehicle);

          // Navigate to home page after adding vehicle
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomePage()),
          );
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to add vehicle: $e')),
          );
        } finally {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }