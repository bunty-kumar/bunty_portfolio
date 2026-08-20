import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/portfolio_provider.dart';
import '../../../models/portfolio_models.dart';
import '../../../services/firebase_service.dart';

class ConfigSettingsTab extends StatefulWidget {
  const ConfigSettingsTab({super.key});

  @override
  State<ConfigSettingsTab> createState() => _ConfigSettingsTabState();
}

class _ConfigSettingsTabState extends State<ConfigSettingsTab> {
  late TextEditingController _cloudNameCtrl;
  late TextEditingController _presetCtrl;

  late TextEditingController _apiKeyCtrl;
  late TextEditingController _authDomainCtrl;
  late TextEditingController _projectIdCtrl;
  late TextEditingController _storageBucketCtrl;
  late TextEditingController _messagingSenderIdCtrl;
  late TextEditingController _appIdCtrl;

  bool _isConnecting = false;

  @override
  void initState() {
    super.initState();
    final provider = Provider.of<PortfolioProvider>(context, listen: false);
    _cloudNameCtrl = TextEditingController(text: provider.cloudinaryCloudName);
    _presetCtrl = TextEditingController(text: provider.cloudinaryUploadPreset);

    _apiKeyCtrl = TextEditingController(text: provider.firebaseApiKey);
    _authDomainCtrl = TextEditingController();
    _projectIdCtrl = TextEditingController(text: provider.firebaseProjectId);
    _storageBucketCtrl = TextEditingController();
    _messagingSenderIdCtrl = TextEditingController();
    _appIdCtrl = TextEditingController(text: provider.firebaseAppId);
  }

  @override
  void dispose() {
    _cloudNameCtrl.dispose();
    _presetCtrl.dispose();
    _apiKeyCtrl.dispose();
    _authDomainCtrl.dispose();
    _projectIdCtrl.dispose();
    _storageBucketCtrl.dispose();
    _messagingSenderIdCtrl.dispose();
    _appIdCtrl.dispose();
    super.dispose();
  }

  Future<void> _saveCloudinary() async {
    final provider = Provider.of<PortfolioProvider>(context, listen: false);
    provider.updateCloudinaryConfig(_cloudNameCtrl.text.trim(), _presetCtrl.text.trim());

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Cloudinary config updated successfully!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  Future<void> _connectFirebase() async {
    setState(() => _isConnecting = true);

    final success = await FirebaseService.initializeCustomFirebase(
      apiKey: _apiKeyCtrl.text.trim(),
      authDomain: _authDomainCtrl.text.trim(),
      projectId: _projectIdCtrl.text.trim(),
      storageBucket: _storageBucketCtrl.text.trim(),
      messagingSenderId: _messagingSenderIdCtrl.text.trim(),
      appId: _appIdCtrl.text.trim(),
    );

    setState(() => _isConnecting = false);

    if (mounted) {
      if (success) {
        final provider = Provider.of<PortfolioProvider>(context, listen: false);
        provider.firebaseApiKey = _apiKeyCtrl.text.trim();
        provider.firebaseProjectId = _projectIdCtrl.text.trim();
        provider.firebaseAppId = _appIdCtrl.text.trim();

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Firebase connected successfully! Firestore real-time sync is ACTIVE.'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Firebase connection failed. Please check your API keys or project ID.'),
            backgroundColor: Colors.orangeAccent,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<PortfolioProvider>(context).theme;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'API Integration & Storage Credentials',
            style: TextStyle(
              color: theme.textColor,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            'Configure your Cloudinary Cloud Name and Firebase Project Keys below',
            style: TextStyle(
              color: theme.textColor.withValues(alpha: 0.6),
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 28),

          // Cloudinary Settings Box
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: theme.cardColor,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: theme.primaryColor.withValues(alpha: 0.2)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.cloud_queue, color: theme.primaryColor, size: 24),
                    const SizedBox(width: 10),
                    Text(
                      '1. Cloudinary Credentials (For Image Uploads)',
                      style: TextStyle(color: theme.textColor, fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _buildInput(theme, 'Cloudinary Cloud Name', _cloudNameCtrl),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildInput(theme, 'Upload Preset (Unsigned)', _presetCtrl),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: _saveCloudinary,
                  icon: const Icon(Icons.check_circle),
                  label: const Text('Save Cloudinary Config'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.primaryColor,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Firebase Settings Box
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: theme.cardColor,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: theme.primaryColor.withValues(alpha: 0.2)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.local_fire_department, color: Colors.orangeAccent, size: 24),
                    const SizedBox(width: 10),
                    Text(
                      '2. Firebase Web SDK Configuration (Firestore & Auth)',
                      style: TextStyle(color: theme.textColor, fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  FirebaseService.isInitialized
                      ? 'Status: Connected to Firebase Firestore & Auth!'
                      : 'Status: Running in local fallback state (Enter keys to connect Firebase)',
                  style: TextStyle(
                    color: FirebaseService.isInitialized ? Colors.greenAccent : Colors.orangeAccent,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),

                Row(
                  children: [
                    Expanded(child: _buildInput(theme, 'API Key', _apiKeyCtrl)),
                    const SizedBox(width: 16),
                    Expanded(child: _buildInput(theme, 'Project ID', _projectIdCtrl)),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(child: _buildInput(theme, 'Auth Domain (Optional)', _authDomainCtrl)),
                    const SizedBox(width: 16),
                    Expanded(child: _buildInput(theme, 'App ID', _appIdCtrl)),
                  ],
                ),
                const SizedBox(height: 20),

                ElevatedButton.icon(
                  onPressed: _isConnecting ? null : _connectFirebase,
                  icon: _isConnecting
                      ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                      : const Icon(Icons.link),
                  label: Text(_isConnecting ? 'Connecting...' : 'Connect to Firebase'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orangeAccent,
                    foregroundColor: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInput(ThemeConfigModel theme, String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(color: theme.textColor, fontSize: 12, fontWeight: FontWeight.w600)),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          style: TextStyle(color: theme.textColor, fontSize: 13),
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
