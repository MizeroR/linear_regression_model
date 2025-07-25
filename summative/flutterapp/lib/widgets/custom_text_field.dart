import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final String fieldName;
  final IconData icon;

  const CustomTextField({
    super.key,
    required this.label,
    required this.controller,
    required this.fieldName,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: TextFormField(
          controller: controller,
          keyboardType: TextInputType.number,
          style: const TextStyle(color: Colors.black87),
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: AppColors.accent),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            hintText: label,
            hintStyle: const TextStyle(color: AppColors.textHint),
            filled: true,
            fillColor: AppColors.inputBackground,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter $fieldName';
            }
            final num? val = num.tryParse(value);
            if (val == null) return 'Invalid number';
            
            // Range validation
            if (fieldName == 'temperature' && (val < -50 || val > 60)) {
              return 'Temperature must be between -50°C and 60°C';
            }
            if (fieldName == 'humidity' && (val < 0 || val > 100)) {
              return 'Humidity must be between 0% and 100%';
            }
            if (fieldName == 'wind speed' && (val < 0 || val > 150)) {
              return 'Wind speed must be between 0 and 150 km/h';
            }
            if (fieldName == 'precipitation' && (val < 0 || val > 500)) {
              return 'Precipitation must be between 0 and 500 mm';
            }
            return null;
          },
        ),
      ),
    );
  }
}