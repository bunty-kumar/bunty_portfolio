import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/portfolio_provider.dart';
import '../../../utils/responsive_builder.dart';

class AboutSection extends StatelessWidget {
  const AboutSection({super.key});

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
          // Section Title
          _buildSectionHeader(
            context,
            subtitle: "MY STORY & BACKGROUND",
            title: "About Me",
          ),
          const SizedBox(height: 48),

          ResponsiveBuilder(
            mobile: Column(
              children: [
                _buildBioCard(context),
                const SizedBox(height: 32),
                _buildStatsGrid(context, isMobile: true),
              ],
            ),
            desktop: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 6,
                  child: _buildBioCard(context),
                ),
                const SizedBox(width: 48),
                Expanded(
                  flex: 5,
                  child: _buildStatsGrid(context, isMobile: false),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(
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

  Widget _buildBioCard(BuildContext context) {
    final provider = Provider.of<PortfolioProvider>(context);
    final theme = provider.theme;
    final about = provider.about;

    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: theme.cardColor.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: theme.primaryColor.withValues(alpha: 0.15),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.person_pin, color: theme.primaryColor, size: 28),
              const SizedBox(width: 12),
              Text(
                'Who I Am',
                style: TextStyle(
                  color: theme.textColor,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            about.story,
            style: TextStyle(
              color: theme.textColor.withValues(alpha: 0.8),
              fontSize: 15,
              height: 1.7,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsGrid(BuildContext context, {required bool isMobile}) {
    final about = Provider.of<PortfolioProvider>(context).about;

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      childAspectRatio: isMobile ? 1.05 : 1.15,
      children: [
        _buildStatCard(
          context,
          value: "${about.yearsExperience}+",
          label: "Years Experience",
          icon: Icons.timeline,
        ),
        _buildStatCard(
          context,
          value: "${about.projectsCompleted}+",
          label: "Projects Completed",
          icon: Icons.rocket_launch,
        ),
        _buildStatCard(
          context,
          value: "${about.happyClients}+",
          label: "Happy Clients",
          icon: Icons.sentiment_very_satisfied,
        ),
        _buildStatCard(
          context,
          value: "${about.awardsCount}+",
          label: "Recognitions & Awards",
          icon: Icons.emoji_events,
        ),
      ],
    );
  }

  Widget _buildStatCard(
    BuildContext context, {
    required String value,
    required String label,
    required IconData icon,
  }) {
    final theme = Provider.of<PortfolioProvider>(context).theme;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            theme.surfaceColor.withValues(alpha: 0.8),
            theme.cardColor.withValues(alpha: 0.9),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.primaryColor.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: theme.secondaryColor, size: 24),
          const SizedBox(height: 4),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              value,
              style: TextStyle(
                color: theme.textColor,
                fontSize: 22,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: theme.textColor.withValues(alpha: 0.7),
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
