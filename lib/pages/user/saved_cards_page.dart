//saved_cards_page.dart LAST VERSION
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SavedCardsPage extends StatefulWidget {
  const SavedCardsPage({super.key});

  @override
  State<SavedCardsPage> createState() => _SavedCardsPageState();
}

class _SavedCardsPageState extends State<SavedCardsPage> {
  List<Map<String, dynamic>> _savedCards = [];

  @override
  void initState() {
    super.initState();
    _loadSavedCards();
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

  Widget _buildCardItem(Map<String, dynamic> card) {
    final cardNumber = card['card'];
    final last4 =
        (cardNumber != null && cardNumber.length >= 4)
            ? cardNumber.substring(cardNumber.length - 4)
            : "XXXX";

    return Card(
      color: const Color(0xFF1A2A3A),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: ListTile(
        leading: const Icon(Icons.credit_card, color: Colors.white),
        title: Text(
          card['name'] ?? 'Unknown',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          '**** **** **** $last4\nExpires: ${card['expiry'] ?? "??/??"}',
          style: const TextStyle(color: Colors.white70),
        ),
        isThreeLine: true,
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
        title: const Text("Saved Cards"),
        centerTitle: true,
      ),
      body:
          _savedCards.isEmpty
              ? const Center(
                child: Text(
                  "No saved cards.",
                  style: TextStyle(color: Colors.white70),
                ),
              )
              : ListView.builder(
                itemCount: _savedCards.length,
                itemBuilder: (context, index) {
                  return _buildCardItem(_savedCards[index]);
                },
              ),
    );
  }
}
