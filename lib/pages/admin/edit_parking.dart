import 'dart:io';
    import 'package:flutter/material.dart';
    import 'package:shared_preferences/shared_preferences.dart';

    class EditParkingPage extends StatefulWidget {
      final String name;
      final String price;
      final String location;
      final String slots;
      final String? imagePath;

      const EditParkingPage({
        super.key,
        required this.name,
        required this.price,
        required this.location,
        required this.slots,
        this.imagePath,
      });

      @override
      _EditParkingPageState createState() => _EditParkingPageState();
    }

    class _EditParkingPageState extends State<EditParkingPage> {
      late TextEditingController priceController;
      late TextEditingController locationController;
      late TextEditingController slotsController;
      File? _selectedImage;
      final _formKey = GlobalKey<FormState>();

      @override
      void initState() {
        super.initState();
        priceController = TextEditingController(text: widget.price);
        locationController = TextEditingController(text: widget.location);
        slotsController = TextEditingController(text: widget.slots);

        // Load existing image if available
        if (widget.imagePath != null) {
          _selectedImage = File(widget.imagePath!);
        }
      }

      @override
      void dispose() {
        priceController.dispose();
        locationController.dispose();
        slotsController.dispose();
        super.dispose();
      }

      @override
      Widget build(BuildContext context) {
        return Scaffold(
          backgroundColor: Color(0xFF25303B),
          body: Column(
            children: [
              _buildHeader(context),
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        _buildImage(),
                        SizedBox(height: 25),
                        _buildEditForm(),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }

      Widget _buildHeader(BuildContext context) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Row(
            children: [
              IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.white, size: 26),
                onPressed: () => Navigator.pop(context),
              ),
              Expanded(
                child: Text(
                  "Edit",
                  style: TextStyle(
                    fontSize: 22,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(width: 48),
            ],
          ),
        );
      }

      Widget _buildImage() {
        return Container(
          width: double.infinity,
          height: 180,
          decoration: BoxDecoration(
            color: Color(0xFF3A4A5A),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Icon(
              Icons.local_parking,
              size: 80,
              color: Colors.white,
            ),
          ),
        );
      }

      Widget _buildEditForm() {
        return Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(color: Colors.black26, blurRadius: 10, spreadRadius: 2),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildTextField("PRICE PER HOUR", priceController, (value) {
                if (value == null || value.isEmpty) return 'Please enter a price';
                if (double.tryParse(value) == null)
                  return 'Please enter a valid number';
                return null;
              }),
              SizedBox(height: 16),
              _buildTextField("LOCATION", locationController, (value) {
                if (value == null || value.isEmpty)
                  return 'Please enter a location';
                return null;
              }),
              SizedBox(height: 16),
              _buildTextField("TOTAL SLOTS", slotsController, (value) {
                if (value == null || value.isEmpty)
                  return 'Please enter the total slots';
                if (int.tryParse(value) == null)
                  return 'Please enter a valid integer';
                return null;
              }),
              SizedBox(height: 25),
              _buildDoneButton(),
            ],
          ),
        );
      }

      Widget _buildTextField(
        String label,
        TextEditingController controller,
        FormFieldValidator<String> validator,
      ) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 6),
            TextFormField(
              controller: controller,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey[200],
                contentPadding: EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.red),
                ),
                errorStyle: TextStyle(color: Colors.red, fontSize: 12),
              ),
              validator: validator,
            ),
          ],
        );
      }

      Widget _buildDoneButton() {
        return AnimatedContainer(
          duration: Duration(milliseconds: 200),
          child: ElevatedButton(
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                final prefs = await SharedPreferences.getInstance();
                await prefs.setString('parkingPrice', priceController.text);
                await prefs.setString('parkingLocation', locationController.text);
                await prefs.setString('parkingSlots', slotsController.text);

                Navigator.pop(context, {
                  "price": priceController.text,
                  "location": locationController.text,
                  "slots": slotsController.text,
                  "imagePath": widget.imagePath,
                });
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF25303B),
              padding: EdgeInsets.symmetric(horizontal: 36, vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 4,
            ),
            child: Text(
              "Done",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      }
    }