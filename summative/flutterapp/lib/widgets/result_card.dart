import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';
import '../utils/efficiency_helper.dart';

class ResultCard extends StatelessWidget {
  final String resultMessage;
  final double? predictionValue;

  const ResultCard({
    super.key,
    required this.resultMessage,
    required this.predictionValue,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: AppColors.resultBackground,
        border: Border.all(
          color: EfficiencyHelper.getEfficiencyColor(predictionValue),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Icon(
            EfficiencyHelper.getEfficiencyIcon(predictionValue),
            size: 48,
            color: EfficiencyHelper.getEfficiencyColor(predictionValue),
          ),
          const SizedBox(height: 12),
          const Text(
            "Water Efficiency",
            style: TextStyle(
              fontSize: 16,
              color: AppColors.textMuted,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            resultMessage,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: EfficiencyHelper.getEfficiencyColor(predictionValue),
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            decoration: BoxDecoration(
              color: EfficiencyHelper.getEfficiencyColor(predictionValue)
                  .withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              EfficiencyHelper.getEfficiencyMessage(predictionValue),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: EfficiencyHelper.getEfficiencyColor(predictionValue),
              ),
            ),
          ),
        ],
      ),
    );
  }
}