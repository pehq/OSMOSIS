from flask import Flask, request, jsonify
import json

app = Flask(__name__)

@app.route('/process_json', methods=['POST'])
def process_json():
    data = request.get_json()  # Parse the JSON payload
    if not data:
        return jsonify({'status': 'error', 'message': 'No JSON data provided'}), 400

    # Save the JSON data to a .json file
    with open('output.json', 'w') as f:
        json.dump(data, f, indent=4)  # Save the JSON data with indentation for readability

    # Print the data to the console for debugging
    print("Received JSON and saved to output.json:", data)

    return jsonify({'status': 'success', 'message': 'JSON received and saved to output.json'})

if __name__ == '__main__':
    app.run(host='127.0.0.1', port=5000)