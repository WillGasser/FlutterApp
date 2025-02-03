import 'package:flutter/material.dart';

class AnimatedBackground extends StatefulWidget {
  final Widget child;

  const AnimatedBackground({Key? key, required this.child}) : super(key: key);

  @override
  State<AnimatedBackground> createState() => _AnimatedBackgroundState();
}

class _AnimatedBackgroundState extends State<AnimatedBackground>
    with TickerProviderStateMixin {
  late AnimationController _bgController;
  late Animation<Color?> _bgAnimation1;
  late Animation<Color?> _bgAnimation2;

  late AnimationController _cloudController;
  late Animation<double> _cloudAnimation;

  @override
  void initState() {
    super.initState();

    // Background gradient animation.
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

    // Cloud movement animation.
    _cloudController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    );
    _cloudAnimation = Tween<double>(begin: -150, end: 400).animate(
      CurvedAnimation(parent: _cloudController, curve: Curves.linear),
    );
    _cloudController.repeat();
  }

  @override
  void dispose() {
    _bgController.dispose();
    _cloudController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _bgController,
      builder: (context, child) {
        return Container(
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
              widget.child,
            ],
          ),
        );
      },
    );
  }
}
