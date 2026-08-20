import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;

class CloudinaryService {
  /// Default Cloudinary cloud name and unsigned upload preset if not configured in Admin settings
  static String cloudName = 'demo'; 
  static String uploadPreset = 'docs_upload_example_us_preset';

  /// Updates Cloudinary configuration dynamically from Admin panel settings
  static void configure({required String newCloudName, required String newUploadPreset}) {
    if (newCloudName.trim().isNotEmpty) cloudName = newCloudName.trim();
    if (newUploadPreset.trim().isNotEmpty) uploadPreset = newUploadPreset.trim();
  }

  /// Uploads raw image bytes (Flutter Web compatible) to Cloudinary
  static Future<String?> uploadImageBytes(Uint8List bytes, {String fileName = 'image.png'}) async {
    try {
      final uri = Uri.parse('https://api.cloudinary.com/v1_1/$cloudName/image/upload');
      final request = http.MultipartRequest('POST', uri)
        ..fields['upload_preset'] = uploadPreset
        ..files.add(
          http.MultipartFile.fromBytes(
            'file',
            bytes,
            filename: fileName,
          ),
        );

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['secure_url'] as String?;
      } else {
        // Fallback or log error body
        final data = jsonDecode(response.body);
        throw Exception(data['error']?['message'] ?? 'Failed to upload image to Cloudinary');
      }
    } catch (e) {
      rethrow;
    }
  }

  /// Base64 data URL fallback or direct URL return if already hosted
  static String getOptimizedUrl(String originalUrl, {int width = 800}) {
    if (originalUrl.contains('res.cloudinary.com')) {
      return originalUrl.replaceFirst('/upload/', '/upload/w_$width,c_scale,q_auto,f_auto/');
    }
    return originalUrl;
  }
}
