import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/portfolio_provider.dart';
import '../../../models/portfolio_models.dart';
import '../components/github_image_picker.dart';

class ProjectsManagerTab extends StatelessWidget {
  const ProjectsManagerTab({super.key});

  void _showAddEditProjectDialog(BuildContext context, {ProjectModel? project}) {
    final theme = Provider.of<PortfolioProvider>(context, listen: false).theme;

    final titleCtrl = TextEditingController(text: project?.title ?? '');
    final categoryCtrl = TextEditingController(text: project?.category ?? 'Flutter App');
    final descCtrl = TextEditingController(text: project?.description ?? '');
    final tagsCtrl = TextEditingController(text: project?.tags.join(', ') ?? 'Flutter, Firebase');
    final liveUrlCtrl = TextEditingController(text: project?.liveUrl ?? '');
    final githubUrlCtrl = TextEditingController(text: project?.githubUrl ?? '');
    String imageUrl = project?.imageUrl ?? '';
    bool featured = project?.featured ?? false;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              backgroundColor: theme.surfaceColor,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              child: Container(
                constraints: const BoxConstraints(maxWidth: 600),
                padding: const EdgeInsets.all(24),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            project == null ? 'Add New Project' : 'Edit Project',
                            style: TextStyle(
                              color: theme.textColor,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.close, color: theme.textColor),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      GitHubImagePicker(
                        initialUrl: imageUrl,
                        label: 'Project Cover Image (GitHub Raw URL / Asset Path)',
                        onImageChanged: (url) => setState(() => imageUrl = url),
                      ),
                      const SizedBox(height: 16),

                      TextFormField(
                        controller: titleCtrl,
                        style: TextStyle(color: theme.textColor),
                        decoration: _inputDeco(theme, 'Project Title'),
                      ),
                      const SizedBox(height: 12),

                      TextFormField(
                        controller: categoryCtrl,
                        style: TextStyle(color: theme.textColor),
                        decoration: _inputDeco(theme, 'Category (e.g. Flutter App, Web, AI)'),
                      ),
                      const SizedBox(height: 12),

                      TextFormField(
                        controller: descCtrl,
                        maxLines: 3,
                        style: TextStyle(color: theme.textColor),
                        decoration: _inputDeco(theme, 'Project Description'),
                      ),
                      const SizedBox(height: 12),

                      TextFormField(
                        controller: tagsCtrl,
                        style: TextStyle(color: theme.textColor),
                        decoration: _inputDeco(theme, 'Tech Tags (comma separated)'),
                      ),
                      const SizedBox(height: 12),

                      TextFormField(
                        controller: liveUrlCtrl,
                        style: TextStyle(color: theme.textColor),
                        decoration: _inputDeco(theme, 'Live Demo URL'),
                      ),
                      const SizedBox(height: 12),

                      TextFormField(
                        controller: githubUrlCtrl,
                        style: TextStyle(color: theme.textColor),
                        decoration: _inputDeco(theme, 'GitHub Repository URL'),
                      ),
                      const SizedBox(height: 12),

                      SwitchListTile(
                        title: Text('Featured Project', style: TextStyle(color: theme.textColor)),
                        value: featured,
                        activeThumbColor: theme.primaryColor,
                        onChanged: (val) => setState(() => featured = val),
                      ),
                      const SizedBox(height: 20),

                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          onPressed: () {
                            final provider = Provider.of<PortfolioProvider>(context, listen: false);
                            final updated = ProjectModel(
                              id: project?.id ?? '',
                              title: titleCtrl.text.trim(),
                              category: categoryCtrl.text.trim(),
                              description: descCtrl.text.trim(),
                              imageUrl: imageUrl,
                              tags: tagsCtrl.text.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList(),
                              liveUrl: liveUrlCtrl.text.trim(),
                              githubUrl: githubUrlCtrl.text.trim(),
                              featured: featured,
                              order: project?.order ?? 0,
                            );

                            provider.saveProject(updated);
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: theme.primaryColor,
                            foregroundColor: Colors.white,
                          ),
                          child: const Text('Save Project', style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  InputDecoration _inputDeco(ThemeConfigModel theme, String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: theme.textColor.withValues(alpha: 0.6), fontSize: 13),
      filled: true,
      fillColor: theme.cardColor,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PortfolioProvider>(context);
    final theme = provider.theme;
    final projects = provider.projects;
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 650;

    return SingleChildScrollView(
      padding: EdgeInsets.all(isMobile ? 16 : 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Responsive Header
          Wrap(
            spacing: 16,
            runSpacing: 16,
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Projects Manager',
                    style: TextStyle(
                      color: theme.textColor,
                      fontSize: isMobile ? 20 : 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Add, edit, or delete projects with GitHub image URL integration',
                    style: TextStyle(
                      color: theme.textColor.withValues(alpha: 0.6),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              ElevatedButton.icon(
                onPressed: () => _showAddEditProjectDialog(context),
                icon: const Icon(Icons.add, size: 18),
                label: const Text('Add New Project'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: projects.length,
            itemBuilder: (context, index) {
              final p = projects[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: theme.cardColor,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: theme.primaryColor.withValues(alpha: 0.2)),
                ),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: p.imageUrl.startsWith('assets/')
                          ? Image.asset(
                              p.imageUrl,
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) => Container(
                                width: 60,
                                height: 60,
                                color: theme.surfaceColor,
                                child: Icon(Icons.image, color: theme.primaryColor),
                              ),
                            )
                          : Image.network(
                              p.imageUrl,
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) => Container(
                                width: 60,
                                height: 60,
                                color: theme.surfaceColor,
                                child: Icon(Icons.image, color: theme.primaryColor),
                              ),
                            ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Flexible(
                                child: Text(
                                  p.title,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: theme.textColor,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              if (p.featured) ...[
                                const SizedBox(width: 6),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: theme.secondaryColor,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Text(
                                    'Featured',
                                    style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ]
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            p.description,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(color: theme.textColor.withValues(alpha: 0.6), fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.blueAccent, size: 20),
                      onPressed: () => _showAddEditProjectDialog(context, project: p),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.redAccent, size: 20),
                      onPressed: () => provider.deleteProject(p.id),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
