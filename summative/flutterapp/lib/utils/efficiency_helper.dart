import 'package:flutter/material.dart';

class EfficiencyHelper {
  static Color getEfficiencyColor(double? value) {
    if (value == null) return const Color(0xFF606868);
    if (value >= 1.65) return Colors.green[800]!;
    if (value >= 1.55) return Colors.orange[800]!;
    return Colors.red[800]!;
  }

  static String getEfficiencyMessage(double? value) {
    if (value == null) return '';
    if (value >= 1.65) return 'Excellent water efficiency! Optimal conditions.';
    if (value >= 1.55) return 'Good efficiency. Room for improvement.';
    return 'Low efficiency. Consider optimizing conditions.';
  }

  static IconData getEfficiencyIcon(double? value) {
    if (value == null) return Icons.help_outline;
    if (value >= 1.65) return Icons.eco;
    if (value >= 1.55) return Icons.warning_amber;
    return Icons.error_outline;
  }
}