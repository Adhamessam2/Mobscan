import 'package:flutter/material.dart';


import '../../services/auth_service.dart';
import '../admin_blacklist_screen.dart';
import '../home_page.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final AuthService _authService = AuthService();
  bool _isLoading = false;
  late final AnimationController _controller;
  late final Animation<double> _fadeIn;
  late final Animation<Offset> _slideUp;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _fadeIn = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _slideUp = Tween<Offset>(
      begin: const Offset(0, 0.08),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _handleGoogleSignIn() async {
    setState(() => _isLoading = true);

    try {
      final result = await _authService.signInWithGoogle();

      if (result == null) {
        if (mounted) {
          _showSnack('Sign in cancelled', isError: false);
        }
        return;
      }

      if (!mounted) return;

      if (_authService.isAdmin) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => const AdminBlacklistScreen(),
          ),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => const HomePage(),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        _showSnack('Error: $e', isError: true);
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showSnack(String message, {required bool isError}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: isError
            ? const Color(0xFFE5484D)
            : const Color(0xFF1B2A38),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        content: Text(
          message,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF071826),
      body: Stack(
        children: [

          Positioned(
            top: -120,
            right: -80,
            child: _GlowCircle(
              color: const Color(0xFF007BFF).withOpacity(0.25),
              size: 280,
            ),
          ),
          Positioned(
            bottom: -100,
            left: -100,
            child: _GlowCircle(
              color: const Color(0xFF00E0C7).withOpacity(0.15),
              size: 260,
            ),
          ),

          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 28),
                child: FadeTransition(
                  opacity: _fadeIn,
                  child: SlideTransition(
                    position: _slideUp,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildLogo(),
                        const SizedBox(height: 28),
                        const Text(
                          'MobScan',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 34,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Scan smarter. Stay protected.',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.55),
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const SizedBox(height: 52),
                        _buildGoogleButton(),
                        const SizedBox(height: 24),
                        Text(
                          'By continuing, you agree to our Terms & Privacy Policy',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.35),
                            fontSize: 12,
                          ),
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
    );
  }

  Widget _buildLogo() {
    return Container(
      width: 92,
      height: 92,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const LinearGradient(
          colors: [Color(0xFF007BFF), Color(0xFF00C2FF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF007BFF).withOpacity(0.4),
            blurRadius: 30,
            spreadRadius: 2,
          ),
        ],
      ),
      child: const Icon(
        Icons.shield_outlined,
        color: Colors.white,
        size: 44,
      ),
    );
  }

  Widget _buildGoogleButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: Material(
        color: const Color(0xFF0F1923),
        borderRadius: BorderRadius.circular(16),
        elevation: 0,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: _isLoading ? null : _handleGoogleSignIn,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Colors.white.withOpacity(0.08),
              ),
            ),
            child: Center(
              child: _isLoading
                  ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2.4,
                  color: Color(0xFF007BFF),
                ),
              )
                  : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(2),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: const _GoogleGIcon(size: 18),
                  ),
                  const SizedBox(width: 14),
                  const Text(
                    'Continue with Google',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _GlowCircle extends StatelessWidget {
  final Color color;
  final double size;

  const _GlowCircle({required this.color, required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [color, color.withOpacity(0)],
        ),
      ),
    );
  }
}


class _GoogleGIcon extends StatelessWidget {
  final double size;
  const _GoogleGIcon({required this.size});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(painter: _GooglePainter()),
    );
  }
}

class _GooglePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final r = size.width / 2;
    final center = Offset(r, r);
    final paintBlue = Paint()..color = const Color(0xFF4285F4);
    final paintGreen = Paint()..color = const Color(0xFF34A853);
    final paintYellow = Paint()..color = const Color(0xFFFBBC05);
    final paintRed = Paint()..color = const Color(0xFFEA4335);

    canvas.drawArc(Rect.fromCircle(center: center, radius: r), -0.5, 1.6,
        true, paintBlue);
    canvas.drawArc(Rect.fromCircle(center: center, radius: r), 1.1, 1.6,
        true, paintGreen);
    canvas.drawArc(Rect.fromCircle(center: center, radius: r), 2.7, 1.6,
        true, paintYellow);
    canvas.drawArc(Rect.fromCircle(center: center, radius: r), 4.3, 1.6,
        true, paintRed);

    canvas.drawCircle(center, r * 0.55, Paint()..color = Colors.white);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}