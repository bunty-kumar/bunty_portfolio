import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/portfolio_provider.dart';
import '../../../models/portfolio_models.dart';
import '../../../utils/hex_color.dart';

class SkillsManagerTab extends StatelessWidget {
  const SkillsManagerTab({super.key});

  void _showAddEditSkillDialog(BuildContext context, {SkillModel? skill}) {
    final theme = Provider.of<PortfolioProvider>(context, listen: false).theme;

    final nameCtrl = TextEditingController(text: skill?.name ?? '');
    final catCtrl = TextEditingController(text: skill?.category ?? 'Mobile & Web');
    final colorHexCtrl = TextEditingController(text: skill?.colorHex ?? '#6366F1');
    double proficiency = (skill?.proficiency ?? 80).toDouble();

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              backgroundColor: theme.surfaceColor,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              child: Container(
                constraints: const BoxConstraints(maxWidth: 450),
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      skill == null ? 'Add Skill' : 'Edit Skill',
                      style: TextStyle(color: theme.textColor, fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),

                    TextFormField(
                      controller: nameCtrl,
                      style: TextStyle(color: theme.textColor),
                      decoration: InputDecoration(
                        labelText: 'Skill Name (e.g. Flutter & Dart)',
                        filled: true,
                        fillColor: theme.cardColor,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                      ),
                    ),
                    const SizedBox(height: 12),

                    TextFormField(
                      controller: catCtrl,
                      style: TextStyle(color: theme.textColor),
                      decoration: InputDecoration(
                        labelText: 'Category (e.g. Mobile, Backend, Design)',
                        filled: true,
                        fillColor: theme.cardColor,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                      ),
                    ),
                    const SizedBox(height: 12),

                    TextFormField(
                      controller: colorHexCtrl,
                      style: TextStyle(color: theme.textColor),
                      decoration: InputDecoration(
                        labelText: 'Hex Color (e.g. #02569B)',
                        filled: true,
                        fillColor: theme.cardColor,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                      ),
                    ),
                    const SizedBox(height: 16),

                    Text(
                      'Proficiency Level: ${proficiency.round()}%',
                      style: TextStyle(color: theme.textColor, fontWeight: FontWeight.bold),
                    ),
                    Slider(
                      value: proficiency,
                      min: 0,
                      max: 100,
                      divisions: 100,
                      activeColor: theme.primaryColor,
                      onChanged: (v) => setState(() => proficiency = v),
                    ),
                    const SizedBox(height: 20),

                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: () {
                          final provider = Provider.of<PortfolioProvider>(context, listen: false);
                          final item = SkillModel(
                            id: skill?.id ?? '',
                            name: nameCtrl.text.trim(),
                            category: catCtrl.text.trim(),
                            proficiency: proficiency.round(),
                            iconName: 'code',
                            colorHex: colorHexCtrl.text.trim(),
                            order: skill?.order ?? 0,
                          );

                          provider.saveSkill(item);
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: theme.primaryColor,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('Save Skill', style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PortfolioProvider>(context);
    final theme = provider.theme;
    final skills = provider.skills;
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
                    'Skills & Expertise Manager',
                    style: TextStyle(
                      color: theme.textColor,
                      fontSize: isMobile ? 20 : 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Manage skill categories, names, and proficiency percentages',
                    style: TextStyle(
                      color: theme.textColor.withValues(alpha: 0.6),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              ElevatedButton.icon(
                onPressed: () => _showAddEditSkillDialog(context),
                icon: const Icon(Icons.add, size: 18),
                label: const Text('Add Skill'),
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
            itemCount: skills.length,
            itemBuilder: (context, index) {
              final s = skills[index];
              final skillColor = HexColor.fromHex(s.colorHex, fallback: theme.primaryColor);

              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: theme.cardColor,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: theme.primaryColor.withValues(alpha: 0.2)),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(color: skillColor, shape: BoxShape.circle),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            s.name,
                            style: TextStyle(color: theme.textColor, fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'Category: ${s.category} • Proficiency: ${s.proficiency}%',
                            style: TextStyle(color: theme.textColor.withValues(alpha: 0.6), fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.blueAccent, size: 20),
                      onPressed: () => _showAddEditSkillDialog(context, skill: s),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.redAccent, size: 20),
                      onPressed: () => provider.deleteSkill(s.id),
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
