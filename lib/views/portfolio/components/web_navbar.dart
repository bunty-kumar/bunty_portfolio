import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/portfolio_provider.dart';
import '../../../utils/responsive_builder.dart';

class WebNavbar extends StatelessWidget {
  final String activeSection;
  final Function(String sectionKey) onNavSelected;

  const WebNavbar({
    super.key,
    required this.activeSection,
    required this.onNavSelected,
  });

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PortfolioProvider>(context);
    final theme = provider.theme;
    final branding = provider.branding;
    final isMobile = ResponsiveBuilder.isMobile(context);

    return Container(
      height: 75,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        color: theme.bgColor.withValues(alpha: 0.85),
        border: Border(
          bottom: BorderSide(
            color: theme.primaryColor.withValues(alpha: 0.15),
            width: 1,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Brand Logo / Title
          InkWell(
            onTap: () => onNavSelected('hero'),
            child: Row(
              children: [
                if (branding.logoUrl.isNotEmpty) ...[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: branding.logoUrl.startsWith('assets/')
                        ? Image.asset(
                            branding.logoUrl,
                            height: 38,
                            width: 38,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => Icon(
                              Icons.bolt,
                              color: theme.primaryColor,
                              size: 32,
                            ),
                          )
                        : Image.network(
                            branding.logoUrl,
                            height: 38,
                            width: 38,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => Icon(
                              Icons.bolt,
                              color: theme.primaryColor,
                              size: 32,
                            ),
                          ),
                  ),
                  const SizedBox(width: 12),
                ] else ...[
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [theme.primaryColor, theme.secondaryColor],
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.code,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                ],
                Text(
                  branding.siteTitle,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.2,
                    color: theme.textColor,
                  ),
                ),
              ],
            ),
          ),

          // Desktop Links
          if (!isMobile)
            Row(
              children: [
                _NavLink(
                  label: 'Home',
                  isSelected: activeSection == 'hero',
                  onTap: () => onNavSelected('hero'),
                ),
                _NavLink(
                  label: 'About',
                  isSelected: activeSection == 'about',
                  onTap: () => onNavSelected('about'),
                ),
                _NavLink(
                  label: 'Skills',
                  isSelected: activeSection == 'skills',
                  onTap: () => onNavSelected('skills'),
                ),
                _NavLink(
                  label: 'Projects',
                  isSelected: activeSection == 'projects',
                  onTap: () => onNavSelected('projects'),
                ),
                _NavLink(
                  label: 'Experience',
                  isSelected: activeSection == 'experience',
                  onTap: () => onNavSelected('experience'),
                ),
                _NavLink(
                  label: 'Services',
                  isSelected: activeSection == 'services',
                  onTap: () => onNavSelected('services'),
                ),
                _NavLink(
                  label: 'Testimonials',
                  isSelected: activeSection == 'testimonials',
                  onTap: () => onNavSelected('testimonials'),
                ),
                _NavLink(
                  label: 'Contact',
                  isSelected: activeSection == 'contact',
                  onTap: () => onNavSelected('contact'),
                ),
              ],
            ),

          // Action items (Get In Touch CTA)
          Row(
            children: [
              // Resume / Contact CTA Button
              ElevatedButton.icon(
                onPressed: () => onNavSelected('contact'),
                icon: const Icon(Icons.send, size: 16),
                label: Text(isMobile ? 'Contact' : 'Get In Touch'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 14,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  elevation: 4,
                  shadowColor: theme.primaryColor.withValues(alpha: 0.5),
                ),
              ),

              if (isMobile) ...[
                const SizedBox(width: 8),
                IconButton(
                  icon: Icon(Icons.menu, color: theme.textColor),
                  onPressed: () {
                    Scaffold.of(context).openEndDrawer();
                  },
                ),
              ]
            ],
          ),
        ],
      ),
    );
  }
}

class _NavLink extends StatefulWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavLink({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<_NavLink> createState() => _NavLinkState();
}

class _NavLinkState extends State<_NavLink> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<PortfolioProvider>(context).theme;
    final active = widget.isSelected || _isHovered;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 6),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: active
                ? theme.primaryColor.withValues(alpha: 0.15)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            border: widget.isSelected
                ? Border.all(color: theme.primaryColor.withValues(alpha: 0.4), width: 1.5)
                : Border.all(color: Colors.transparent, width: 1.5),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: active ? FontWeight.bold : FontWeight.w500,
                  color: active ? theme.primaryColor : theme.textColor.withValues(alpha: 0.85),
                ),
              ),
              if (widget.isSelected) ...[
                const SizedBox(height: 2),
                Container(
                  width: 14,
                  height: 3,
                  decoration: BoxDecoration(
                    color: theme.primaryColor,
                    borderRadius: BorderRadius.circular(2),
                    boxShadow: [
                      BoxShadow(
                        color: theme.primaryColor.withValues(alpha: 0.6),
                        blurRadius: 4,
                      )
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
