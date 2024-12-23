from models import app, db, User, Entry
from schema import user_schema, entry_schema
from flask import Flask, jsonify
from flask_sqlalchemy import SQLAlchemy
from sqlalchemy import text

# Root Route
@app.route('/')
def hello():
    return "Hello"

# Get all users
@app.route('/users', methods=['GET'])
def get_users():
    # Query all users
    users = User.query.all()

    # Serialize user data
    result = user_schema.dump(users, many=True)

    # Return JSON response
    return jsonify(result), 200

# Get a single user
@app.route('/user/<int:id>', methods=['GET'])
def get_user(id):
    # Query user by id 
    user = User.query.get(id)

    # Serialize user data
    result = user_schema.dump(user)

    # Return JSON response
    return jsonify(result), 200

# Get a single entry
@app.route('/entry/<int:id>', methods=['GET'])
def get_entry(id):
    # Query entry by id
    entry = Entry.query.get(id)

    # Serialize entry data
    result = entry_schema.dump(entry)

    # Return JSON response
    return jsonify(result), 200

# Get all entries
@app.route('/entries', methods=['GET'])
def get_entries():
    # Query all entries
    entries = Entry.query.all()

    # Serialize entry data
    result = entry_schema.dump(entries, many=True)

    # Return JSON response
    return jsonify(result), 200

if __name__ == "__main__":
    app.run(debug=True)

