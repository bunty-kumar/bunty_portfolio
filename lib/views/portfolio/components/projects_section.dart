import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../providers/portfolio_provider.dart';
import '../../../models/portfolio_models.dart';
import '../../../utils/responsive_builder.dart';

class ProjectsSection extends StatefulWidget {
  const ProjectsSection({super.key});

  @override
  State<ProjectsSection> createState() => _ProjectsSectionState();
}

class _ProjectsSectionState extends State<ProjectsSection> {
  String _selectedCategory = 'All';

  Future<void> _openUrl(String url) async {
    if (url.isEmpty) return;
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PortfolioProvider>(context);
    final theme = provider.theme;
    final projects = provider.projects;
    final isMobile = ResponsiveBuilder.isMobile(context);

    final categories = ['All', ...{for (var p in projects) p.category}];
    final filtered = _selectedCategory == 'All'
        ? projects
        : projects.where((p) => p.category == _selectedCategory).toList();

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 20 : 64,
        vertical: 60,
      ),
      child: Column(
        children: [
          // Header
          _buildHeader(
            context,
            subtitle: "FEATURED PORTFOLIO",
            title: "Recent Projects",
          ),
          const SizedBox(height: 32),

          // Categories Filter
          Wrap(
            spacing: 12,
            runSpacing: 12,
            alignment: WrapAlignment.center,
            children: categories.map((cat) {
              final isSelected = _selectedCategory == cat;
              return ChoiceChip(
                label: Text(cat),
                selected: isSelected,
                selectedColor: theme.primaryColor,
                backgroundColor: theme.surfaceColor,
                labelStyle: TextStyle(
                  color: isSelected ? Colors.white : theme.textColor,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                ),
                onSelected: (selected) {
                  if (selected) {
                    setState(() => _selectedCategory = cat);
                  }
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 40),

          // Projects Grid
          LayoutBuilder(
            builder: (context, constraints) {
              final crossCount = constraints.maxWidth > 1100
                  ? 3
                  : (constraints.maxWidth > 700 ? 2 : 1);

              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossCount,
                  mainAxisExtent: 420,
                  crossAxisSpacing: 24,
                  mainAxisSpacing: 28,
                ),
                itemCount: filtered.length,
                itemBuilder: (context, index) {
                  final project = filtered[index];
                  return _ProjectCard(
                    project: project,
                    onOpenLive: () => _openUrl(project.liveUrl),
                    onOpenGithub: () => _openUrl(project.githubUrl),
                    onTap: () => _showProjectDetailModal(context, project),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }

  void _showProjectDetailModal(BuildContext context, ProjectModel project) {
    final theme = Provider.of<PortfolioProvider>(context, listen: false).theme;

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: theme.surfaceColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 700),
            padding: const EdgeInsets.all(28),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Image
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      project.imageUrl,
                      width: double.infinity,
                      height: 280,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        height: 200,
                        color: theme.cardColor,
                        child: Icon(Icons.image, size: 64, color: theme.primaryColor),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Category & Title
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: theme.primaryColor.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          project.category,
                          style: TextStyle(
                            color: theme.primaryColor,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.close, color: theme.textColor),
                        onPressed: () => Navigator.pop(context),
                      )
                    ],
                  ),
                  const SizedBox(height: 8),

                  Text(
                    project.title,
                    style: TextStyle(
                      color: theme.textColor,
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 12),

                  Text(
                    project.description,
                    style: TextStyle(
                      color: theme.textColor.withValues(alpha: 0.8),
                      fontSize: 15,
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Tags
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: project.tags.map((tag) {
                      return Chip(
                        label: Text(
                          tag,
                          style: TextStyle(color: theme.textColor, fontSize: 12),
                        ),
                        backgroundColor: theme.cardColor,
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 24),

                  // Actions
                  Row(
                    children: [
                      if (project.liveUrl.isNotEmpty)
                        ElevatedButton.icon(
                          onPressed: () => _openUrl(project.liveUrl),
                          icon: const Icon(Icons.launch, size: 16),
                          label: const Text('Live Demo'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: theme.primaryColor,
                            foregroundColor: Colors.white,
                          ),
                        ),
                      const SizedBox(width: 12),
                      if (project.githubUrl.isNotEmpty)
                        OutlinedButton.icon(
                          onPressed: () => _openUrl(project.githubUrl),
                          icon: const Icon(Icons.code, size: 16),
                          label: const Text('Source Code'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: theme.textColor,
                            side: BorderSide(color: theme.primaryColor),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(
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
}

class _ProjectCard extends StatefulWidget {
  final ProjectModel project;
  final VoidCallback onOpenLive;
  final VoidCallback onOpenGithub;
  final VoidCallback onTap;

  const _ProjectCard({
    required this.project,
    required this.onOpenLive,
    required this.onOpenGithub,
    required this.onTap,
  });

  @override
  State<_ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends State<_ProjectCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<PortfolioProvider>(context).theme;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          transform: _isHovered
              ? Matrix4.translationValues(0, -6, 0)
              : Matrix4.identity(),
          decoration: BoxDecoration(
            color: theme.cardColor.withValues(alpha: 0.7),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: _isHovered
                  ? theme.primaryColor
                  : theme.primaryColor.withValues(alpha: 0.15),
              width: _isHovered ? 1.5 : 1.0,
            ),
            boxShadow: [
              BoxShadow(
                color: _isHovered
                    ? theme.primaryColor.withValues(alpha: 0.25)
                    : Colors.black.withValues(alpha: 0.2),
                blurRadius: _isHovered ? 24 : 12,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image container
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                child: Container(
                  height: 190,
                  width: double.infinity,
                  color: theme.surfaceColor,
                  child: Image.network(
                    widget.project.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: theme.surfaceColor,
                      child: Center(
                        child: Icon(
                          Icons.dashboard_customize,
                          size: 48,
                          color: theme.primaryColor.withValues(alpha: 0.5),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // Content Body
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Category Tag
                      Text(
                        widget.project.category.toUpperCase(),
                        style: TextStyle(
                          color: theme.primaryColor,
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.1,
                        ),
                      ),
                      const SizedBox(height: 6),

                      // Title
                      Text(
                        widget.project.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: theme.textColor,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Description
                      Expanded(
                        child: Text(
                          widget.project.description,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: theme.textColor.withValues(alpha: 0.75),
                            fontSize: 13,
                            height: 1.5,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Tags Row & Action Links
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: widget.project.tags.map((t) {
                                  return Container(
                                    margin: const EdgeInsets.only(right: 6),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: theme.surfaceColor,
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      t,
                                      style: TextStyle(
                                        color: theme.textColor.withValues(alpha: 0.8),
                                        fontSize: 10,
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.arrow_forward,
                              color: theme.secondaryColor,
                              size: 18,
                            ),
                            onPressed: widget.onTap,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
