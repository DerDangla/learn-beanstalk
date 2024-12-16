from flask import Flask, render_template, jsonify

app = Flask(__name__)

# Route for root URL
@app.route('/')
def home():
    return render_template('index.html')

# Route for version endpoint
@app.route('/version')
def version():
    return jsonify(version="1.0.0")

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=5000)
