import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PredictionPage extends StatefulWidget {
  const PredictionPage({super.key});

  @override
  State<PredictionPage> createState() => _PredictionPageState();
}

class _PredictionPageState extends State<PredictionPage> {
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

  Widget buildTextField(
    String label,
    TextEditingController controller,
    String fieldName,
    IconData icon,
  ) {
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
            prefixIcon: Icon(icon, color: const Color(0xFF4FD1C7)),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            hintText: label,
            hintStyle: const TextStyle(color: Color(0xFF95A1A1)),
            filled: true,
            fillColor: const Color(0xFFF7FAFC),
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

  Color _getEfficiencyColor(double? value) {
    if (value == null) return const Color(0xFF606868);
    if (value >= 1.65) return Colors.green[800]!;
    if (value >= 1.55) return Colors.orange[800]!;
    return Colors.red[800]!;
  }

  String _getEfficiencyMessage(double? value) {
    if (value == null) return '';
    if (value >= 1.65) return 'Excellent water efficiency! Optimal conditions.';
    if (value >= 1.55) return 'Good efficiency. Room for improvement.';
    return 'Low efficiency. Consider optimizing conditions.';
  }

  IconData _getEfficiencyIcon(double? value) {
    if (value == null) return Icons.help_outline;
    if (value >= 1.65) return Icons.eco;
    if (value >= 1.55) return Icons.warning_amber;
    return Icons.error_outline;
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
      backgroundColor: const Color(0xFF1A1D1F),
      appBar: AppBar(
        title: const Text("Water Efficiency Predictor"),
        backgroundColor: const Color(0xFF1A1D1F),
        foregroundColor: const Color(0xFFE8F4F8),
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF1A1D1F), Color(0xFF242A2E)],
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
                      colors: [Color(0xFF4A5568), Color(0xFF2D3748)],
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
                        Icon(
                          Icons.water_drop,
                          size: 48,
                          color: const Color(0xFF81E6D9),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          "Enter Weather Conditions",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFFF7FAFC),
                          ),
                        ),
                        const SizedBox(height: 20),
                        buildTextField(
                          "Temperature (°C) [-50 to 60]",
                          tempController,
                          "temperature",
                          Icons.thermostat,
                        ),
                        buildTextField(
                          "Humidity (%) [0 to 100]",
                          humidityController,
                          "humidity",
                          Icons.opacity,
                        ),
                        buildTextField(
                          "Wind Speed (km/h) [0 to 150]",
                          windController,
                          "wind speed",
                          Icons.air,
                        ),
                        buildTextField(
                          "Precipitation (mm) [0 to 500]",
                          precipController,
                          "precipitation",
                          Icons.grain,
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
                      backgroundColor: const Color(0xFF4FD1C7),
                      foregroundColor: const Color(0xFF1A202C),
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
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: const Color(0xFFCBD7D1),
                      border: Border.all(
                        color: _getEfficiencyColor(predictionValue),
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
                          _getEfficiencyIcon(predictionValue),
                          size: 48,
                          color: _getEfficiencyColor(predictionValue),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          "Water Efficiency",
                          style: TextStyle(
                            fontSize: 16,
                            color: const Color(0xFF606868),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          resultMessage,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: _getEfficiencyColor(predictionValue),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: _getEfficiencyColor(
                              predictionValue,
                            ).withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            _getEfficiencyMessage(predictionValue),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: _getEfficiencyColor(predictionValue),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
