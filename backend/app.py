import os
from flask import Flask
from flask_sqlalchemy import SQLAlchemy

app = Flask(__name__)

# Database Configuration
DB_IP = '35.238.16.183'
DB_NAME = 'postgres'
app.config['SQLALCHEMY_DATABASE_URI'] = (
    f"postgresql+psycopg2://{os.getenv('DB_USERNAME')}:{os.getenv('DB_PASSWORD')}@{DB_IP}/{DB_NAME}"
)
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False

db = SQLAlchemy(app)

class User(db.Model)

@app.route('/', methods=['GET'])
def hello():
    return 'Welcome to the Flask API!'

@app.route('/user', methods=['GET'])
def get_user():
    pass

@app.route('/user', methods=['POST'])
def create_user():
    pass

@app.route('/user', methods=['PUT'])
def update_user():
    pass

@app.route('/user', methods=['DELETE'])
def delete_user():
    pass

if __name__ == "__main__":
    app.run(debug=True)

