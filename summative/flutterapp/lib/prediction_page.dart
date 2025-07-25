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
        setState(() {
          resultMessage =
              "✅ Predicted Water Efficiency: ${data['predicted_water_efficiency']} ${data['unit']}";
        });
      } else {
        setState(() {
          resultMessage = "❌ Error: ${response.body}";
        });
      }
    } catch (e) {
      setState(() {
        resultMessage = "❌ Failed to connect: $e";
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
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: label,
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter $fieldName';
          }
          final num? val = num.tryParse(value);
          if (val == null) return 'Invalid number';
          return null;
        },
      ),
    );
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
      appBar: AppBar(title: const Text("Water Efficiency Predictor")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              buildTextField("Temperature (°C)", tempController, "temperature"),
              buildTextField("Humidity (%)", humidityController, "humidity"),
              buildTextField("Wind Speed (km/h)", windController, "wind speed"),
              buildTextField(
                "Precipitation (mm)",
                precipController,
                "precipitation",
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: isLoading ? null : predict,
                child: isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Predict"),
              ),
              const SizedBox(height: 30),
              Text(
                resultMessage,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
