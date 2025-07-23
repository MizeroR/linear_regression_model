from fastapi import FastAPI
from pydantic import BaseModel, Field
from fastapi.middleware.cors import CORSMiddleware
import joblib
import numpy as np

# Load model and scaler
import os

# Use relative paths for model files
model_path = os.path.join(os.path.dirname(__file__), "model", "best_water_usage_model.pkl")
scaler_path = os.path.join(os.path.dirname(__file__), "model", "feature_scaler.pkl")

model = joblib.load(model_path)
scaler = joblib.load(scaler_path)

app = FastAPI(
    title="Water Usage Predictor API",
    description="Predicts yearly water usage based on daily usage and population.",
    version="1.0.0"
)

# Allow CORS for all origins (you can restrict later if needed)
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Define input model using Pydantic
class WaterUsageInput(BaseModel):
    daily_water_usage: float = Field(..., gt=0, lt=1000, description="Average daily water usage per capita in liters (0–1000)")
    population: float = Field(..., gt=1000, lt=2e9, description="Population of the country (1000 to 2 billion)")

# POST endpoint for predictions
@app.post("/predict")
def predict_usage(data: WaterUsageInput):
    features = np.array([[data.daily_water_usage, data.population]])
    scaled = scaler.transform(features)
    prediction = model.predict(scaled)
    return {
        "predicted_yearly_water_usage": float(prediction[0])
    }
