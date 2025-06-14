//payment.dart FIXED
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home_page.dart';  // Assuming HomePage is in home_page.dart

// Local implementation of Booking class since the import file is missing
class Booking {
  final String location;
  final String time;
  final double amount;
  final String? slotId;
  final String? receiptId;

  Booking({
    required this.location,
    required this.time,
    required this.amount,
    this.slotId,
    this.receiptId,
  });

  Map<String, dynamic> toJson() {
    return {
      'location': location,
      'time': time,
      'amount': amount,
      'slotId': slotId,
      'receiptId': receiptId,
    };
  }
}

// Local implementation of BookingStorage since the import file is missing
class BookingStorage {
  static const String _bookingsKey = 'booking_history';

  static Future<void> addBooking(Booking booking) async {
    final prefs = await SharedPreferences.getInstance();
    final bookingsJson = prefs.getStringList(_bookingsKey) ?? [];

    bookingsJson.add(jsonEncode(booking.toJson()));
    await prefs.setStringList(_bookingsKey, bookingsJson);
  }
}

class PaymentPage extends StatefulWidget {
  final Duration? parkingDuration;
  final double? parkingCost;

  const PaymentPage({super.key, this.parkingDuration, this.parkingCost});

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _cardController = TextEditingController();
  final _expiryController = TextEditingController();
  final _cvvController = TextEditingController();
  bool _isChecked = false;
  bool _isButtonEnabled = false;
  List<Map<String, dynamic>> _savedCards = [];
  Map<String, dynamic>? _selectedCard;

  @override
  void initState() {
    super.initState();
    _loadSavedCards();
  }

  Future<void> _loadSavedCards() async {
    final prefs = await SharedPreferences.getInstance();
    final cards = prefs.getString('saved_cards');
    if (cards != null) {
      final List decoded = jsonDecode(cards);
      setState(() {
        _savedCards = decoded.cast<Map<String, dynamic>>();
      });
    }
  }

  void _onCardSelected(Map<String, dynamic>? card) {
    setState(() {
      _selectedCard = card;
      if (card != null) {
        _nameController.text = card['name'] ?? '';
        _cardController.text = card['number'] ?? '';
        _expiryController.text = card['expiry'] ?? '';
      } else {
        _nameController.clear();
        _cardController.clear();
        _expiryController.clear();
      }
    });
  }

  void _validateForm() {
    setState(() {
      _isButtonEnabled = _formKey.currentState?.validate() ?? false;
    });
  }

  Future<void> _saveCardInfo() async {
    final prefs = await SharedPreferences.getInstance();
    final newCardNumber = _cardController.text.trim();
    final newCard = {
      'name': _nameController.text.trim(),
      'number': newCardNumber,
      'expiry': _expiryController.text.trim(),
    };

    final cardsStr = prefs.getString('saved_cards');
    final List<dynamic> savedCards =
        cardsStr != null ? jsonDecode(cardsStr) : [];

    // Check for duplicate card number
    final exists = savedCards.any((card) => card['number'] == newCardNumber);
    if (exists) {
      return; // Simply do nothing if already saved
    }

    savedCards.add(newCard);
    await prefs.setString('saved_cards', jsonEncode(savedCards));
  }

  void _showPaymentSuccessDialog() {
    final costText = widget.parkingCost?.toStringAsFixed(2) ?? "N/A";

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.teal[50],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Text(
          "Payment Successful!",
          style: TextStyle(color: Colors.teal, fontWeight: FontWeight.bold),
        ),
        content: Text(
          "You have paid \$$costText",
          style: const TextStyle(fontSize: 18),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const HomePage()),
              );
            },
            child: const Text(
              "OK",
              style: TextStyle(
                color: Colors.teal,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handlePayment() async {
    if (_isChecked) await _saveCardInfo();

    final prefs = await SharedPreferences.getInstance();
    final paymentHistory = prefs.getString('payment_history');
    List<dynamic> history =
        paymentHistory != null ? jsonDecode(paymentHistory) : [];

    history.add({
      'title': 'Garage EZway',
      'amount': (widget.parkingCost ?? 0).toStringAsFixed(2),
      'date': DateTime.now().toString().split('.')[0],
      'card': {
        'name': _nameController.text.trim(),
        'number': _cardController.text.trim(),
      },
    });

    await prefs.setString('payment_history', jsonEncode(history));

    // Fixed Booking constructor
    await BookingStorage.addBooking(
      Booking(
        location: "Garage XYZ",
        time: DateTime.now().toString(),
        amount: widget.parkingCost ?? 0,
      )
    );

    _showPaymentSuccessDialog();
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildInput({
    required TextEditingController controller,
    required String hint,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white.withOpacity(0.2),
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white54),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildPaymentIcons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        Icon(Icons.credit_card, color: Colors.white),
        SizedBox(width: 40),
        Icon(Icons.account_balance_wallet, color: Colors.white),
        SizedBox(width: 40),
        Icon(Icons.phone_iphone, color: Colors.white),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F1E2F),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        onChanged: _validateForm,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: ListView(
            children: [
              const SizedBox(height: 10),
              const Text(
                "PAYMENT",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),

              if (_savedCards.isNotEmpty)
                DropdownButtonFormField<Map<String, dynamic>?>(
                  dropdownColor: const Color(0xFF1A2A3A),
                  value: _selectedCard,
                  items: [
                    const DropdownMenuItem<Map<String, dynamic>?>(
                      value: null,
                      child: Text(
                        "-- Add a new card --",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    ..._savedCards.map(
                      (card) => DropdownMenuItem<Map<String, dynamic>?>(
                        value: card,
                        child: Text(
                          "**** ${card['number'].toString().substring(card['number'].length - 4)} - ${card['name']}",
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                  onChanged: _onCardSelected,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.2),
                    hintText: "Select a saved card",
                    hintStyle: const TextStyle(color: Colors.white54),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),

              const SizedBox(height: 15),
              _buildLabel("Full Name"),
              _buildInput(
                controller: _nameController,
                hint: "Enter your full name",
                validator: (val) =>
                    val == null || val.trim().length < 3
                        ? "Name must be at least 3 characters"
                        : null,
              ),
              const SizedBox(height: 15),
              _buildLabel("Choose Payment Method"),
              const SizedBox(height: 10),
              _buildPaymentIcons(),
              const SizedBox(height: 15),
              _buildLabel("Card Number"),
              _buildInput(
                controller: _cardController,
                hint: "Enter card's number",
                keyboardType: TextInputType.number,
                validator: (val) =>
                    RegExp(r'^\d{16}$').hasMatch(val ?? "")
                        ? null
                        : "Card number must be 16 digits",
              ),
              const SizedBox(height: 15),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLabel("CVV"),
                        _buildInput(
                          controller: _cvvController,
                          hint: "CVV",
                          keyboardType: TextInputType.number,
                          validator: (val) =>
                              RegExp(r'^\d{3,4}$').hasMatch(val ?? "")
                                  ? null
                                  : "Invalid CVV",
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLabel("Expiry Date"),
                        _buildInput(
                          controller: _expiryController,
                          hint: "MM/YY",
                          keyboardType: TextInputType.datetime,
                          validator: (val) {
                            if (!RegExp(
                              r'^(0[1-9]|1[0-2])\/\d{2}$',
                            ).hasMatch(val ?? "")) {
                              return "Invalid format (MM/YY)";
                            }
                            final parts = val!.split('/');
                            final now = DateTime.now();
                            final month = int.tryParse(parts[0]);
                            final year = int.tryParse('20${parts[1]}');
                            if (month == null || year == null) {
                              return "Invalid date";
                            }
                            if (year < now.year ||
                                (year == now.year && month < now.month)) {
                              return "Card expired";
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 15),
              if (_selectedCard == null)
                Row(
                  children: [
                    Checkbox(
                      value: _isChecked,
                      onChanged: (val) => setState(() => _isChecked = val!),
                      activeColor: const Color(0xFFabdbe3),
                    ),
                    const Text(
                      "Save Card Information",
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    ),
                  ],
                ),

              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: _isButtonEnabled ? _handlePayment : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFabdbe3),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 5,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40,
                      vertical: 15,
                    ),
                  ),
                  child: const Text(
                    "Proceed to Pay",
                    style: TextStyle(color: Colors.black, fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}