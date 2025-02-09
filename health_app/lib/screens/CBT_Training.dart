import 'package:flutter/material.dart';

class CBTScreen extends StatelessWidget {
  const CBTScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CBT Training'),
      ),
      body: const Center(
        child: Text(
          'CBT page coming soon!',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
