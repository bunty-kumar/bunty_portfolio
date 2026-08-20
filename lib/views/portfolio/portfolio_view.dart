import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/portfolio_provider.dart';
import '../../utils/responsive_builder.dart';
import 'components/particle_background.dart';
import 'components/portfolio_shimmer_loader.dart';
import 'components/web_navbar.dart';
import 'components/hero_section.dart';
import 'components/about_section.dart';
import 'components/skills_section.dart';
import 'components/projects_section.dart';
import 'components/experience_section.dart';
import 'components/services_section.dart';
import 'components/testimonials_section.dart';
import 'components/contact_section.dart';
import 'components/footer.dart';

class PortfolioView extends StatefulWidget {
  final VoidCallback? onOpenAdmin;

  const PortfolioView({super.key, this.onOpenAdmin});

  @override
  State<PortfolioView> createState() => _PortfolioViewState();
}

class _PortfolioViewState extends State<PortfolioView> {
  final ScrollController _scrollController = ScrollController();
  String _activeSection = 'hero';

  final Map<String, GlobalKey> _sectionKeys = {
    'hero': GlobalKey(),
    'about': GlobalKey(),
    'skills': GlobalKey(),
    'projects': GlobalKey(),
    'experience': GlobalKey(),
    'services': GlobalKey(),
    'testimonials': GlobalKey(),
    'contact': GlobalKey(),
  };

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    for (final entry in _sectionKeys.entries) {
      final key = entry.value;
      if (key.currentContext != null) {
        final box = key.currentContext!.findRenderObject() as RenderBox?;
        if (box != null) {
          final position = box.localToGlobal(Offset.zero);
          if (position.dy <= 200 && position.dy + box.size.height > 200) {
            if (_activeSection != entry.key) {
              setState(() {
                _activeSection = entry.key;
              });
            }
            break;
          }
        }
      }
    }
  }

  void _scrollToSection(String sectionKey) {
    setState(() {
      _activeSection = sectionKey;
    });
    final key = _sectionKeys[sectionKey];
    if (key != null && key.currentContext != null) {
      Scrollable.ensureVisible(
        key.currentContext!,
        duration: const Duration(milliseconds: 700),
        curve: Curves.easeInOutCubic,
      );
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PortfolioProvider>(context);
    final theme = provider.theme;
    final isMobile = ResponsiveBuilder.isMobile(context);

    if (provider.isFetchingFromFirestore) {
      return PortfolioShimmerLoader(
        backgroundColor: theme.bgColor,
        primaryColor: theme.primaryColor,
      );
    }

    return Scaffold(
      backgroundColor: theme.bgColor,
      endDrawer: isMobile ? _buildMobileDrawer(context) : null,
      body: Stack(
        children: [
          // 1. Particle Background Mesh
          ParticleBackground(
            primaryColor: theme.primaryColor,
            secondaryColor: theme.secondaryColor,
            backgroundColor: theme.bgColor,
          ),

          // 2. Main Scrollable Content
          Column(
            children: [
              // Navbar
              WebNavbar(
                activeSection: _activeSection,
                onNavSelected: _scrollToSection,
              ),

              // Scrollable Sections
              Expanded(
                child: SingleChildScrollView(
                  controller: _scrollController,
                  child: Column(
                    children: [
                      Container(key: _sectionKeys['hero'], child: HeroSection(
                        onExploreClick: () => _scrollToSection('projects'),
                        onContactClick: () => _scrollToSection('contact'),
                      )),
                      Container(key: _sectionKeys['about'], child: const AboutSection()),
                      Container(key: _sectionKeys['skills'], child: const SkillsSection()),
                      Container(key: _sectionKeys['projects'], child: const ProjectsSection()),
                      Container(key: _sectionKeys['experience'], child: const ExperienceSection()),
                      Container(key: _sectionKeys['services'], child: const ServicesSection()),
                      Container(key: _sectionKeys['testimonials'], child: const TestimonialsSection()),
                      Container(key: _sectionKeys['contact'], child: const ContactSection()),
                      Footer(onScrollToTop: () => _scrollToSection('hero')),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMobileDrawer(BuildContext context) {
    final theme = Provider.of<PortfolioProvider>(context).theme;

    return Drawer(
      backgroundColor: theme.surfaceColor,
      child: ListView(
        padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
        children: [
          Text(
            'Navigation',
            style: TextStyle(color: theme.textColor, fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          _drawerItem('Home', 'hero', () => _scrollToSection('hero')),
          _drawerItem('About', 'about', () => _scrollToSection('about')),
          _drawerItem('Skills', 'skills', () => _scrollToSection('skills')),
          _drawerItem('Projects', 'projects', () => _scrollToSection('projects')),
          _drawerItem('Experience', 'experience', () => _scrollToSection('experience')),
          _drawerItem('Services', 'services', () => _scrollToSection('services')),
          _drawerItem('Testimonials', 'testimonials', () => _scrollToSection('testimonials')),
          _drawerItem('Contact', 'contact', () => _scrollToSection('contact')),
        ],
      ),
    );
  }

  Widget _drawerItem(String title, String key, VoidCallback onTap) {
    final theme = Provider.of<PortfolioProvider>(context, listen: false).theme;
    final isSelected = _activeSection == key;

    return ListTile(
      tileColor: isSelected ? theme.primaryColor.withValues(alpha: 0.15) : null,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      title: Text(
        title,
        style: TextStyle(
          color: isSelected ? theme.primaryColor : theme.textColor,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          fontSize: 16,
        ),
      ),
      trailing: isSelected ? Icon(Icons.check, color: theme.primaryColor, size: 18) : null,
      onTap: () {
        Navigator.pop(context);
        onTap();
      },
    );
  }
}
