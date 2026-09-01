from flask import Flask, jsonify

app = Flask(__name__)

@app.route("/weather", methods=["GET"])
def weather():
    return jsonify({
        "city": "Silchar",
        "temperature": 29,
        "condition": "Cloudy"
    })

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000, debug=True)