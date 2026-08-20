import 'dart:math' as math;
import 'package:flutter/material.dart';

class ParticleBackground extends StatefulWidget {
  final Color primaryColor;
  final Color secondaryColor;
  final Color backgroundColor;

  const ParticleBackground({
    super.key,
    required this.primaryColor,
    required this.secondaryColor,
    required this.backgroundColor,
  });

  @override
  State<ParticleBackground> createState() => _ParticleBackgroundState();
}

class _ParticleBackgroundState extends State<ParticleBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<_Particle> _particles = [];
  final math.Random _random = math.Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();

    for (int i = 0; i < 35; i++) {
      _particles.add(
        _Particle(
          x: _random.nextDouble(),
          y: _random.nextDouble(),
          radius: _random.nextDouble() * 3 + 1.5,
          speedX: (_random.nextDouble() - 0.5) * 0.0005,
          speedY: (_random.nextDouble() - 0.5) * 0.0005,
          opacity: _random.nextDouble() * 0.5 + 0.2,
          isPrimary: _random.nextBool(),
        ),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          size: Size.infinite,
          painter: _ParticlePainter(
            particles: _particles,
            primaryColor: widget.primaryColor,
            secondaryColor: widget.secondaryColor,
            backgroundColor: widget.backgroundColor,
          ),
        );
      },
    );
  }
}

class _Particle {
  double x;
  double y;
  double radius;
  double speedX;
  double speedY;
  double opacity;
  bool isPrimary;

  _Particle({
    required this.x,
    required this.y,
    required this.radius,
    required this.speedX,
    required this.speedY,
    required this.opacity,
    required this.isPrimary,
  });

  void update() {
    x += speedX;
    y += speedY;
    if (x < 0) x = 1;
    if (x > 1) x = 0;
    if (y < 0) y = 1;
    if (y > 1) y = 0;
  }
}

class _ParticlePainter extends CustomPainter {
  final List<_Particle> particles;
  final Color primaryColor;
  final Color secondaryColor;
  final Color backgroundColor;

  _ParticlePainter({
    required this.particles,
    required this.primaryColor,
    required this.secondaryColor,
    required this.backgroundColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Fill background
    final bgPaint = Paint()..color = backgroundColor;
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), bgPaint);

    // Draw ambient background glows
    final primaryGlow = Paint()
      ..color = primaryColor.withValues(alpha: 0.07)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 120);
    canvas.drawCircle(Offset(size.width * 0.2, size.height * 0.2), 250, primaryGlow);

    final secondaryGlow = Paint()
      ..color = secondaryColor.withValues(alpha: 0.06)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 140);
    canvas.drawCircle(Offset(size.width * 0.8, size.height * 0.7), 300, secondaryGlow);

    // Update and draw particles
    for (var particle in particles) {
      particle.update();
      final offset = Offset(particle.x * size.width, particle.y * size.height);
      final color = particle.isPrimary ? primaryColor : secondaryColor;
      final paint = Paint()
        ..color = color.withValues(alpha: particle.opacity)
        ..style = PaintingStyle.fill;
      canvas.drawCircle(offset, particle.radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _ParticlePainter oldDelegate) => true;
}
