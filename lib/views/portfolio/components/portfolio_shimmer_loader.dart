import 'package:flutter/material.dart';

class PortfolioShimmerLoader extends StatefulWidget {
  final Color backgroundColor;
  final Color primaryColor;

  const PortfolioShimmerLoader({
    super.key,
    required this.backgroundColor,
    required this.primaryColor,
  });

  @override
  State<PortfolioShimmerLoader> createState() => _PortfolioShimmerLoaderState();
}

class _PortfolioShimmerLoaderState extends State<PortfolioShimmerLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);

    _opacityAnimation = Tween<double>(begin: 0.25, end: 0.65).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 750;

    return AnimatedBuilder(
      animation: _opacityAnimation,
      builder: (context, child) {
        final shimmerColor = widget.primaryColor.withValues(alpha: _opacityAnimation.value);

        return Scaffold(
          backgroundColor: widget.backgroundColor,
          body: SingleChildScrollView(
            physics: const NeverScrollableScrollPhysics(),
            child: Column(
              children: [
                // 1. Responsive Navbar Skeleton
                Container(
                  height: 75,
                  padding: EdgeInsets.symmetric(horizontal: isMobile ? 20 : 40),
                  color: widget.backgroundColor.withValues(alpha: 0.9),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _skeletonBox(width: isMobile ? 130 : 160, height: 28, color: shimmerColor),
                      if (!isMobile)
                        Row(
                          children: List.generate(
                            4,
                            (i) => Padding(
                              padding: const EdgeInsets.only(left: 16),
                              child: _skeletonBox(width: 55, height: 16, color: shimmerColor),
                            ),
                          ),
                        )
                      else
                        _skeletonBox(width: 36, height: 36, borderRadius: 8, color: shimmerColor),
                    ],
                  ),
                ),
                SizedBox(height: isMobile ? 30 : 60),

                // 2. Responsive Hero Banner Skeleton
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: isMobile ? 20 : 60),
                  child: isMobile
                      ? Column(
                          children: [
                            // Circular Profile Photo
                            Container(
                              width: 180,
                              height: 180,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: shimmerColor.withValues(alpha: 0.15),
                                border: Border.all(color: shimmerColor, width: 2),
                              ),
                            ),
                            const SizedBox(height: 24),
                            _buildHeroTextSkeleton(shimmerColor, isMobile: true),
                          ],
                        )
                      : Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              flex: 6,
                              child: _buildHeroTextSkeleton(shimmerColor, isMobile: false),
                            ),
                            const SizedBox(width: 48),
                            // Circular Profile Photo
                            Container(
                              width: 280,
                              height: 280,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: shimmerColor.withValues(alpha: 0.15),
                                border: Border.all(color: shimmerColor, width: 2),
                              ),
                            ),
                          ],
                        ),
                ),
                SizedBox(height: isMobile ? 40 : 80),

                // 3. Responsive Projects Cards Skeleton
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: isMobile ? 20 : 60),
                  child: isMobile
                      ? _buildProjectCardSkeleton(shimmerColor)
                      : Row(
                          children: List.generate(
                            3,
                            (i) => Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 10),
                                child: _buildProjectCardSkeleton(shimmerColor),
                              ),
                            ),
                          ),
                        ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeroTextSkeleton(Color shimmerColor, {required bool isMobile}) {
    return Column(
      crossAxisAlignment: isMobile ? CrossAxisAlignment.center : CrossAxisAlignment.start,
      children: [
        _skeletonBox(width: 140, height: 24, borderRadius: 20, color: shimmerColor),
        const SizedBox(height: 16),
        _skeletonBox(width: isMobile ? 220 : 320, height: 38, color: shimmerColor),
        const SizedBox(height: 12),
        _skeletonBox(width: isMobile ? 160 : 220, height: 24, color: shimmerColor),
        const SizedBox(height: 20),
        _skeletonBox(width: isMobile ? 280 : 420, height: 14, color: shimmerColor),
        const SizedBox(height: 8),
        _skeletonBox(width: isMobile ? 220 : 340, height: 14, color: shimmerColor),
        const SizedBox(height: 28),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          alignment: isMobile ? WrapAlignment.center : WrapAlignment.start,
          children: [
            _skeletonBox(width: 130, height: 44, borderRadius: 24, color: shimmerColor),
            _skeletonBox(width: 130, height: 44, borderRadius: 24, color: shimmerColor),
          ],
        ),
      ],
    );
  }

  Widget _buildProjectCardSkeleton(Color shimmerColor) {
    return Container(
      height: 300,
      decoration: BoxDecoration(
        color: shimmerColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: shimmerColor.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _skeletonBox(width: double.infinity, height: 150, borderRadius: 20, color: shimmerColor),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _skeletonBox(width: 80, height: 14, color: shimmerColor),
                const SizedBox(height: 10),
                _skeletonBox(width: 180, height: 20, color: shimmerColor),
                const SizedBox(height: 10),
                _skeletonBox(width: double.infinity, height: 12, color: shimmerColor),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _skeletonBox({
    required double width,
    required double height,
    double borderRadius = 8,
    required Color color,
  }) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    );
  }
}
