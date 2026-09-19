import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../providers/portfolio_provider.dart';

class SocialLinksRow extends StatelessWidget {
  final double iconSize;
  final double padding;

  const SocialLinksRow({
    super.key,
    this.iconSize = 20,
    this.padding = 10,
  });

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PortfolioProvider>(context);
    final s = provider.socials;

    final socialItems = <_SocialItemData>[
      if (s.github.isNotEmpty)
        _SocialItemData('GitHub', Icons.code, s.github),
      if (s.linkedin.isNotEmpty)
        _SocialItemData('LinkedIn', Icons.work_history, s.linkedin),
      if (s.twitter.isNotEmpty)
        _SocialItemData('Twitter / X', Icons.alternate_email, s.twitter),
      if (s.instagram.isNotEmpty)
        _SocialItemData('Instagram', Icons.camera_alt, s.instagram),
      if (s.email.isNotEmpty)
        _SocialItemData('Email', Icons.email, 'mailto:${s.email}'),
    ];

    if (socialItems.isEmpty) return const SizedBox.shrink();

    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: socialItems.map((item) {
        return _SocialButton(
          item: item,
          iconSize: iconSize,
          padding: padding,
        );
      }).toList(),
    );
  }
}

class _SocialItemData {
  final String label;
  final IconData icon;
  final String url;

  _SocialItemData(this.label, this.icon, this.url);
}

class _SocialButton extends StatefulWidget {
  final _SocialItemData item;
  final double iconSize;
  final double padding;

  const _SocialButton({
    required this.item,
    required this.iconSize,
    required this.padding,
  });

  @override
  State<_SocialButton> createState() => _SocialButtonState();
}

class _SocialButtonState extends State<_SocialButton> {
  bool _isHovered = false;

  Future<void> _launch(String urlString) async {
    if (urlString.isEmpty) return;
    final Uri uri = Uri.parse(
        urlString.startsWith('http') ? urlString : 'https://$urlString');
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<PortfolioProvider>(context).theme;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => _launch(widget.item.url),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: EdgeInsets.all(widget.padding),
          decoration: BoxDecoration(
            color: _isHovered
                ? theme.primaryColor.withValues(alpha: 0.25)
                : theme.surfaceColor,
            shape: BoxShape.circle,
            border: Border.all(
              color: _isHovered
                  ? theme.primaryColor
                  : theme.primaryColor.withValues(alpha: 0.2),
              width: 1.5,
            ),
            boxShadow: _isHovered
                ? [
                    BoxShadow(
                      color: theme.primaryColor.withValues(alpha: 0.4),
                      blurRadius: 10,
                      spreadRadius: 1,
                    )
                  ]
                : [],
          ),
          child: Tooltip(
            message: widget.item.label,
            child: Icon(
              widget.item.icon,
              size: widget.iconSize,
              color: _isHovered ? theme.primaryColor : theme.textColor,
            ),
          ),
        ),
      ),
    );
  }
}
