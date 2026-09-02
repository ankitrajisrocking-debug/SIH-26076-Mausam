from flask import Flask, jsonify, request
import requests

app = Flask(__name__)


@app.route("/weather")
def weather():

    latitude = request.args.get("lat")
    longitude = request.args.get("lon")

    url = "https://api.open-meteo.com/v1/forecast"

    params = {
        "latitude": latitude,
        "longitude": longitude,
        "current": "temperature_2m,relative_humidity_2m,apparent_temperature,wind_speed_10m,wind_direction_10m",
        "hourly": "temperature_2m,relative_humidity_2m,precipitation_probability",
        "daily": "temperature_2m_max,temperature_2m_min,weather_code,sunrise,sunset",
        "timezone": "auto"
    }

    response = requests.get(url, params=params)

    data = response.json()

    return jsonify(data)


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000, debug=True)