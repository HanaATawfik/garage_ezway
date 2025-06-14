//FAQ.dart LAST VERSION
import 'package:flutter/material.dart';

class FAQPage extends StatefulWidget {
  @override
  _FAQPageState createState() => _FAQPageState();
}

class _FAQPageState extends State<FAQPage> {
  List<Item> _faqItems = <Item>[
    Item(
      header: 'What is Garage EZway?',
      body:
          'Garage EZway is a parking app that helps you manage parking sessions, payments, and your vehicle profile easily.',
    ),
    Item(
      header: 'How do I start a parking session?',
      body:
          'Go to Active Session page and click on Start Parking. You can end it anytime and proceed to payment.',
    ),
    Item(
      header: 'Can I save my vehicle info?',
      body:
          'Yes, you can save and update your vehicle details in the Profile section.',
    ),
    Item(
      header: 'Is my payment information safe?',
      body:
          'Yes, your payment data is securely processed through encrypted channels.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0F1E2F),
      appBar: AppBar(
        backgroundColor: Color(0xFF0F1E2F),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text("FAQs"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 12),
              alignment: Alignment.centerLeft,
              child: Text(
                "The most frequently asked questions",
                style: TextStyle(fontSize: 18, color: Colors.white70),
              ),
            ),
            Expanded(
              child: ListView(
                children:
                    _faqItems.map((item) => _buildExpansionTile(item)).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExpansionTile(Item item) {
    return Theme(
      data: Theme.of(context).copyWith(
        dividerColor: Colors.transparent,
        unselectedWidgetColor: Colors.white60,
      ),
      child: ExpansionTile(
        tilePadding: EdgeInsets.symmetric(horizontal: 0),
        collapsedIconColor: Colors.white70,
        iconColor: Colors.white,
        title: Text(
          item.header,
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        children: [
          Container(
            padding: EdgeInsets.only(left: 12, right: 12, bottom: 16),
            alignment: Alignment.centerLeft,
            child: Text(
              item.body,
              style: TextStyle(color: Colors.white70, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}

class Item {
  final String header;
  final String body;
  Item({required this.header, required this.body});
}
