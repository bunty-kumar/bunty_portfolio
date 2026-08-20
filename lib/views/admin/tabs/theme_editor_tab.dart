import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import '../../../providers/portfolio_provider.dart';
import '../../../utils/hex_color.dart';

class ThemeEditorTab extends StatefulWidget {
  const ThemeEditorTab({super.key});

  @override
  State<ThemeEditorTab> createState() => _ThemeEditorTabState();
}

class _ThemeEditorTabState extends State<ThemeEditorTab> {
  void _pickColor(BuildContext context, String title, Color currentColor, Function(Color color) onColorSelected) {
    Color selected = currentColor;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: currentColor,
              onColorChanged: (c) => selected = c,
              pickerAreaHeightPercent: 0.8,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                onColorSelected(selected);
                Navigator.pop(context);
              },
              child: const Text('Apply Color'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PortfolioProvider>(context);
    final theme = provider.theme;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Dynamic Color Theme Customizer',
            style: TextStyle(
              color: theme.textColor,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            'Changes saved here immediately update the portfolio theme in real-time!',
            style: TextStyle(
              color: theme.textColor.withValues(alpha: 0.6),
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 28),

          // Presets Row
          Text(
            'Quick Color Presets',
            style: TextStyle(
              color: theme.textColor,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),

          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _buildPresetCard(
                context,
                title: 'Cyber Violet',
                primary: '#6366F1',
                secondary: '#EC4899',
                bg: '#0B0F17',
              ),
              _buildPresetCard(
                context,
                title: 'Emerald Neon',
                primary: '#10B981',
                secondary: '#3B82F6',
                bg: '#061412',
              ),
              _buildPresetCard(
                context,
                title: 'Sunset Blaze',
                primary: '#F97316',
                secondary: '#EC4899',
                bg: '#140A0F',
              ),
              _buildPresetCard(
                context,
                title: 'Ocean Deep',
                primary: '#0EA5E9',
                secondary: '#6366F1',
                bg: '#07111E',
              ),
            ],
          ),
          const SizedBox(height: 32),

          // Custom Color Tiles
          Text(
            'Customize Color Hex Tokens',
            style: TextStyle(
              color: theme.textColor,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),

          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: [
              _buildColorTile(
                context,
                label: 'Primary Accent Color',
                color: theme.primaryColor,
                hexStr: theme.primaryHex,
                onTap: () => _pickColor(context, 'Primary Accent', theme.primaryColor, (c) {
                  provider.updateTheme(theme.copyWith(primaryHex: HexColor.toHex(c)));
                }),
              ),
              _buildColorTile(
                context,
                label: 'Secondary Glow Color',
                color: theme.secondaryColor,
                hexStr: theme.secondaryHex,
                onTap: () => _pickColor(context, 'Secondary Glow', theme.secondaryColor, (c) {
                  provider.updateTheme(theme.copyWith(secondaryHex: HexColor.toHex(c)));
                }),
              ),
              _buildColorTile(
                context,
                label: 'Background Canvas',
                color: theme.bgColor,
                hexStr: theme.bgHex,
                onTap: () => _pickColor(context, 'Background Canvas', theme.bgColor, (c) {
                  provider.updateTheme(theme.copyWith(bgHex: HexColor.toHex(c)));
                }),
              ),
              _buildColorTile(
                context,
                label: 'Surface & Header',
                color: theme.surfaceColor,
                hexStr: theme.surfaceHex,
                onTap: () => _pickColor(context, 'Surface', theme.surfaceColor, (c) {
                  provider.updateTheme(theme.copyWith(surfaceHex: HexColor.toHex(c)));
                }),
              ),
              _buildColorTile(
                context,
                label: 'Card Glass Tint',
                color: theme.cardColor,
                hexStr: theme.cardHex,
                onTap: () => _pickColor(context, 'Card Tint', theme.cardColor, (c) {
                  provider.updateTheme(theme.copyWith(cardHex: HexColor.toHex(c)));
                }),
              ),
              _buildColorTile(
                context,
                label: 'Main Text Color',
                color: theme.textColor,
                hexStr: theme.textHex,
                onTap: () => _pickColor(context, 'Text Color', theme.textColor, (c) {
                  provider.updateTheme(theme.copyWith(textHex: HexColor.toHex(c)));
                }),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPresetCard(
    BuildContext context, {
    required String title,
    required String primary,
    required String secondary,
    required String bg,
  }) {
    final provider = Provider.of<PortfolioProvider>(context, listen: false);
    final theme = provider.theme;

    return InkWell(
      onTap: () {
        provider.updateTheme(
          theme.copyWith(
            primaryHex: primary,
            secondaryHex: secondary,
            bgHex: bg,
            surfaceHex: HexColor.toHex(HexColor.fromHex(bg).withValues(alpha: 0.9)),
          ),
        );
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: theme.primaryColor.withValues(alpha: 0.2)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 18,
              height: 18,
              decoration: BoxDecoration(
                color: HexColor.fromHex(primary),
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 6),
            Container(
              width: 18,
              height: 18,
              decoration: BoxDecoration(
                color: HexColor.fromHex(secondary),
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              title,
              style: TextStyle(
                color: theme.textColor,
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildColorTile(
    BuildContext context, {
    required String label,
    required Color color,
    required String hexStr,
    required VoidCallback onTap,
  }) {
    final theme = Provider.of<PortfolioProvider>(context).theme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: 220,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: theme.primaryColor.withValues(alpha: 0.2)),
        ),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(color: color.withValues(alpha: 0.4), blurRadius: 8),
                ],
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: theme.textColor.withValues(alpha: 0.7),
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    hexStr,
                    style: TextStyle(
                      color: theme.textColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
