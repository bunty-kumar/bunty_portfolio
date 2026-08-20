import 'package:flutter/material.dart';

class HexColor {
  /// Converts a hex color string (e.g. "#6366F1", "6366F1", "FF6366F1") to a Color object.
  static Color fromHex(String hexString, {Color fallback = const Color(0xFF6366F1)}) {
    try {
      final buffer = StringBuffer();
      String cleanHex = hexString.replaceAll('#', '').trim();
      if (cleanHex.length == 6) {
        buffer.write('ff');
        buffer.write(cleanHex);
      } else if (cleanHex.length == 8) {
        buffer.write(cleanHex);
      } else {
        return fallback;
      }
      return Color(int.parse(buffer.toString(), radix: 16));
    } catch (_) {
      return fallback;
    }
  }

  /// Converts a Color object to a hex string (e.g. "#6366F1").
  static String toHex(Color color, {bool leadingHashSign = true, bool includeAlpha = false}) {
    final alpha = (color.a * 255).round().toRadixString(16).padLeft(2, '0');
    final red = (color.r * 255).round().toRadixString(16).padLeft(2, '0');
    final green = (color.g * 255).round().toRadixString(16).padLeft(2, '0');
    final blue = (color.b * 255).round().toRadixString(16).padLeft(2, '0');

    final hex = '${includeAlpha ? alpha : ''}$red$green$blue'.toUpperCase();
    return '${leadingHashSign ? '#' : ''}$hex';
  }
}
