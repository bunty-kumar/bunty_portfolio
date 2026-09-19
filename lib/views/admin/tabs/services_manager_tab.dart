import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/portfolio_provider.dart';
import '../../../models/portfolio_models.dart';

class ServicesManagerTab extends StatefulWidget {
  const ServicesManagerTab({super.key});

  @override
  State<ServicesManagerTab> createState() => _ServicesManagerTabState();
}

class _ServicesManagerTabState extends State<ServicesManagerTab> {
  void _openDialog([ServiceModel? item]) {
    final theme = Provider.of<PortfolioProvider>(context, listen: false).theme;

    final titleCtrl = TextEditingController(text: item?.title ?? '');
    final descCtrl = TextEditingController(text: item?.description ?? '');
    final iconCtrl = TextEditingController(text: item?.iconName ?? 'code');

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: theme.surfaceColor,
          title: Text(
            item == null ? 'Add Service' : 'Edit Service',
            style: TextStyle(color: theme.textColor),
          ),
          content: SingleChildScrollView(
            child: SizedBox(
              width: 500,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _input(theme, 'Service Title (e.g. Flutter Mobile Apps)', titleCtrl),
                  const SizedBox(height: 12),
                  _input(theme, 'Service Description', descCtrl, maxLines: 3),
                  const SizedBox(height: 12),
                  _input(theme, 'Icon Name (code, phone, web, cloud, palette, auto_awesome)', iconCtrl),
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

                final newService = ServiceModel(
                  id: item?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
                  title: titleCtrl.text.trim(),
                  description: descCtrl.text.trim(),
                  iconName: iconCtrl.text.trim(),
                  order: item?.order ?? provider.services.length,
                );

                final navigator = Navigator.of(context);
                await provider.saveService(newService);
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
    final services = provider.services;
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
                    'Services Offered',
                    style: TextStyle(color: theme.textColor, fontSize: isMobile ? 20 : 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Manage service cards and offerings for clients',
                    style: TextStyle(color: theme.textColor.withValues(alpha: 0.6), fontSize: 12),
                  ),
                ],
              ),
              ElevatedButton.icon(
                onPressed: () => _openDialog(),
                icon: const Icon(Icons.add),
                label: const Text('Add Service'),
                style: ElevatedButton.styleFrom(backgroundColor: theme.primaryColor, foregroundColor: Colors.white),
              ),
            ],
          ),
          const SizedBox(height: 24),

          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: services.length,
            itemBuilder: (context, index) {
              final s = services[index];
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
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: theme.primaryColor.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(Icons.miscellaneous_services, color: theme.primaryColor),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(s.title, style: TextStyle(color: theme.textColor, fontSize: 16, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 4),
                          Text(s.description, style: TextStyle(color: theme.textColor.withValues(alpha: 0.8), fontSize: 13)),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.blueAccent),
                      onPressed: () => _openDialog(s),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.redAccent),
                      onPressed: () async {
                        await provider.deleteService(s.id);
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
