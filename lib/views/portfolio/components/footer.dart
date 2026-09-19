import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/portfolio_provider.dart';
import 'social_links_row.dart';

class Footer extends StatelessWidget {
  final VoidCallback onScrollToTop;

  const Footer({super.key, required this.onScrollToTop});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PortfolioProvider>(context);
    final theme = provider.theme;
    final branding = provider.branding;
    final isMobile = MediaQuery.of(context).size.width < 650;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 20 : 40,
        vertical: 28,
      ),
      decoration: BoxDecoration(
        color: theme.surfaceColor,
        border: Border(
          top: BorderSide(
            color: theme.primaryColor.withValues(alpha: 0.15),
          ),
        ),
      ),
      child: Column(
        children: [
          Wrap(
            spacing: 20,
            runSpacing: 16,
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text(
                '© ${DateTime.now().year} ${branding.siteTitle}. All rights reserved.',
                style: TextStyle(
                  color: theme.textColor.withValues(alpha: 0.6),
                  fontSize: 13,
                ),
              ),

              const SocialLinksRow(iconSize: 18, padding: 10),

              // Back to top floating button
              IconButton(
                onPressed: onScrollToTop,
                tooltip: 'Back to Top',
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: theme.primaryColor.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.arrow_upward,
                    color: theme.primaryColor,
                    size: 18,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
