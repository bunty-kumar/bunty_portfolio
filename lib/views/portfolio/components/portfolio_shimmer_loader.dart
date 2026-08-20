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
                // Navbar Skeleton
                Container(
                  height: 75,
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  color: widget.backgroundColor.withValues(alpha: 0.9),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _skeletonBox(width: 160, height: 28, color: shimmerColor),
                      Row(
                        children: List.generate(
                          5,
                          (i) => Padding(
                            padding: const EdgeInsets.only(left: 20),
                            child: _skeletonBox(width: 60, height: 16, color: shimmerColor),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 60),

                // Hero Banner Skeleton
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 60),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _skeletonBox(width: 140, height: 24, borderRadius: 20, color: shimmerColor),
                            const SizedBox(height: 20),
                            _skeletonBox(width: 320, height: 48, color: shimmerColor),
                            const SizedBox(height: 16),
                            _skeletonBox(width: 220, height: 28, color: shimmerColor),
                            const SizedBox(height: 24),
                            _skeletonBox(width: double.infinity, height: 16, color: shimmerColor),
                            const SizedBox(height: 8),
                            _skeletonBox(width: 380, height: 16, color: shimmerColor),
                            const SizedBox(height: 32),
                            Row(
                              children: [
                                _skeletonBox(width: 140, height: 48, borderRadius: 24, color: shimmerColor),
                                const SizedBox(width: 16),
                                _skeletonBox(width: 140, height: 48, borderRadius: 24, color: shimmerColor),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 60),
                      // Circular Profile Photo Skeleton
                      Container(
                        width: 300,
                        height: 300,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: shimmerColor.withValues(alpha: 0.15),
                          border: Border.all(color: shimmerColor, width: 2),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 80),

                // Projects Cards Skeleton Row
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 60),
                  child: Row(
                    children: List.generate(
                      3,
                      (i) => Expanded(
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 12),
                          height: 340,
                          decoration: BoxDecoration(
                            color: shimmerColor.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: shimmerColor.withValues(alpha: 0.2)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _skeletonBox(width: double.infinity, height: 180, borderRadius: 20, color: shimmerColor),
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
