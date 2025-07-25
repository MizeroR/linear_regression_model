import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../core/constants/app_colors.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/result_card.dart';

class PredictionScreen extends StatefulWidget {
  const PredictionScreen({super.key});

  @override
  State<PredictionScreen> createState() => _PredictionScreenState();
}

class _PredictionScreenState extends State<PredictionScreen> {
  final _formKey = GlobalKey<FormState>();

  final tempController = TextEditingController();
  final humidityController = TextEditingController();
  final windController = TextEditingController();
  final precipController = TextEditingController();

  String resultMessage = '';
  double? predictionValue;
  bool isLoading = false;

  Future<void> predict() async {
    if (!_formKey.currentState!.validate()) return;

    final url = Uri.parse(
      'https://linear-regression-model-tqfq.onrender.com/predict',
    );

    setState(() {
      isLoading = true;
      resultMessage = '';
    });

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "temperature": double.parse(tempController.text),
          "humidity": double.parse(humidityController.text),
          "wind_speed": double.parse(windController.text),
          "precipitation": double.parse(precipController.text),
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final efficiency = data['predicted_water_efficiency'];
        setState(() {
          predictionValue = efficiency;
          resultMessage = "${efficiency.toStringAsFixed(2)} ${data['unit']}";
        });
      } else {
        setState(() {
          predictionValue = null;
          resultMessage = "Error: ${response.body}";
        });
      }
    } catch (e) {
      setState(() {
        predictionValue = null;
        resultMessage = "Failed to connect: $e";
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    tempController.dispose();
    humidityController.dispose();
    windController.dispose();
    precipController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryDark,
      appBar: AppBar(
        title: const Text("Water Efficiency Predictor"),
        backgroundColor: AppColors.primaryDark,
        foregroundColor: AppColors.textSecondary,
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.primaryDark, AppColors.secondaryDark],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: const LinearGradient(
                      colors: [AppColors.cardGradientStart, AppColors.cardGradientEnd],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.2),
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        const Icon(
                          Icons.water_drop,
                          size: 48,
                          color: AppColors.accentLight,
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          "Enter Weather Conditions",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 20),
                        CustomTextField(
                          label: "Temperature (°C) [-50 to 60]",
                          controller: tempController,
                          fieldName: "temperature",
                          icon: Icons.thermostat,
                        ),
                        CustomTextField(
                          label: "Humidity (%) [0 to 100]",
                          controller: humidityController,
                          fieldName: "humidity",
                          icon: Icons.opacity,
                        ),
                        CustomTextField(
                          label: "Wind Speed (km/h) [0 to 150]",
                          controller: windController,
                          fieldName: "wind speed",
                          icon: Icons.air,
                        ),
                        CustomTextField(
                          label: "Precipitation (mm) [0 to 500]",
                          controller: precipController,
                          fieldName: "precipitation",
                          icon: Icons.grain,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ElevatedButton(
                    onPressed: isLoading ? null : predict,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.accent,
                      foregroundColor: AppColors.buttonText,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Text(
                            "Predict Water Efficiency",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 24),
                if (resultMessage.isNotEmpty)
                  ResultCard(
                    resultMessage: resultMessage,
                    predictionValue: predictionValue,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}