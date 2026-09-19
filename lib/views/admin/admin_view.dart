import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/portfolio_provider.dart';
import '../../providers/auth_provider.dart';
import '../../utils/responsive_builder.dart';
import 'admin_login_dialog.dart';
import 'tabs/theme_editor_tab.dart';
import 'tabs/hero_editor_tab.dart';
import 'tabs/about_editor_tab.dart';
import 'tabs/projects_manager_tab.dart';
import 'tabs/skills_manager_tab.dart';
import 'tabs/experience_manager_tab.dart';
import 'tabs/services_manager_tab.dart';
import 'tabs/testimonials_manager_tab.dart';
import 'tabs/messages_inbox_tab.dart';
import 'tabs/config_settings_tab.dart';

class AdminView extends StatefulWidget {
  final VoidCallback? onReturnToPortfolio;

  const AdminView({super.key, this.onReturnToPortfolio});

  @override
  State<AdminView> createState() => _AdminViewState();
}

class _AdminViewState extends State<AdminView> {
  int _selectedTabIndex = 0;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PortfolioProvider>(context);
    final theme = provider.theme;
    final auth = Provider.of<AuthProvider>(context);
    final isMobile = ResponsiveBuilder.isMobile(context);

    // If not authenticated, show login dialog immediately
    if (!auth.isAuthenticated) {
      return Scaffold(
        backgroundColor: theme.bgColor,
        body: Center(
          child: AdminLoginDialog(
            onLoginSuccess: () {
              setState(() {});
            },
          ),
        ),
      );
    }

    final tabs = [
      const ThemeEditorTab(),
      const HeroEditorTab(),
      const AboutEditorTab(),
      const ProjectsManagerTab(),
      const SkillsManagerTab(),
      const ExperienceManagerTab(),
      const ServicesManagerTab(),
      const TestimonialsManagerTab(),
      const MessagesInboxTab(),
      const ConfigSettingsTab(),
    ];

    return Scaffold(
      backgroundColor: theme.bgColor,
      body: SafeArea(
        child: Column(
          children: [
            // Top Bar
            Container(
              height: 65,
              padding: const EdgeInsets.symmetric(horizontal: 24),
              decoration: BoxDecoration(
                color: theme.surfaceColor,
                border: Border(bottom: BorderSide(color: theme.primaryColor.withValues(alpha: 0.15))),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: theme.primaryColor.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(Icons.admin_panel_settings, color: theme.primaryColor, size: 22),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Admin CMS Dashboard',
                        style: TextStyle(color: theme.textColor, fontSize: 18, fontWeight: FontWeight.w800),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      IconButton(
                        tooltip: 'Logout Admin',
                        icon: const Icon(Icons.logout, color: Colors.redAccent),
                        onPressed: () => auth.logout(),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Main Dashboard Body
            Expanded(
              child: Row(
                children: [
                  // Left Navigation Sidebar
                  if (!isMobile)
                    Container(
                      width: 240,
                      decoration: BoxDecoration(
                        color: theme.surfaceColor.withValues(alpha: 0.8),
                        border: Border(right: BorderSide(color: theme.primaryColor.withValues(alpha: 0.15))),
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            const SizedBox(height: 16),
                            _buildSideNavItem(0, 'Theme Colors', Icons.palette),
                            _buildSideNavItem(1, 'Branding & Hero', Icons.edit_note),
                            _buildSideNavItem(2, 'About Section', Icons.person),
                            _buildSideNavItem(3, 'Projects', Icons.dashboard),
                            _buildSideNavItem(4, 'Skills & Tech', Icons.auto_awesome),
                            _buildSideNavItem(5, 'Work Timeline', Icons.work),
                            _buildSideNavItem(6, 'Services', Icons.miscellaneous_services),
                            _buildSideNavItem(7, 'Testimonials', Icons.rate_review),
                            _buildSideNavItem(8, 'Messages Inbox', Icons.inbox),
                            _buildSideNavItem(9, 'API Config', Icons.settings),
                            const SizedBox(height: 16),
                          ],
                        ),
                      ),
                    ),

                  // Content Area
                  Expanded(
                    child: Column(
                      children: [
                        if (isMobile)
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                            child: Row(
                              children: [
                                _buildMobileTabChip(0, 'Theme'),
                                _buildMobileTabChip(1, 'Branding'),
                                _buildMobileTabChip(2, 'About'),
                                _buildMobileTabChip(3, 'Projects'),
                                _buildMobileTabChip(4, 'Skills'),
                                _buildMobileTabChip(5, 'Timeline'),
                                _buildMobileTabChip(6, 'Services'),
                                _buildMobileTabChip(7, 'Reviews'),
                                _buildMobileTabChip(8, 'Inbox'),
                                _buildMobileTabChip(9, 'Config'),
                              ],
                            ),
                          ),
                        Expanded(child: tabs[_selectedTabIndex]),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSideNavItem(int index, String label, IconData icon) {
    final theme = Provider.of<PortfolioProvider>(context).theme;
    final isSelected = _selectedTabIndex == index;

    return InkWell(
      onTap: () => setState(() => _selectedTabIndex = index),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? theme.primaryColor.withValues(alpha: 0.16)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: isSelected
              ? Border.all(color: theme.primaryColor.withValues(alpha: 0.4), width: 1.5)
              : Border.all(color: Colors.transparent, width: 1.5),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected ? theme.primaryColor : theme.textColor.withValues(alpha: 0.7),
              size: 20,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  color: isSelected ? theme.primaryColor : theme.textColor,
                  fontSize: 14,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                ),
              ),
            ),
            if (isSelected)
              Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  color: theme.primaryColor,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(color: theme.primaryColor.withValues(alpha: 0.6), blurRadius: 4),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildMobileTabChip(int index, String label) {
    final theme = Provider.of<PortfolioProvider>(context).theme;
    final isSelected = _selectedTabIndex == index;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      child: ChoiceChip(
        label: Text(
          label,
          style: TextStyle(
            color: isSelected ? theme.primaryColor : theme.textColor,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            fontSize: 13,
          ),
        ),
        selected: isSelected,
        selectedColor: theme.primaryColor.withValues(alpha: 0.18),
        backgroundColor: theme.surfaceColor,
        side: BorderSide(
          color: isSelected ? theme.primaryColor.withValues(alpha: 0.5) : Colors.transparent,
        ),
        onSelected: (_) => setState(() => _selectedTabIndex = index),
      ),
    );
  }
}
