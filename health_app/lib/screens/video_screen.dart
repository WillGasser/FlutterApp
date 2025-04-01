import 'package:flutter/material.dart';
import 'login_screen.dart';

class VideoScreen extends StatefulWidget {
  const VideoScreen({super.key});

  @override
  State<VideoScreen> createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    // Create animation controller
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );

    // Create animations
    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutQuart,
      ),
    );

    // Start animation
    _controller.forward();

    // Start loop animation after initial animation
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.repeat(reverse: true, period: const Duration(seconds: 6));
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _goToLogin() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: _goToLogin,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Animated gradient background
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Theme.of(context).primaryColor.withOpacity(0.8),
                        Theme.of(context).primaryColor,
                        Theme.of(context).primaryColorDark,
                      ],
                      stops: [0.0, 0.5 + _controller.value * 0.2, 1.0],
                    ),
                  ),
                );
              },
            ),

            // Animated content
            Center(
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return Opacity(
                    opacity: _opacityAnimation.value,
                    child: Transform.scale(
                      scale: _scaleAnimation.value,
                      child: child,
                    ),
                  );
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Logo or icon
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 20,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.health_and_safety_outlined,
                        size: 70,
                        color: Colors.blue,
                      ),
                    ),
                    const SizedBox(height: 40),

                    // Title
                    const Text(
                      'Welcome to HOOM',
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Subtitle
                    const Text(
                      'Your Journey to Better Mental Wellness',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white70,
                        letterSpacing: 0.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),

            // Floating particles (optional)
            CustomPaint(
              painter: ParticlesPainter(_controller),
              size: Size.infinite,
            ),

            // "Tap to continue" overlay
            Positioned(
              bottom: 60,
              left: 0,
              right: 0,
              child: Center(
                child: AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    return AnimatedOpacity(
                      opacity: _controller.value > 0.7 ? 1.0 : 0.0,
                      duration: const Duration(milliseconds: 500),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 24),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: const Text(
                          'Tap to continue',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Particle painter for floating particles effect
class ParticlesPainter extends CustomPainter {
  final Animation<double> animation;
  final List<Particle> particles = [];

  ParticlesPainter(this.animation) : super(repaint: animation) {
    // Generate random particles
    for (int i = 0; i < 20; i++) {
      particles.add(Particle.random());
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    for (var particle in particles) {
      final paint = Paint()
        ..color =
            Colors.white.withOpacity(0.2 * animation.value * particle.opacity)
        ..style = PaintingStyle.fill;

      final position = Offset(
        particle.x * size.width,
        particle.y * size.height -
            (animation.value * particle.speed * size.height * 0.2),
      );

      // Create a circular particle
      canvas.drawCircle(position, particle.size * 3, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

// Particle class for the floating particles effect
class Particle {
  final double x;
  final double y;
  final double size;
  final double opacity;
  final double speed;

  Particle({
    required this.x,
    required this.y,
    required this.size,
    required this.opacity,
    required this.speed,
  });

  factory Particle.random() {
    return Particle(
      x: 0.1 + 0.8 * (DateTime.now().microsecondsSinceEpoch % 100) / 100,
      y: 0.1 + 0.8 * (DateTime.now().microsecondsSinceEpoch % 100) / 100,
      size: 0.05 + 0.05 * (DateTime.now().microsecondsSinceEpoch % 100) / 100,
      opacity: 0.1 + 0.2 * (DateTime.now().microsecondsSinceEpoch % 100) / 100,
      speed: 0.1 + 0.4 * (DateTime.now().microsecondsSinceEpoch % 100) / 100,
    );
  }
}
