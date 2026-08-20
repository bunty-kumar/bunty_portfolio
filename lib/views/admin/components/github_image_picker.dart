import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/portfolio_provider.dart';

class GitHubImagePicker extends StatefulWidget {
  final String initialUrl;
  final String label;
  final Function(String imageUrl) onImageChanged;

  const GitHubImagePicker({
    super.key,
    required this.initialUrl,
    required this.label,
    required this.onImageChanged,
  });

  @override
  State<GitHubImagePicker> createState() => _GitHubImagePickerState();
}

class _GitHubImagePickerState extends State<GitHubImagePicker> {
  late TextEditingController _urlController;

  @override
  void initState() {
    super.initState();
    _urlController = TextEditingController(text: widget.initialUrl);
  }

  @override
  void didUpdateWidget(covariant GitHubImagePicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialUrl != oldWidget.initialUrl && _urlController.text != widget.initialUrl) {
      _urlController.text = widget.initialUrl;
    }
  }

  @override
  void dispose() {
    _urlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<PortfolioProvider>(context).theme;
    final currentText = _urlController.text.trim();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: TextStyle(
            color: theme.textColor,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),

        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Preview Circle/Square
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: theme.surfaceColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: theme.primaryColor.withValues(alpha: 0.3)),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: currentText.isNotEmpty
                    ? (currentText.startsWith('assets/')
                        ? Image.asset(
                            currentText,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => Icon(Icons.image_not_supported, color: theme.primaryColor),
                          )
                        : Image.network(
                            currentText,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => Icon(Icons.image_not_supported, color: theme.primaryColor),
                          ))
                    : Icon(Icons.add_photo_alternate, color: theme.primaryColor.withValues(alpha: 0.6)),
              ),
            ),
            const SizedBox(width: 12),

            // TextField
            Expanded(
              child: TextFormField(
                controller: _urlController,
                style: TextStyle(color: theme.textColor, fontSize: 13),
                onChanged: (val) => widget.onImageChanged(val.trim()),
                decoration: InputDecoration(
                  hintText: 'Paste GitHub Raw URL or assets/images/filename.png',
                  hintStyle: TextStyle(color: theme.textColor.withValues(alpha: 0.4), fontSize: 12),
                  filled: true,
                  fillColor: theme.cardColor,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
