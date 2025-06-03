import 'dart:math';

import 'package:flutter/material.dart';

import '../login/loginView.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 4), // Increased from 2 to 4 seconds
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(0.0, 0.7, curve: Curves.easeIn), // Extended interval
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(
          0.3,
          1.0,
          curve: Curves.elasticOut,
        ), // Extended interval
      ),
    );

    _controller.forward();

    // Navigate to login screen after 4 seconds
    Future.delayed(const Duration(seconds: 4), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LoginView()),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF88C9FF), // Sky blue from theme
              Color(0xFFA8E6CF), // Mint green from theme
            ],
          ),
        ),
        child: Stack(
          children: [
            // Animated background elements
            Positioned.fill(
              child: CustomPaint(
                painter: MagicalBackgroundPainter(animation: _controller),
              ),
            ),
            Center(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: ScaleTransition(
                  scale: _scaleAnimation,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // App Logo/Mascot with bounce effect
                      TweenAnimationBuilder<double>(
                        tween: Tween(begin: 0.0, end: 1.0),
                        duration: Duration(seconds: 2),
                        builder: (context, value, child) {
                          return Transform.translate(
                            offset: Offset(0, sin(value * 2 * pi) * 10),
                            child: Container(
                              width: 150,
                              height: 150,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 10,
                                    spreadRadius: 2,
                                  ),
                                ],
                              ),
                              child: Icon(
                                Icons.auto_stories,
                                size: 80,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 30),
                      // App Name
                      ShaderMask(
                        shaderCallback:
                            (bounds) => LinearGradient(
                              colors: [Color(0xFF88C9FF), Color(0xFFFFB5D8)],
                            ).createShader(bounds),
                        child: Text(
                          'whispertales',
                          style: Theme.of(
                            context,
                          ).textTheme.displayLarge?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 60,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),

                      // Tagline
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Custom painter for magical background effects
class MagicalBackgroundPainter extends CustomPainter {
  final Animation<double> animation;

  MagicalBackgroundPainter({required this.animation})
    : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = Colors.white.withOpacity(0.1)
          ..style = PaintingStyle.fill;

    // Slower floating stars/sparkles with fixed positions per star
    for (var i = 0; i < 50; i++) {
      final random = Random(i); // Use seed for consistent positions
      final baseX = random.nextDouble() * size.width;
      final baseY = random.nextDouble() * size.height;

      // Very slow vertical drift
      final y = (baseY + animation.value * 20) % (size.height + 50);
      final radius = random.nextDouble() * 3 + 1;

      // Slower twinkling effect
      paint.color = Colors.white.withOpacity(
        (0.05 + sin(animation.value * pi * 0.5 + i) * 0.05).clamp(0.0, 0.2),
      );

      canvas.drawCircle(Offset(baseX, y), radius, paint);
    }

    // Much slower floating clouds with gentle movement
    final cloudPaint =
        Paint()
          ..color = Colors.white.withOpacity(0.08)
          ..style = PaintingStyle.fill;

    for (var i = 0; i < 5; i++) {
      final random = Random(i + 100); // Different seed for clouds
      final baseX = random.nextDouble() * size.width;
      final baseY = random.nextDouble() * size.height;
      final radius = random.nextDouble() * 40 + 20;

      // Extremely slow horizontal drift
      final x = (baseX + animation.value * 30) % (size.width + radius * 2);

      // Gentle vertical floating
      final y = baseY + sin(animation.value * pi * 0.3 + i) * 8;

      // Create soft cloud shape
      canvas.drawCircle(Offset(x, y), radius, cloudPaint);
      canvas.drawCircle(
        Offset(x + radius * 0.6, y - radius * 0.3),
        radius * 0.8,
        cloudPaint,
      );
      canvas.drawCircle(
        Offset(x - radius * 0.4, y - radius * 0.2),
        radius * 0.7,
        cloudPaint,
      );
    }

    // Add some very subtle floating particles
    final particlePaint =
        Paint()
          ..color = Colors.white.withOpacity(0.03)
          ..style = PaintingStyle.fill;

    for (var i = 0; i < 20; i++) {
      final random = Random(i + 200);
      final baseX = random.nextDouble() * size.width;
      final baseY = random.nextDouble() * size.height;

      final x = (baseX + animation.value * 10) % size.width;
      final y =
          (baseY + sin(animation.value * pi * 0.2 + i) * 15) % size.height;

      canvas.drawCircle(Offset(x, y), 1.5, particlePaint);
    }
  }

  @override
  bool shouldRepaint(MagicalBackgroundPainter oldDelegate) => true;
}
