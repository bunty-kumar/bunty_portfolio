import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import '../../../providers/portfolio_provider.dart';
import '../../../utils/responsive_builder.dart';

class HeroSection extends StatelessWidget {
  final VoidCallback onExploreClick;
  final VoidCallback onContactClick;

  const HeroSection({
    super.key,
    required this.onExploreClick,
    required this.onContactClick,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveBuilder.isMobile(context);

    return Container(
      constraints: const BoxConstraints(minHeight: 650),
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 20 : 64,
        vertical: isMobile ? 40 : 60,
      ),
      child: ResponsiveBuilder(
        mobile: Column(
          children: [
            _buildProfilePhoto(context, isMobile: true),
            const SizedBox(height: 32),
            _buildHeroTextContent(context, isMobile: true),
          ],
        ),
        desktop: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: 6,
              child: _buildHeroTextContent(context, isMobile: false),
            ),
            const SizedBox(width: 48),
            Expanded(
              flex: 5,
              child: _buildProfilePhoto(context, isMobile: false),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroTextContent(BuildContext context, {required bool isMobile}) {
    final provider = Provider.of<PortfolioProvider>(context);
    final theme = provider.theme;
    final hero = provider.hero;

    return Column(
      crossAxisAlignment:
          isMobile ? CrossAxisAlignment.center : CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Status Badge
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: theme.primaryColor.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: theme.primaryColor.withValues(alpha: 0.3),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: Colors.greenAccent,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  hero.badgeText,
                  textAlign: isMobile ? TextAlign.center : TextAlign.start,
                  style: TextStyle(
                    color: theme.textColor,
                    fontSize: isMobile ? 12 : 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),

        // Greeting
        Text(
          hero.greeting,
          style: TextStyle(
            color: theme.primaryColor,
            fontSize: isMobile ? 18 : 22,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.1,
          ),
        ),
        const SizedBox(height: 8),

        // Name
        Text(
          hero.name,
          textAlign: isMobile ? TextAlign.center : TextAlign.start,
          style: TextStyle(
            color: theme.textColor,
            fontSize: isMobile ? 36 : 54,
            fontWeight: FontWeight.w900,
            height: 1.1,
          ),
        ),
        const SizedBox(height: 12),

        // Roles Typewriter Animation
        if (hero.roles.isNotEmpty)
          SizedBox(
            height: 38,
            child: Row(
              mainAxisAlignment:
                  isMobile ? MainAxisAlignment.center : MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "I'm a ",
                  style: TextStyle(
                    color: theme.textColor.withValues(alpha: 0.8),
                    fontSize: isMobile ? 18 : 24,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Flexible(
                  child: AnimatedTextKit(
                    repeatForever: true,
                    animatedTexts: hero.roles.map((role) {
                      return TypewriterAnimatedText(
                        role,
                        textStyle: TextStyle(
                          color: theme.secondaryColor,
                          fontSize: isMobile ? 18 : 24,
                          fontWeight: FontWeight.bold,
                        ),
                        speed: const Duration(milliseconds: 90),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
        const SizedBox(height: 20),

        // Bio paragraph
        Text(
          hero.bio,
          textAlign: isMobile ? TextAlign.center : TextAlign.start,
          style: TextStyle(
            color: theme.textColor.withValues(alpha: 0.75),
            fontSize: isMobile ? 14 : 16,
            height: 1.6,
          ),
        ),
        const SizedBox(height: 32),

        // Buttons Row
        Wrap(
          spacing: 16,
          runSpacing: 16,
          alignment: isMobile ? WrapAlignment.center : WrapAlignment.start,
          children: [
            ElevatedButton(
              onPressed: onExploreClick,
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 18,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                elevation: 6,
                shadowColor: theme.primaryColor.withValues(alpha: 0.5),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    hero.primaryCtaText,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(Icons.arrow_forward, size: 18),
                ],
              ),
            ),
            OutlinedButton(
              onPressed: onContactClick,
              style: OutlinedButton.styleFrom(
                foregroundColor: theme.textColor,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 18,
                ),
                side: BorderSide(
                  color: theme.primaryColor.withValues(alpha: 0.5),
                  width: 1.5,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: Text(
                hero.secondaryCtaText,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildProfilePhoto(BuildContext context, {required bool isMobile}) {
    final provider = Provider.of<PortfolioProvider>(context);
    final theme = provider.theme;
    final hero = provider.hero;

    final imageSize = isMobile ? 260.0 : 360.0;
    final imageUrl = hero.profileImageUrl.isNotEmpty ? hero.profileImageUrl : 'assets/images/profile.png';

    return Stack(
      alignment: Alignment.center,
      children: [
        // Outer Glowing Aura Circle
        Container(
          width: imageSize + 20,
          height: imageSize + 20,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: SweepGradient(
              colors: [
                theme.primaryColor,
                theme.secondaryColor,
                theme.primaryColor,
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: theme.primaryColor.withValues(alpha: 0.35),
                blurRadius: 30,
                spreadRadius: 5,
              ),
            ],
          ),
        ),

        // Main Image Frame
        Container(
          width: imageSize,
          height: imageSize,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: theme.bgColor,
            border: Border.all(color: theme.bgColor, width: 4),
          ),
          child: ClipOval(
            child: imageUrl.startsWith('assets/')
                ? Image.asset(
                    imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Image.network(
                      'https://raw.githubusercontent.com/bunty-kumar/bunty_portfolio/main/assets/images/profile.png',
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Icon(Icons.person, size: 80, color: theme.primaryColor),
                    ),
                  )
                : Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Image.asset(
                      'assets/images/profile.png',
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Icon(Icons.person, size: 80, color: theme.primaryColor),
                    ),
                  ),
          ),
        ),
      ],
    );
  }
}
