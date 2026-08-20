import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:provider/provider.dart';
import '../../../providers/portfolio_provider.dart';
import '../../../services/cloudinary_service.dart';

class CloudinaryImagePicker extends StatefulWidget {
  final String initialUrl;
  final String label;
  final Function(String imageUrl) onImageUploaded;

  const CloudinaryImagePicker({
    super.key,
    required this.initialUrl,
    required this.label,
    required this.onImageUploaded,
  });

  @override
  State<CloudinaryImagePicker> createState() => _CloudinaryImagePickerState();
}

class _CloudinaryImagePickerState extends State<CloudinaryImagePicker> {
  late TextEditingController _urlController;
  bool _isUploading = false;

  @override
  void initState() {
    super.initState();
    _urlController = TextEditingController(text: widget.initialUrl);
  }

  @override
  void didUpdateWidget(covariant CloudinaryImagePicker oldWidget) {
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

  Future<void> _pickAndUploadImage() async {
    try {
      final List<PlatformFile>? files = await FilePicker.pickFiles(
        type: FileType.image,
      );

      if (files != null && files.isNotEmpty) {
        final PlatformFile file = files.first;
        final Uint8List bytes = await file.readAsBytes();

        setState(() => _isUploading = true);

        final uploadedUrl = await CloudinaryService.uploadImageBytes(
          bytes,
          fileName: file.name,
        );

        if (uploadedUrl != null && mounted) {
          setState(() {
            _isUploading = false;
            _urlController.text = uploadedUrl;
          });
          widget.onImageUploaded(uploadedUrl);

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Image uploaded to Cloudinary successfully!'),
              backgroundColor: Colors.green,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isUploading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Cloudinary notice: $e (You can also paste direct URL below)'),
            backgroundColor: Colors.orangeAccent,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<PortfolioProvider>(context).theme;

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
                child: _urlController.text.isNotEmpty
                    ? Image.network(
                        _urlController.text,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Icon(Icons.image_not_supported, color: theme.primaryColor),
                      )
                    : Icon(Icons.add_a_photo, color: theme.primaryColor.withValues(alpha: 0.6)),
              ),
            ),
            const SizedBox(width: 12),

            // TextField
            Expanded(
              child: TextFormField(
                controller: _urlController,
                style: TextStyle(color: theme.textColor, fontSize: 13),
                onChanged: (val) => widget.onImageUploaded(val.trim()),
                decoration: InputDecoration(
                  hintText: 'Paste Image URL or Upload to Cloudinary',
                  hintStyle: TextStyle(color: theme.textColor.withValues(alpha: 0.4), fontSize: 12),
                  filled: true,
                  fillColor: theme.cardColor,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                ),
              ),
            ),
            const SizedBox(width: 10),

            // Upload Button
            ElevatedButton.icon(
              onPressed: _isUploading ? null : _pickAndUploadImage,
              icon: _isUploading
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                    )
                  : const Icon(Icons.cloud_upload, size: 18),
              label: Text(_isUploading ? 'Uploading...' : 'Cloudinary Upload'),
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
