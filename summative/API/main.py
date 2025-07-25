from fastapi import FastAPI, HTTPException
from pydantic import BaseModel, Field
from fastapi.middleware.cors import CORSMiddleware
import joblib
import numpy as np

# Load model and scaler once at startup
model = joblib.load('model/water_efficiency_model.pkl')
scaler = joblib.load('model/weather_scaler.pkl')

# FastAPI app
app = FastAPI(title="Water Efficiency Prediction API")

# Add CORS middleware (allow all origins for now)
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Define Pydantic model with types and constraints
class WeatherInput(BaseModel):
    temperature: float = Field(..., ge=-50, le=60, description="Temperature in °C")
    humidity: float = Field(..., ge=0, le=100, description="Humidity in %")
    wind_speed: float = Field(..., ge=0, le=150, description="Wind speed in km/h")
    precipitation: float = Field(..., ge=0, le=500, description="Precipitation in mm")

@app.post("/predict", summary="Predict Water Efficiency")
def predict_water_efficiency(data: WeatherInput):
    try:
        input_data = np.array([[data.temperature, data.humidity, data.wind_speed, data.precipitation]])
        input_scaled = scaler.transform(input_data)
        prediction = model.predict(input_scaled)
        return {
            "predicted_water_efficiency": round(prediction[0], 4),
            "unit": "L/KWh"
        }
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Prediction failed: {str(e)}")
