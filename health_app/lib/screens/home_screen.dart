import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  // Build a card for each tab
  Widget _buildTabCard(String title) {
    return Card(
      child: InkWell(
        onTap: () {
          // TODO: Implement tab action if needed
        },
        child: Center(
          child: Text(
            title,
           style: const TextStyle(fontSize: 18),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GoodMind - Home'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          children: [
            _buildTabCard('Tab 1'),
            _buildTabCard('Tab 2'),
            _buildTabCard('Tab 3'),
            _buildTabCard('Tab 4'),
          ],
        ),
      ),
    );
  }
}
