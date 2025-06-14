// payment_and_cards.dart LAST VERSION
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PaymentMethodPage extends StatefulWidget {
  const PaymentMethodPage({super.key});

  @override
  State<PaymentMethodPage> createState() => _PaymentMethodPageState();
}

class _PaymentMethodPageState extends State<PaymentMethodPage> {
  List<Map<String, dynamic>> _savedCards = [];
  List<Map<String, dynamic>> _paymentHistory = [];

  @override
  void initState() {
    super.initState();
    _loadSavedCards();
    _loadPaymentHistory();
  }

  Future<void> _loadSavedCards() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('saved_cards');
    if (jsonString != null) {
      final List<dynamic> decoded = jsonDecode(jsonString);
      setState(() {
        _savedCards =
            decoded
                .map<Map<String, dynamic>>((e) => Map<String, dynamic>.from(e))
                .toList();
      });
    }
  }

  Future<void> _saveUpdatedCards() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('saved_cards', jsonEncode(_savedCards));
  }

  Future<void> _loadPaymentHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final historyString = prefs.getString('payment_history');
    if (historyString != null) {
      final List<dynamic> decoded = jsonDecode(historyString);
      setState(() {
        _paymentHistory =
            decoded
                .map<Map<String, dynamic>>((e) => Map<String, dynamic>.from(e))
                .toList();
      });
    }
  }

  void _confirmDeleteCard(int index) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: const Color(0xFF1A2A3A),
            title: const Text(
              "Delete Card?",
              style: TextStyle(color: Colors.white),
            ),
            content: const Text(
              "Are you sure you want to delete this card?",
              style: TextStyle(color: Colors.white70),
            ),
            actions: [
              TextButton(
                child: const Text(
                  "Cancel",
                  style: TextStyle(color: Colors.tealAccent),
                ),
                onPressed: () => Navigator.of(context).pop(),
              ),
              TextButton(
                child: const Text(
                  "Delete",
                  style: TextStyle(color: Colors.redAccent),
                ),
                onPressed: () {
                  setState(() {
                    _savedCards.removeAt(index);
                  });
                  _saveUpdatedCards();
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
    );
  }

  Widget _buildCardItem(Map<String, dynamic> card, int index) {
    final cardNumber = card['number'] ?? "";
    final last4 =
        cardNumber.length >= 4
            ? cardNumber.substring(cardNumber.length - 4)
            : "XXXX";

    return Card(
      color: const Color(0xFF1A2A3A),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: ListTile(
        leading: const Icon(Icons.credit_card, color: Colors.white),
        title: Text(
          card['name'] ?? 'Unnamed Card',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          '**** **** **** $last4\nExpires: ${card['expiry'] ?? "--/--"}',
          style: const TextStyle(color: Colors.white70),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete, color: Colors.redAccent),
          onPressed: () => _confirmDeleteCard(index),
        ),
        isThreeLine: true,
      ),
    );
  }

  Widget _buildTransactionItem(Map<String, dynamic> tx) {
    final card = tx['card'] ?? {};
    final last4 = (card['number'] ?? "")
        .toString()
        .padLeft(4, 'X')
        .substring((card['number'] ?? "").toString().length - 4);
    final cardName = card['name'] ?? "Unknown Card";

    return ListTile(
      leading: const CircleAvatar(
        backgroundColor: Colors.purple,
        child: Icon(Icons.receipt, color: Colors.white),
      ),
      title: Text(
        cardName,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Text(
        "**** **** **** $last4\n${tx['date'] ?? "--/--"}",
        style: const TextStyle(color: Colors.white70),
      ),
      trailing: Text(
        "- ${tx['amount'] ?? "0.00"} €",
        style: const TextStyle(
          color: Colors.redAccent,
          fontWeight: FontWeight.bold,
        ),
      ),
      isThreeLine: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F1E2F),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F1E2F),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Your Cards",
          style: TextStyle(
            color: Colors.white, //
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Text(
              "My Cards",
              style: TextStyle(color: Colors.white70, fontSize: 18),
            ),
          ),
          if (_savedCards.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.only(top: 10),
                child: Text(
                  "No saved cards.",
                  style: TextStyle(color: Colors.white54),
                ),
              ),
            )
          else
            ..._savedCards
                .asMap()
                .entries
                .map((entry) => _buildCardItem(entry.value, entry.key))
                .toList(),
          const Divider(color: Colors.white24),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Text(
              "Payment History",
              style: TextStyle(color: Colors.white70, fontSize: 18),
            ),
          ),
          if (_paymentHistory.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.only(top: 10),
                child: Text(
                  "No payment history found.",
                  style: TextStyle(color: Colors.white54),
                ),
              ),
            )
          else
            ..._paymentHistory.map(_buildTransactionItem).toList(),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
