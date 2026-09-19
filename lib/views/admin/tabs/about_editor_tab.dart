import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/portfolio_provider.dart';
import '../../../models/portfolio_models.dart';

class AboutEditorTab extends StatefulWidget {
  const AboutEditorTab({super.key});

  @override
  State<AboutEditorTab> createState() => _AboutEditorTabState();
}

class _AboutEditorTabState extends State<AboutEditorTab> {
  late TextEditingController _storyController;
  late TextEditingController _yearsExpController;
  late TextEditingController _projectsDoneController;
  late TextEditingController _happyClientsController;
  late TextEditingController _awardsController;

  @override
  void initState() {
    super.initState();
    final provider = Provider.of<PortfolioProvider>(context, listen: false);
    final a = provider.about;

    _storyController = TextEditingController(text: a.story);
    _yearsExpController = TextEditingController(text: a.yearsExperience.toString());
    _projectsDoneController = TextEditingController(text: a.projectsCompleted.toString());
    _happyClientsController = TextEditingController(text: a.happyClients.toString());
    _awardsController = TextEditingController(text: a.awardsCount.toString());
  }

  @override
  void dispose() {
    _storyController.dispose();
    _yearsExpController.dispose();
    _projectsDoneController.dispose();
    _happyClientsController.dispose();
    _awardsController.dispose();
    super.dispose();
  }

  Future<void> _saveAbout() async {
    final provider = Provider.of<PortfolioProvider>(context, listen: false);

    final updatedAbout = AboutModel(
      story: _storyController.text.trim(),
      yearsExperience: int.tryParse(_yearsExpController.text.trim()) ?? 5,
      projectsCompleted: int.tryParse(_projectsDoneController.text.trim()) ?? 35,
      happyClients: int.tryParse(_happyClientsController.text.trim()) ?? 28,
      awardsCount: int.tryParse(_awardsController.text.trim()) ?? 8,
    );

    await provider.updateAbout(updatedAbout);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('About Section updated successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<PortfolioProvider>(context).theme;
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 650;

    return SingleChildScrollView(
      padding: EdgeInsets.all(isMobile ? 16 : 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
                    'About Section Content',
                    style: TextStyle(
                      color: theme.textColor,
                      fontSize: isMobile ? 20 : 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Edit about biography paragraph and career statistic counters',
                    style: TextStyle(
                      color: theme.textColor.withValues(alpha: 0.6),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              ElevatedButton.icon(
                onPressed: _saveAbout,
                icon: const Icon(Icons.save, size: 18),
                label: const Text('Save Changes'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Main Story
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: theme.cardColor,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: theme.primaryColor.withValues(alpha: 0.2)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTextField(theme, 'Detailed Biography / Story', _storyController, maxLines: 5),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Stats Counters
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: theme.cardColor,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: theme.primaryColor.withValues(alpha: 0.2)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Impact Statistic Counters',
                  style: TextStyle(
                    color: theme.textColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                _buildPair(
                  isMobile,
                  _buildTextField(theme, 'Years of Experience (Number)', _yearsExpController),
                  _buildTextField(theme, 'Projects Completed (Number)', _projectsDoneController),
                ),
                const SizedBox(height: 16),
                _buildPair(
                  isMobile,
                  _buildTextField(theme, 'Happy Clients (Number)', _happyClientsController),
                  _buildTextField(theme, 'Recognitions & Awards (Number)', _awardsController),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPair(bool isMobile, Widget field1, Widget field2) {
    if (isMobile) {
      return Column(
        children: [
          field1,
          const SizedBox(height: 16),
          field2,
        ],
      );
    }
    return Row(
      children: [
        Expanded(child: field1),
        const SizedBox(width: 16),
        Expanded(child: field2),
      ],
    );
  }

  Widget _buildTextField(ThemeConfigModel theme, String label, TextEditingController controller, {int maxLines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(color: theme.textColor, fontSize: 13, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          style: TextStyle(color: theme.textColor, fontSize: 14),
          decoration: InputDecoration(
            filled: true,
            fillColor: theme.surfaceColor,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
          ),
        ),
      ],
    );
  }
}
