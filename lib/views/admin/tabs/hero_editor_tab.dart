import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/portfolio_provider.dart';
import '../../../models/portfolio_models.dart';
import '../components/github_image_picker.dart';

class HeroEditorTab extends StatefulWidget {
  const HeroEditorTab({super.key});

  @override
  State<HeroEditorTab> createState() => _HeroEditorTabState();
}

class _HeroEditorTabState extends State<HeroEditorTab> {
  late TextEditingController _titleController;
  late TextEditingController _subtitleController;
  late TextEditingController _resumeController;
  late TextEditingController _logoUrlController;

  late TextEditingController _greetingController;
  late TextEditingController _nameController;
  late TextEditingController _rolesController;
  late TextEditingController _bioController;
  late TextEditingController _badgeController;
  late TextEditingController _profileImageController;
  late TextEditingController _primaryCtaController;
  late TextEditingController _secondaryCtaController;

  late TextEditingController _githubController;
  late TextEditingController _linkedinController;
  late TextEditingController _twitterController;
  late TextEditingController _instagramController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _locationController;

  @override
  void initState() {
    super.initState();
    final provider = Provider.of<PortfolioProvider>(context, listen: false);
    final b = provider.branding;
    final h = provider.hero;
    final s = provider.socials;

    _titleController = TextEditingController(text: b.siteTitle);
    _subtitleController = TextEditingController(text: b.subtitle);
    _resumeController = TextEditingController(text: b.resumeUrl);
    _logoUrlController = TextEditingController(text: b.logoUrl);

    _greetingController = TextEditingController(text: h.greeting);
    _nameController = TextEditingController(text: h.name);
    _rolesController = TextEditingController(text: h.roles.join(', '));
    _bioController = TextEditingController(text: h.bio);
    _badgeController = TextEditingController(text: h.badgeText);
    _profileImageController = TextEditingController(text: h.profileImageUrl);
    _primaryCtaController = TextEditingController(text: h.primaryCtaText);
    _secondaryCtaController = TextEditingController(text: h.secondaryCtaText);

    _githubController = TextEditingController(text: s.github);
    _linkedinController = TextEditingController(text: s.linkedin);
    _twitterController = TextEditingController(text: s.twitter);
    _instagramController = TextEditingController(text: s.instagram);
    _emailController = TextEditingController(text: s.email);
    _phoneController = TextEditingController(text: s.phone);
    _locationController = TextEditingController(text: s.location);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _subtitleController.dispose();
    _resumeController.dispose();
    _logoUrlController.dispose();

    _greetingController.dispose();
    _nameController.dispose();
    _rolesController.dispose();
    _bioController.dispose();
    _badgeController.dispose();
    _profileImageController.dispose();
    _primaryCtaController.dispose();
    _secondaryCtaController.dispose();

    _githubController.dispose();
    _linkedinController.dispose();
    _twitterController.dispose();
    _instagramController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  Future<void> _saveAll() async {
    final provider = Provider.of<PortfolioProvider>(context, listen: false);

    // Save Branding
    await provider.updateBranding(
      BrandingModel(
        siteTitle: _titleController.text.trim(),
        subtitle: _subtitleController.text.trim(),
        logoUrl: _logoUrlController.text.trim(),
        resumeUrl: _resumeController.text.trim(),
      ),
    );

    // Save Hero
    final rolesList = _rolesController.text
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();

    await provider.updateHero(
      HeroModel(
        greeting: _greetingController.text.trim(),
        name: _nameController.text.trim(),
        roles: rolesList.isNotEmpty ? rolesList : ['Developer'],
        bio: _bioController.text.trim(),
        profileImageUrl: _profileImageController.text.trim(),
        badgeText: _badgeController.text.trim(),
        primaryCtaText: _primaryCtaController.text.trim(),
        secondaryCtaText: _secondaryCtaController.text.trim(),
      ),
    );

    // Save Socials
    await provider.updateSocials(
      SocialsModel(
        github: _githubController.text.trim(),
        linkedin: _linkedinController.text.trim(),
        twitter: _twitterController.text.trim(),
        instagram: _instagramController.text.trim(),
        email: _emailController.text.trim(),
        phone: _phoneController.text.trim(),
        location: _locationController.text.trim(),
      ),
    );

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Branding & Hero Content saved successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<PortfolioProvider>(context).theme;
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 650;

    return SingleChildScrollView(
      padding: EdgeInsets.all(isMobile ? 16 : 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Responsive Header with Wrap
          Wrap(
            spacing: 16,
            runSpacing: 16,
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Branding & Hero Content Editor',
                    style: TextStyle(
                      color: theme.textColor,
                      fontSize: isMobile ? 20 : 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Manage your name, roles, bio, logo, profile picture, and social links',
                    style: TextStyle(
                      color: theme.textColor.withValues(alpha: 0.6),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              ElevatedButton.icon(
                onPressed: _saveAll,
                icon: const Icon(Icons.save, size: 18),
                label: const Text('Save Changes'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // 1. Branding Section
          _buildCard(
            context,
            title: '1. Site Branding & Logo',
            child: Column(
              children: [
                _buildPair(
                  isMobile,
                  _buildTextField(theme, 'Site Title / Brand Name', _titleController),
                  _buildTextField(theme, 'Subtitle / Tagline', _subtitleController),
                ),
                const SizedBox(height: 16),
                GitHubImagePicker(
                  initialUrl: _logoUrlController.text,
                  label: 'Brand Logo Image (GitHub Raw URL / Asset Path)',
                  onImageChanged: (url) => setState(() => _logoUrlController.text = url),
                ),
                const SizedBox(height: 16),
                _buildTextField(theme, 'Resume URL (PDF / GitHub raw link)', _resumeController),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // 2. Hero Section
          _buildCard(
            context,
            title: '2. Hero Main Banner & Profile Photo',
            child: Column(
              children: [
                GitHubImagePicker(
                  initialUrl: _profileImageController.text,
                  label: 'Profile Photo (GitHub Raw URL / Asset Path)',
                  onImageChanged: (url) => setState(() => _profileImageController.text = url),
                ),
                const SizedBox(height: 16),
                _buildPair(
                  isMobile,
                  _buildTextField(theme, 'Greeting Text (e.g. Hello, I\'m)', _greetingController),
                  _buildTextField(theme, 'Full Name', _nameController),
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  theme,
                  'Typing Roles (comma-separated, e.g. Flutter Architect, Full Stack Developer)',
                  _rolesController,
                ),
                const SizedBox(height: 16),
                _buildTextField(theme, 'Availability Badge Text', _badgeController),
                const SizedBox(height: 16),
                _buildPair(
                  isMobile,
                  _buildTextField(theme, 'Primary CTA Button Text', _primaryCtaController),
                  _buildTextField(theme, 'Secondary CTA Button Text', _secondaryCtaController),
                ),
                const SizedBox(height: 16),
                _buildTextField(theme, 'Short Bio Paragraph', _bioController, maxLines: 3),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // 3. Socials Section
          _buildCard(
            context,
            title: '3. Social Links & Contact Details',
            child: Column(
              children: [
                _buildPair(
                  isMobile,
                  _buildTextField(theme, 'GitHub Profile URL', _githubController),
                  _buildTextField(theme, 'LinkedIn Profile URL', _linkedinController),
                ),
                const SizedBox(height: 16),
                _buildPair(
                  isMobile,
                  _buildTextField(theme, 'Twitter / X URL', _twitterController),
                  _buildTextField(theme, 'Instagram URL', _instagramController),
                ),
                const SizedBox(height: 16),
                _buildPair(
                  isMobile,
                  _buildTextField(theme, 'Public Email', _emailController),
                  _buildTextField(theme, 'Phone Number', _phoneController),
                ),
                const SizedBox(height: 16),
                _buildTextField(theme, 'Location / Address', _locationController),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPair(bool isMobile, Widget field1, Widget field2) {
    if (isMobile) {
      return Column(
        children: [
          field1,
          const SizedBox(height: 16),
          field2,
        ],
      );
    }
    return Row(
      children: [
        Expanded(child: field1),
        const SizedBox(width: 16),
        Expanded(child: field2),
      ],
    );
  }

  Widget _buildCard(BuildContext context, {required String title, required Widget child}) {
    final theme = Provider.of<PortfolioProvider>(context).theme;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: theme.primaryColor.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: theme.textColor,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }

  Widget _buildTextField(ThemeConfigModel theme, String label, TextEditingController controller, {int maxLines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(color: theme.textColor, fontSize: 13, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          style: TextStyle(color: theme.textColor, fontSize: 14),
          decoration: InputDecoration(
            filled: true,
            fillColor: theme.surfaceColor,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
          ),
        ),
      ],
    );
  }
}
