import 'package:flutter/material.dart';
import 'login/login_screen.dart'; // Adjust this import if your file structure is different.

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  final List<Widget> _screens = const [
    HomeTab(),
    ActivitiesTab(),
    MeditateTab(),
    ProfileTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GoodMind'),
        elevation: 0,
      ),
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.fitness_center), label: 'Activities'),
          BottomNavigationBarItem(icon: Icon(Icons.spa), label: 'Meditate'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}

class HomeTab extends StatelessWidget {
  const HomeTab({Key? key}) : super(key: key);

  Widget _buildQuoteCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: const [
            Text(
              '"The greatest wealth is health."',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
            SizedBox(height: 8),
            Text(
              '- Virgil',
              textAlign: TextAlign.right,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureCard(String title, IconData icon, Color color) {
    return Card(
      child: InkWell(
        onTap: () {},
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: color),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureGrid() {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      childAspectRatio: 1.5,
      children: [
        _buildFeatureCard('Mood Check', Icons.mood, Colors.purple),
        _buildFeatureCard('Meditation', Icons.spa, Colors.green),
        _buildFeatureCard('Sleep Track', Icons.nightlight_round, Colors.blue),
        _buildFeatureCard('Activity', Icons.directions_run, Colors.orange),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Welcome Back!',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 16),
          _buildQuoteCard(),
          const SizedBox(height: 24),
          _buildFeatureGrid(),
        ],
      ),
    );
  }
}

class ActivitiesTab extends StatelessWidget {
  const ActivitiesTab({Key? key}) : super(key: key);

  Widget _buildActivityTile(String title, String duration, IconData icon) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue),
      title: Text(title),
      subtitle: Text(duration),
      trailing: const Icon(Icons.chevron_right),
      onTap: () {},
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildActivityTile('Morning Walk', '30 mins', Icons.directions_walk),
        _buildActivityTile('Yoga Session', '45 mins', Icons.self_improvement),
        _buildActivityTile('Cycling', '1 hour', Icons.directions_bike),
        _buildActivityTile('Meditation', '20 mins', Icons.spa),
      ],
    );
  }
}

class MeditateTab extends StatelessWidget {
  const MeditateTab({Key? key}) : super(key: key);

  Widget _buildSessionCard(String title, String duration, Color color) {
    return Card(
      color: color.withOpacity(0.1),
      child: ListTile(
        title: Text(title, style: TextStyle(color: color)),
        subtitle: Text(duration),
        trailing: Icon(Icons.play_arrow, color: color),
        onTap: () {},
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildSessionCard('Basic Breathing', '5 mins', Colors.blue),
        _buildSessionCard('Stress Relief', '10 mins', Colors.green),
        _buildSessionCard('Sleep Better', '15 mins', Colors.purple),
        _buildSessionCard('Morning Focus', '10 mins', Colors.orange),
      ],
    );
  }
}

class ProfileTab extends StatelessWidget {
  const ProfileTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 24),
        const CircleAvatar(radius: 50, child: Icon(Icons.person, size: 50)),
        const SizedBox(height: 16),
        Text(
          'User Name',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 24),
        ListTile(
          leading: const Icon(Icons.settings),
          title: const Text('Settings'),
          onTap: () {},
        ),
        ListTile(
          leading: const Icon(Icons.exit_to_app),
          title: const Text('Log Out'),
          onTap: () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const LoginScreen(),
            ),
          ),
        ),
      ],
    );
  }
}
