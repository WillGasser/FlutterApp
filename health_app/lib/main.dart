import 'dart:async';
import 'package:flutter/material.dart';

void main() {
  runApp(HealthApp());
}

class HealthApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GoodMind',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Raleway',
      ),
      home: LoginScreen(),
    );
  }
}

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  late AnimationController _bgController;
  late Animation<Color?> _bgAnimation1;
  late Animation<Color?> _bgAnimation2;
  late AnimationController _formController;
  late Animation<double> _formOpacity;
  late AnimationController _cloudController;
  late Animation<double> _cloudAnimation;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _bgController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    );

    _bgAnimation1 = ColorTween(
      begin: Colors.lightBlue.shade200,
      end: Colors.pink.shade100,
    ).animate(
      CurvedAnimation(
        parent: _bgController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeInOut),
      ),
    );

    _bgAnimation2 = ColorTween(
      begin: Colors.pink.shade100,
      end: Colors.lightBlue.shade200,
    ).animate(
      CurvedAnimation(
        parent: _bgController,
        curve: const Interval(0.5, 1.0, curve: Curves.easeInOut),
      ),
    );

    _bgController.repeat(reverse: true);

    _formController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _formOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _formController, curve: Curves.easeIn),
    );

    Timer(const Duration(milliseconds: 500), () {
      _formController.forward();
    });

    _cloudController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    );
    _cloudAnimation = Tween<double>(begin: -150, end: 400).animate(
      CurvedAnimation(parent: _cloudController, curve: Curves.linear),
    );
    _cloudController.repeat();
  }

  void _handleLogin() {
    if (_emailController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('Please fill in all fields'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            )
          ],
        ),
      );
    }
  }

  @override
  void dispose() {
    _bgController.dispose();
    _formController.dispose();
    _cloudController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _bgController,
      builder: (context, child) {
        return Scaffold(
          body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [_bgAnimation1.value!, _bgAnimation2.value!],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Stack(
              children: [
                AnimatedBuilder(
                  animation: _cloudController,
                  builder: (context, child) {
                    return Positioned(
                      top: 50,
                      left: _cloudAnimation.value,
                      child: Opacity(
                        opacity: 0.6,
                        child: Icon(
                          Icons.cloud,
                          size: 100,
                          color: Colors.white,
                        ),
                      ),
                    );
                  },
                ),
                Center(
                  child: SingleChildScrollView(
                    child: FadeTransition(
                      opacity: _formOpacity,
                      child: Card(
                        elevation: 8,
                        margin: const EdgeInsets.symmetric(horizontal: 24),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Welcome to GoodMind',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 16),
                              TextField(
                                controller: _emailController,
                                decoration: InputDecoration(
                                  labelText: 'Email',
                                  prefixIcon: Icon(Icons.email),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              TextField(
                                controller: _passwordController,
                                obscureText: true,
                                decoration: InputDecoration(
                                  labelText: 'Password',
                                  prefixIcon: Icon(Icons.lock),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 24),
                              ElevatedButton(
                                onPressed: _handleLogin,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blueAccent,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 48.0, vertical: 12.0),
                                ),
                                child: const Text(
                                  'Login',
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                              const SizedBox(height: 16),
                              TextButton(
                                onPressed: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        ForgotPasswordScreen(),
                                  ),
                                ),
                                child: const Text('Forgot Password?'),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  final List<Widget> _screens = [
    HomeTab(),
    ActivitiesTab(),
    MeditateTab(),
    ProfileTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('GoodMind'),
        elevation: 0,
      ),
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        items: [
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
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Welcome Back!',
              style: Theme.of(context).textTheme.headlineMedium),
          SizedBox(height: 16),
          _buildQuoteCard(),
          SizedBox(height: 24),
          _buildFeatureGrid(),
        ],
      ),
    );
  }

  Widget _buildQuoteCard() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Text('"The greatest wealth is health."',
                style: TextStyle(fontStyle: FontStyle.italic)),
            SizedBox(height: 8),
            Text('- Virgil', textAlign: TextAlign.right),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureGrid() {
    return GridView.count(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
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

  Widget _buildFeatureCard(String title, IconData icon, Color color) {
    return Card(
      child: InkWell(
        onTap: () {},
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: color),
            SizedBox(height: 8),
            Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}

class ActivitiesTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(16),
      children: [
        _buildActivityTile('Morning Walk', '30 mins', Icons.directions_walk),
        _buildActivityTile('Yoga Session', '45 mins', Icons.self_improvement),
        _buildActivityTile('Cycling', '1 hour', Icons.directions_bike),
        _buildActivityTile('Meditation', '20 mins', Icons.spa),
      ],
    );
  }

  Widget _buildActivityTile(String title, String duration, IconData icon) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue),
      title: Text(title),
      subtitle: Text(duration),
      trailing: Icon(Icons.chevron_right),
      onTap: () {},
    );
  }
}

class MeditateTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(16),
      children: [
        _buildSessionCard('Basic Breathing', '5 mins', Colors.blue),
        _buildSessionCard('Stress Relief', '10 mins', Colors.green),
        _buildSessionCard('Sleep Better', '15 mins', Colors.purple),
        _buildSessionCard('Morning Focus', '10 mins', Colors.orange),
      ],
    );
  }

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
}

class ProfileTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 24),
        CircleAvatar(radius: 50, child: Icon(Icons.person, size: 50)),
        SizedBox(height: 16),
        Text('User Name', style: Theme.of(context).textTheme.headlineSmall),
        SizedBox(height: 24),
        ListTile(
          leading: Icon(Icons.settings),
          title: Text('Settings'),
          onTap: () {},
        ),
        ListTile(
          leading: Icon(Icons.exit_to_app),
          title: Text('Log Out'),
          onTap: () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => LoginScreen()),
          ),
        ),
      ],
    );
  }
}

class ForgotPasswordScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Forgot Password')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'Email',
                prefixIcon: Icon(Icons.email),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {},
              child: Text('Reset Password'),
            ),
          ],
        ),
      ),
    );
  }
}
