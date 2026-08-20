import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart' hide AuthProvider;
import '../../providers/auth_provider.dart';
import '../../providers/portfolio_provider.dart';

class AdminLoginDialog extends StatefulWidget {
  final VoidCallback onLoginSuccess;

  const AdminLoginDialog({super.key, required this.onLoginSuccess});

  @override
  State<AdminLoginDialog> createState() => _AdminLoginDialogState();
}

class _AdminLoginDialogState extends State<AdminLoginDialog> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String? _infoMessage;
  bool _sendingReset = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleAuth() async {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter both email and password.')),
      );
      return;
    }

    setState(() => _infoMessage = null);
    final success = await auth.login(email, password);

    if (success && mounted) {
      widget.onLoginSuccess();
    }
  }

  Future<void> _sendPasswordReset() async {
    final email = _emailController.text.trim();
    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your email address first.')),
      );
      return;
    }

    setState(() {
      _sendingReset = true;
      _infoMessage = null;
    });

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      setState(() {
        _sendingReset = false;
        _infoMessage = 'Password reset email sent to $email! Please check your inbox.';
      });
    } catch (e) {
      setState(() {
        _sendingReset = false;
        _infoMessage = 'Password reset email sent! Check your inbox.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<PortfolioProvider>(context).theme;
    final auth = Provider.of<AuthProvider>(context);

    return Dialog(
      backgroundColor: theme.surfaceColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Container(
        padding: const EdgeInsets.all(32),
        constraints: const BoxConstraints(maxWidth: 420),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: theme.primaryColor.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.admin_panel_settings, color: theme.primaryColor, size: 28),
                ),
                const SizedBox(width: 14),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Admin Login',
                      style: TextStyle(
                        color: theme.textColor,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Authorized Firebase CMS Access',
                      style: TextStyle(
                        color: theme.textColor.withValues(alpha: 0.6),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 24),

            if (_infoMessage != null)
              Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.greenAccent.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.greenAccent.withValues(alpha: 0.4)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.check_circle_outline, color: Colors.greenAccent, size: 18),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _infoMessage!,
                        style: const TextStyle(color: Colors.greenAccent, fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ),

            if (auth.errorMessage != null)
              Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.redAccent.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.redAccent.withValues(alpha: 0.4)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.error_outline, color: Colors.redAccent, size: 18),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        auth.errorMessage!,
                        style: const TextStyle(color: Colors.redAccent, fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ),

            TextFormField(
              controller: _emailController,
              autofillHints: const [],
              style: TextStyle(color: theme.textColor),
              decoration: InputDecoration(
                labelText: 'Admin Email',
                labelStyle: TextStyle(color: theme.textColor.withValues(alpha: 0.7)),
                prefixIcon: Icon(Icons.email, color: theme.primaryColor, size: 20),
                filled: true,
                fillColor: theme.cardColor,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              ),
            ),
            const SizedBox(height: 16),

            TextFormField(
              controller: _passwordController,
              obscureText: true,
              style: TextStyle(color: theme.textColor),
              decoration: InputDecoration(
                labelText: 'Password',
                labelStyle: TextStyle(color: theme.textColor.withValues(alpha: 0.7)),
                prefixIcon: Icon(Icons.lock, color: theme.primaryColor, size: 20),
                filled: true,
                fillColor: theme.cardColor,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              ),
              onFieldSubmitted: (_) => _handleAuth(),
            ),
            const SizedBox(height: 12),

            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: _sendingReset ? null : _sendPasswordReset,
                child: Text(
                  _sendingReset ? 'Sending Email...' : 'Forgot Password? Send Reset Link',
                  style: TextStyle(color: theme.primaryColor, fontSize: 12),
                ),
              ),
            ),
            const SizedBox(height: 16),

            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: auth.isLoading ? null : _handleAuth,
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.primaryColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: auth.isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                      )
                    : const Text(
                        'Sign In to Dashboard',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
