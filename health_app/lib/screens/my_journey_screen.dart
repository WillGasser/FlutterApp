import 'package:flutter/material.dart';

class MyJourneyPage extends StatelessWidget {
  const MyJourneyPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Journey'),
      ),
      body: const Center(
        child: Text(
          'My Journey page coming soon!',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
