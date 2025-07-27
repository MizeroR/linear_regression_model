# Water Efficiency Predictor

### Mission & Problem

This project addresses water sustainability by predicting water usage efficiency (L/KWh) based on real-time weather conditions like temperature, humidity, wind speed, and precipitation. The goal is to optimize energy production while minimizing water waste.

---

## API Endpoint

A deployed FastAPI backend is available for making predictions via HTTP POST. The `/predict` endpoint accepts 4 inputs and returns the predicted water efficiency in L/KWh.

🔗 **Swagger UI**: [https://linear-regression-model-tqfq.onrender.com/docs](https://linear-regression-model-tqfq.onrender.com/docs)


### Example Request:

**POST** `/predict`

```json
{
  "temperature": 25.0,
  "humidity": 60.0,
  "wind_speed": 15.0,
  "precipitation": 0.1
}
````

### Example Response:

```json
{
  "predicted_water_efficiency": 1.5247,
  "unit": "L/KWh"
}
```

---

## Mobile App (Flutter)

The Flutter app allows users to:

* Enter temperature, humidity, wind speed, and precipitation.
* Tap "Predict" to call the API.
* View color-coded results with explanation.
* Handle errors or invalid input gracefully.

---

## Demo Video

🎥 **Watch the 5-minute walkthrough here**:
[https://youtu.be/DCRLjwMo29k](https://youtu.be/DCRLjwMo29k)


---

## 🛠️ Running the Mobile App

### Requirements

* Flutter SDK (latest stable version)
* Android Studio or VS Code with Flutter plugin
* Internet connection to call the deployed API

### Steps

1. Clone the repository:

   ```bash
   git clone https://github.com/MizeroR/linear_regression_model.git
   cd summative/flutterapp
   ```

2. Get dependencies:

   ```bash
   flutter pub get
   ```

3. Run the app:

   ```bash
   flutter run
   ```

   > You can run it on an emulator or a physical device.

4. Enter weather values → Tap **Predict** → View prediction result.

---

## 📁 Project Structure

```
summative/
├── API/                 ← FastAPI project (deployed to Render)
│   └── main.py
├── flutterapp/          ← Flutter mobile app
│   └── lib/
│       ├── main.dart
│       └── prediction_page.dart
└── linear-regression/   ← Jupyter notebook model training
```

---

## 📬 Contact

Github username: MizeroR
