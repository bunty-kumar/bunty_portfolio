import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/portfolio_provider.dart';
import '../../../models/portfolio_models.dart';
import '../components/github_image_picker.dart';

class ExperienceManagerTab extends StatefulWidget {
  const ExperienceManagerTab({super.key});

  @override
  State<ExperienceManagerTab> createState() => _ExperienceManagerTabState();
}

class _ExperienceManagerTabState extends State<ExperienceManagerTab> {
  void _openDialog([ExperienceModel? item]) {
    final theme = Provider.of<PortfolioProvider>(context, listen: false).theme;

    final roleCtrl = TextEditingController(text: item?.role ?? '');
    final companyCtrl = TextEditingController(text: item?.company ?? '');
    final logoCtrl = TextEditingController(text: item?.companyLogoUrl ?? '');
    final periodCtrl = TextEditingController(text: item?.period ?? '');
    final descCtrl = TextEditingController(text: item?.description ?? '');
    final bulletsCtrl = TextEditingController(text: item?.bulletPoints.join('\n') ?? '');

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: theme.surfaceColor,
          title: Text(
            item == null ? 'Add Work Experience' : 'Edit Work Experience',
            style: TextStyle(color: theme.textColor),
          ),
          content: SingleChildScrollView(
            child: SizedBox(
              width: 500,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _input(theme, 'Role / Job Title', roleCtrl),
                  const SizedBox(height: 12),
                  _input(theme, 'Company Name', companyCtrl),
                  const SizedBox(height: 12),
                  _input(theme, 'Period (e.g. 2022 - Present)', periodCtrl),
                  const SizedBox(height: 12),
                  GitHubImagePicker(
                    initialUrl: logoCtrl.text,
                    label: 'Company Logo Image URL',
                    onImageChanged: (url) => logoCtrl.text = url,
                  ),
                  const SizedBox(height: 12),
                  _input(theme, 'Role Description', descCtrl, maxLines: 3),
                  const SizedBox(height: 12),
                  _input(theme, 'Key Achievements / Bullet Points (one per line)', bulletsCtrl, maxLines: 3),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel', style: TextStyle(color: theme.textColor.withValues(alpha: 0.7))),
            ),
            ElevatedButton(
              onPressed: () async {
                final provider = Provider.of<PortfolioProvider>(context, listen: false);

                final bullets = bulletsCtrl.text
                    .split('\n')
                    .map((e) => e.trim())
                    .where((e) => e.isNotEmpty)
                    .toList();

                final newExp = ExperienceModel(
                  id: item?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
                  role: roleCtrl.text.trim(),
                  company: companyCtrl.text.trim(),
                  companyLogoUrl: logoCtrl.text.trim(),
                  period: periodCtrl.text.trim(),
                  description: descCtrl.text.trim(),
                  bulletPoints: bullets,
                  order: item?.order ?? provider.experiences.length,
                );

                final navigator = Navigator.of(context);
                await provider.saveExperience(newExp);
                navigator.pop();
              },
              style: ElevatedButton.styleFrom(backgroundColor: theme.primaryColor, foregroundColor: Colors.white),
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  Widget _input(ThemeConfigModel theme, String label, TextEditingController ctrl, {int maxLines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(color: theme.textColor, fontSize: 12, fontWeight: FontWeight.w600)),
        const SizedBox(height: 4),
        TextFormField(
          controller: ctrl,
          maxLines: maxLines,
          style: TextStyle(color: theme.textColor, fontSize: 14),
          decoration: InputDecoration(
            filled: true,
            fillColor: theme.cardColor,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PortfolioProvider>(context);
    final theme = provider.theme;
    final experiences = provider.experiences;
    final isMobile = MediaQuery.of(context).size.width < 650;

    return SingleChildScrollView(
      padding: EdgeInsets.all(isMobile ? 16 : 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Work Experience Timeline',
                    style: TextStyle(color: theme.textColor, fontSize: isMobile ? 20 : 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Add and edit your career history and roles',
                    style: TextStyle(color: theme.textColor.withValues(alpha: 0.6), fontSize: 12),
                  ),
                ],
              ),
              ElevatedButton.icon(
                onPressed: () => _openDialog(),
                icon: const Icon(Icons.add),
                label: const Text('Add Experience'),
                style: ElevatedButton.styleFrom(backgroundColor: theme.primaryColor, foregroundColor: Colors.white),
              ),
            ],
          ),
          const SizedBox(height: 24),

          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: experiences.length,
            itemBuilder: (context, index) {
              final exp = experiences[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: theme.cardColor,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: theme.primaryColor.withValues(alpha: 0.2)),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(exp.role, style: TextStyle(color: theme.textColor, fontSize: 16, fontWeight: FontWeight.bold)),
                          Text('${exp.company} • ${exp.period}', style: TextStyle(color: theme.primaryColor, fontSize: 13, fontWeight: FontWeight.w600)),
                          const SizedBox(height: 6),
                          Text(exp.description, style: TextStyle(color: theme.textColor.withValues(alpha: 0.8), fontSize: 13)),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.blueAccent),
                      onPressed: () => _openDialog(exp),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.redAccent),
                      onPressed: () async {
                        await provider.deleteExperience(exp.id);
                      },
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
