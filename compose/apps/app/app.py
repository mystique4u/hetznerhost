from flask import Flask

app = Flask(__name__)

@app.route('/')
def home():
    return "Welcome to the Python Web Application!"

@app.route('/hello')
def hello():
    return "Hello from Flask!"

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)