from flask import Flask, jsonify, request
import requests

app = Flask(__name__)


@app.route("/weather")
def weather():

    latitude = request.args.get("lat")
    longitude = request.args.get("lon")
    if not latitude or not longitude:
        return jsonify({"error": "lat and lon are required"}), 400

    # Weather API
    url = "https://api.open-meteo.com/v1/forecast"

    params = {
        "latitude": latitude,
        "longitude": longitude,
        "current": "temperature_2m,relative_humidity_2m,apparent_temperature,wind_speed_10m,wind_direction_10m",
        "hourly": "temperature_2m,relative_humidity_2m,precipitation_probability",
        "daily": "temperature_2m_max,temperature_2m_min,weather_code,sunrise,sunset",
        "timezone": "auto"
    }

    response = requests.get(url, params=params, timeout=10)
    response.raise_for_status()

    data = response.json()

    # AQI API
    aqi_url = "https://air-quality-api.open-meteo.com/v1/air-quality"

    aqi_params = {
        "latitude": latitude,
        "longitude": longitude,
        "current": "us_aqi",
        "timezone": "auto"
    }

    aqi_response = requests.get(aqi_url, params=aqi_params, timeout=10)
    aqi_response.raise_for_status()

    aqi_data = aqi_response.json()

    # Add AQI data to weather response
    data["air_quality"] = aqi_data

    return jsonify(data)


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000, debug=True)