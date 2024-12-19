from models import app, db, User, Entry
from schema import user_schema, entry_schema
from flask import Flask, jsonify
from flask_sqlalchemy import SQLAlchemy
from sqlalchemy import text

# Root Route
@app.route('/')
def hello():
    return "Hello"

@app.route('/test')
def test():
    users = User.query.all()
    return {user.id: user.first_name for user in users}

@app.route('/users', methods=['GET'])
def get_users():
    # Query all users
    users = User.query.all()

    # Serialize user data
    result = user_schema.dump(users, many=True)

    # Return JSON response
    return jsonify(result), 200


if __name__ == "__main__":
    app.run(debug=True)

