import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../providers/portfolio_provider.dart';
import '../../../models/portfolio_models.dart';
import '../../../utils/responsive_builder.dart';
import 'social_links_row.dart';

class ContactSection extends StatefulWidget {
  const ContactSection({super.key});

  @override
  State<ContactSection> createState() => _ContactSectionState();
}

class _ContactSectionState extends State<ContactSection> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _subjectController = TextEditingController();
  final _messageController = TextEditingController();
  bool _isSending = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _subjectController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSending = true);
    final provider = Provider.of<PortfolioProvider>(context, listen: false);

    final name = _nameController.text.trim();
    final userEmail = _emailController.text.trim();
    final subject = _subjectController.text.trim();
    final body = _messageController.text.trim();

    final msg = ContactMessageModel(
      id: '',
      name: name,
      email: userEmail,
      subject: subject,
      message: body,
      timestamp: DateTime.now(),
      read: false,
    );

    // 1. Save message to Firestore/Admin Inbox
    await provider.sendContactMessage(msg);

    // 2. Open Mail client directly pre-filled with recipient email, subject, and message
    final recipientEmail = provider.socials.email.isNotEmpty
        ? provider.socials.email
        : 'bunty.k.dev@gmail.com';

    final Uri mailUri = Uri(
      scheme: 'mailto',
      path: recipientEmail,
      queryParameters: {
        'subject': 'Portfolio Contact: $subject (from $name)',
        'body': 'Name: $name\nEmail: $userEmail\n\nMessage:\n$body',
      },
    );

    try {
      if (await canLaunchUrl(mailUri)) {
        await launchUrl(mailUri, mode: LaunchMode.externalApplication);
      }
    } catch (_) {}

    if (mounted) {
      setState(() => _isSending = false);
      _nameController.clear();
      _emailController.clear();
      _subjectController.clear();
      _messageController.clear();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.check_circle, color: Colors.white),
              SizedBox(width: 12),
              Text('Message saved & email client opened!'),
            ],
          ),
          backgroundColor: provider.theme.primaryColor,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveBuilder.isMobile(context);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 20 : 64,
        vertical: 60,
      ),
      child: Column(
        children: [
          _buildHeader(
            context,
            subtitle: "GET IN TOUCH",
            title: "Contact Me",
          ),
          const SizedBox(height: 48),

          ResponsiveBuilder(
            mobile: Column(
              children: [
                _buildContactInfoGrid(context),
                const SizedBox(height: 36),
                _buildFormCard(context),
              ],
            ),
            desktop: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 5,
                  child: _buildContactInfoGrid(context),
                ),
                const SizedBox(width: 48),
                Expanded(
                  flex: 7,
                  child: _buildFormCard(context),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactInfoGrid(BuildContext context) {
    final provider = Provider.of<PortfolioProvider>(context);
    final socials = provider.socials;

    final emailVal = socials.email.isNotEmpty ? socials.email : "bunty.k.dev@gmail.com";
    final phoneVal = socials.phone.isNotEmpty ? socials.phone : "+91-8058775532";
    final locationVal = socials.location.isNotEmpty ? socials.location : "Patna, India";

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInfoCard(
          context,
          icon: Icons.email,
          title: "Email Me",
          value: emailVal,
          onTap: () async {
            final uri = Uri.parse('mailto:$emailVal');
            try {
              if (await canLaunchUrl(uri)) {
                await launchUrl(uri, mode: LaunchMode.externalApplication);
              }
            } catch (_) {}
          },
        ),
        const SizedBox(height: 16),
        _buildInfoCard(
          context,
          icon: Icons.phone,
          title: "Call Me",
          value: phoneVal,
          onTap: () async {
            final cleanPhone = phoneVal.replaceAll(RegExp(r'[^0-9+]'), '');
            final uri = Uri.parse('tel:$cleanPhone');
            try {
              if (await canLaunchUrl(uri)) {
                await launchUrl(uri, mode: LaunchMode.externalApplication);
              }
            } catch (_) {}
          },
        ),
        const SizedBox(height: 16),
        _buildInfoCard(
          context,
          icon: Icons.location_on,
          title: "Location",
          value: locationVal,
          onTap: () async {
            final uri = Uri.parse('https://maps.google.com/?q=${Uri.encodeComponent(locationVal)}');
            try {
              if (await canLaunchUrl(uri)) {
                await launchUrl(uri, mode: LaunchMode.externalApplication);
              }
            } catch (_) {}
          },
        ),
        const SizedBox(height: 24),
        Text(
          'Connect on Socials',
          style: TextStyle(
            color: provider.theme.textColor,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        const SocialLinksRow(iconSize: 20, padding: 12),
      ],
    );
  }

  Widget _buildInfoCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String value,
    required VoidCallback onTap,
  }) {
    final theme = Provider.of<PortfolioProvider>(context).theme;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: theme.cardColor.withValues(alpha: 0.6),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: theme.primaryColor.withValues(alpha: 0.15),
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: theme.primaryColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: theme.primaryColor, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: theme.textColor.withValues(alpha: 0.6),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      value,
                      style: TextStyle(
                        color: theme.textColor,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.open_in_new, color: theme.textColor.withValues(alpha: 0.4), size: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFormCard(BuildContext context) {
    final theme = Provider.of<PortfolioProvider>(context).theme;

    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: theme.cardColor.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: theme.primaryColor.withValues(alpha: 0.2),
        ),
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Send a Message",
              style: TextStyle(
                color: theme.textColor,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),

            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _nameController,
                    style: TextStyle(color: theme.textColor),
                    decoration: _inputDecoration(theme, 'Your Name', Icons.person),
                    validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    controller: _emailController,
                    style: TextStyle(color: theme.textColor),
                    decoration: _inputDecoration(theme, 'Your Email', Icons.email),
                    validator: (v) => v == null || !v.contains('@') ? 'Valid email required' : null,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            TextFormField(
              controller: _subjectController,
              style: TextStyle(color: theme.textColor),
              decoration: _inputDecoration(theme, 'Subject', Icons.subject),
              validator: (v) => v == null || v.isEmpty ? 'Required' : null,
            ),
            const SizedBox(height: 16),

            TextFormField(
              controller: _messageController,
              maxLines: 4,
              style: TextStyle(color: theme.textColor),
              decoration: _inputDecoration(theme, 'Message...', Icons.message),
              validator: (v) => v == null || v.isEmpty ? 'Required' : null,
            ),
            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: _isSending ? null : _submitForm,
                icon: _isSending
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Icon(Icons.send),
                label: Text(
                  _isSending ? 'Sending...' : 'Send Message',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.primaryColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(ThemeConfigModel theme, String hint, IconData icon) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: theme.textColor.withValues(alpha: 0.4)),
      prefixIcon: Icon(icon, color: theme.primaryColor, size: 20),
      filled: true,
      fillColor: theme.surfaceColor,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: theme.primaryColor, width: 1.5),
      ),
    );
  }

  Widget _buildHeader(
    BuildContext context, {
    required String subtitle,
    required String title,
  }) {
    final theme = Provider.of<PortfolioProvider>(context).theme;
    return Column(
      children: [
        Text(
          subtitle,
          style: TextStyle(
            color: theme.primaryColor,
            fontSize: 13,
            fontWeight: FontWeight.bold,
            letterSpacing: 2.0,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          title,
          style: TextStyle(
            color: theme.textColor,
            fontSize: 34,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          width: 60,
          height: 4,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [theme.primaryColor, theme.secondaryColor],
            ),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ],
    );
  }
}
