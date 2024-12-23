from models import app, db, User, Entry
from schema import user_schema, entry_schema
from flask import Flask, request, jsonify
from flask_sqlalchemy import SQLAlchemy
from sqlalchemy import text
from marshmallow import ValidationError
import re

# Root Route
@app.route('/')
def hello():
    return "Hello"

# Get all entries for a user & date 

# Get user by email

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

    # Check if user exists
    if user == None:
        return jsonify({"error": "User not found"}), 404

    # Serialize user data
    result = user_schema.dump(user)

    # Return JSON response
    return jsonify(result), 200

# Get user by email
@app.route('/user/<string:email>', methods=['GET'])
def get_user_by_email(email):
    # Check if email is valid
    if not re.match(r"[^@]+@[^@]+\.[^@]+", email):
        return jsonify({"error": "Invalid email"}), 400

    # Query user by email
    user = User.query.filter_by(email=email).first()

    # Check if user exists
    if user == None:
        return jsonify({"error": "User not found"}), 404
    
    # Serialize data
    result = user_schema.dump(user)

    # Return JSON response
    return jsonify(result), 200

# Create a new user 
@app.route('/user', methods=['POST'])
def create_user():
    try:
        # Parse and validate data
        data = request.get_json()
        user_data = user_schema.load(data)

        # Check if email exists
        if User.query.filter_by(email=user_data['email']).first() != None:
            return jsonify({"error": "Email already exists"}), 400

        # Create new user
        new_user = User(
            first_name=user_data['first_name'],
            last_name=user_data['last_name'],
            birth_date=user_data['birth_date'],
            weight=user_data['weight'],
            height=user_data['height'],
            gender=user_data['gender'],
            activity_level=user_data['activity_level'],
            goal=user_data['goal'],
            email=user_data['email'],
            password_hash=user_data['password_hash']
        )

        # Add user to database
        db.session.add(new_user)
        db.session.commit()

        return jsonify(user_schema.dump(new_user)), 201
    except ValidationError as e:
        return jsonify({"error": e.messages}), 400
    except Exception as e:
        return jsonify({"error": "Internal server error"}), 500

# Delete a user
@app.route('/user/<int:id>', methods=['DELETE'])
def delete_user(id):
    # Query user by id
    user = User.query.get(id)

    # Check if user exists
    if user == None:
        return jsonify({"error": "User not found"}), 404

    # Delete user
    db.session.delete(user)
    db.session.commit()

    return jsonify({"message": "User deleted"}), 200

# Get a single entry
@app.route('/entry/<int:id>', methods=['GET'])
def get_entry(id):
    # Query entry by id
    entry = Entry.query.get(id)

    # Check if entry exists
    if entry == None:
        return jsonify({"error": "Entry not found"}), 404

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


# Create a new entry 
@app.route('/entry', methods=['POST'])
def create_entry():
    try:
        # Parse and validate data
        data = request.get_json()
        entry_data = entry_schema.load(data)

        # Check if user exists
        if User.query.get(entry_data['user_id']) == None:
            return jsonify({"error": "User not found"}), 404

        # Create new entry
        new_entry = Entry(
            user_id=entry_data['user_id'],
            calories=entry_data['calories'],
            protein=entry_data['protein'],
            fat=entry_data['fat'],
            carbs=entry_data['carbs'],
            serving_size=entry_data['serving_size'],
            num_servings=entry_data['num_servings'],
            time=entry_data['time']
        )

        # Add entry to database
        db.session.add(new_entry)
        db.session.commit()

        return jsonify(entry_schema.dump(new_entry)), 201
    except ValidationError as e:
        return jsonify({"error": e.messages}), 400
    except Exception as e:
        print(str(e))
        return jsonify({"error": "Internal server error"}), 500

# Update an entry 
@app.route('/entry/<int:id>', methods=['PUT'])
def update_entry(id):
    # Query entry by id
    entry = Entry.query.get(id)
    if entry == None:
        return jsonify({"error": "Entry not found"}), 404
    
    try:
        # Serialize data
        entry_data = entry_schema.load(request.get_json(), partial=True)

        # TODO: Ensure user_id is not changed

        # Update attributes
        for key, value in entry_data.items():
            setattr(entry, key, value)

        db.session.commit()
        return jsonify(entry_schema.dump(entry)), 200
    except ValidationError as e:
        return jsonify({"error": e.messages}), 400
    except Exception as e:
        return jsonify({"error": "Internal server error"}), 500

# Delete an entry
@app.route('/entry/<int:id>', methods=['DELETE'])
def delete_entry(id):
    # Query entry by id
    entry = Entry.query.get(id)
    
    # Check if entry exists
    if entry == None:
        return jsonify({"error": "Entry not found"}), 404

    # Delete entry
    db.session.delete(entry)
    db.session.commit()

    return jsonify({"message": "Entry deleted"}), 200

if __name__ == "__main__":
    app.run(debug=True)

