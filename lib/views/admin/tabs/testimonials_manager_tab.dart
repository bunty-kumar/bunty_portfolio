import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/portfolio_provider.dart';
import '../../../models/portfolio_models.dart';
import '../components/github_image_picker.dart';

class TestimonialsManagerTab extends StatefulWidget {
  const TestimonialsManagerTab({super.key});

  @override
  State<TestimonialsManagerTab> createState() => _TestimonialsManagerTabState();
}

class _TestimonialsManagerTabState extends State<TestimonialsManagerTab> {
  void _openDialog([TestimonialModel? item]) {
    final theme = Provider.of<PortfolioProvider>(context, listen: false).theme;

    final nameCtrl = TextEditingController(text: item?.name ?? '');
    final roleCtrl = TextEditingController(text: item?.role ?? '');
    final companyCtrl = TextEditingController(text: item?.company ?? '');
    final avatarCtrl = TextEditingController(text: item?.avatarUrl ?? '');
    final contentCtrl = TextEditingController(text: item?.content ?? '');
    int rating = item?.rating ?? 5;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: theme.surfaceColor,
              title: Text(
                item == null ? 'Add Testimonial' : 'Edit Testimonial',
                style: TextStyle(color: theme.textColor),
              ),
              content: SingleChildScrollView(
                child: SizedBox(
                  width: 500,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _input(theme, 'Client / Reviewer Name', nameCtrl),
                      const SizedBox(height: 12),
                      _input(theme, 'Role (e.g. CEO, Engineering Director)', roleCtrl),
                      const SizedBox(height: 12),
                      _input(theme, 'Company / Organization', companyCtrl),
                      const SizedBox(height: 12),
                      GitHubImagePicker(
                        initialUrl: avatarCtrl.text,
                        label: 'Client Avatar / Photo URL',
                        onImageChanged: (url) => avatarCtrl.text = url,
                      ),
                      const SizedBox(height: 12),
                      _input(theme, 'Testimonial Quote / Content', contentCtrl, maxLines: 4),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Text('Rating: ', style: TextStyle(color: theme.textColor, fontWeight: FontWeight.bold)),
                          DropdownButton<int>(
                            value: rating,
                            dropdownColor: theme.surfaceColor,
                            style: TextStyle(color: theme.textColor),
                            items: [1, 2, 3, 4, 5].map((r) => DropdownMenuItem(value: r, child: Text('$r Stars'))).toList(),
                            onChanged: (val) {
                              if (val != null) setDialogState(() => rating = val);
                            },
                          ),
                        ],
                      ),
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

                    final newTestimonial = TestimonialModel(
                      id: item?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
                      name: nameCtrl.text.trim(),
                      role: roleCtrl.text.trim(),
                      company: companyCtrl.text.trim(),
                      avatarUrl: avatarCtrl.text.trim(),
                      content: contentCtrl.text.trim(),
                      rating: rating,
                      order: item?.order ?? provider.testimonials.length,
                    );

                    final navigator = Navigator.of(context);
                    await provider.saveTestimonial(newTestimonial);
                    navigator.pop();
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: theme.primaryColor, foregroundColor: Colors.white),
                  child: const Text('Save'),
                ),
              ],
            );
          },
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
    final testimonials = provider.testimonials;
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
                    'Client Testimonials & Endorsements',
                    style: TextStyle(color: theme.textColor, fontSize: isMobile ? 20 : 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Manage feedback and reviews from clients and colleagues',
                    style: TextStyle(color: theme.textColor.withValues(alpha: 0.6), fontSize: 12),
                  ),
                ],
              ),
              ElevatedButton.icon(
                onPressed: () => _openDialog(),
                icon: const Icon(Icons.add),
                label: const Text('Add Testimonial'),
                style: ElevatedButton.styleFrom(backgroundColor: theme.primaryColor, foregroundColor: Colors.white),
              ),
            ],
          ),
          const SizedBox(height: 24),

          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: testimonials.length,
            itemBuilder: (context, index) {
              final t = testimonials[index];
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
                    CircleAvatar(
                      backgroundColor: theme.primaryColor.withValues(alpha: 0.2),
                      backgroundImage: t.avatarUrl.startsWith('http') ? NetworkImage(t.avatarUrl) : null,
                      child: !t.avatarUrl.startsWith('http') ? Icon(Icons.person, color: theme.primaryColor) : null,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(t.name, style: TextStyle(color: theme.textColor, fontSize: 16, fontWeight: FontWeight.bold)),
                          Text('${t.role} • ${t.company}', style: TextStyle(color: theme.primaryColor, fontSize: 13, fontWeight: FontWeight.w600)),
                          const SizedBox(height: 4),
                          Text('"${t.content}"', style: TextStyle(color: theme.textColor.withValues(alpha: 0.8), fontSize: 13, fontStyle: FontStyle.italic)),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.blueAccent),
                      onPressed: () => _openDialog(t),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.redAccent),
                      onPressed: () async {
                        await provider.deleteTestimonial(t.id);
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
