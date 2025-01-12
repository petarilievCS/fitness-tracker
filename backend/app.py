import re

from datetime import datetime, time, date
from flask import request, jsonify
from models import app, db, User, Entry
from marshmallow import ValidationError
from schema import user_schema, entry_schema
from utils import calculate_bmr, apply_activity_multiplier, adjust_for_goal, calculate_macros


# Validate time format
def validate_time(time_str):
    time = None
    for format in ["%Y-%m-%d", "%Y-%m-%dT%H:%M:%S"]:
        try:
            time = datetime.strptime(time_str, format)
            return time
        except ValueError:
            continue
    if not time:
        return None
    

# Get user
def get_user(id):
    user = User.query.get(id)
    if user == None:
        None
    return user


# Root Route
@app.route("/")
def hello():
    return "Hello"


# Login Route
@app.route('/login', methods=['POST'])
def login():
    # Parse data
    data = request.get_json()
    email = data.get('email')
    password = data.get('password_hash')

    # Validate input
    if email == None or password == None:
        return jsonify({"error": "Please specify email and password"}), 400
    
    # Lookup user
    user = User.query.filter_by(email=email).first()
    if user == None:
        return jsonify({'error': 'User not found'}), 404

    # Authenticate user
    if user.password_hash != password:
        return jsonify({'error': 'Incorrect password'}), 401
    
    return jsonify(user_schema.dump(user)), 200


# Sign Up Route
@app.route("/signup", methods=["POST"])
def create_user():
    try:
        # Parse and validate data
        data = request.get_json()
        user_data = user_schema.load(data)

        # Check if email exists
        if User.query.filter_by(email=user_data["email"]).first() != None:
            return jsonify({"error": "Email already exists"}), 400

        # Create new user
        new_user = User(
            first_name=user_data["first_name"],
            last_name=user_data["last_name"],
            birth_date=user_data["birth_date"],
            weight=user_data["weight"],
            height=user_data["height"],
            gender=user_data["gender"],
            activity_level=user_data["activity_level"],
            goal=user_data["goal"],
            email=user_data["email"],
            password_hash=user_data["password_hash"],
        )

        # Add user to database
        db.session.add(new_user)
        db.session.commit()

        return jsonify(user_schema.dump(new_user)), 201
    except ValidationError as e:
        return jsonify({"error": e.messages}), 400
    except Exception as e:
        return jsonify({"error": "Internal server error"}), 500
    

# Returns goals for a user
@app.route('/goals/<int:user_id>', methods=['GET'])
def goals(user_id):
    # Validate user
    user = get_user(user_id)
    if user == None:
        return jsonify({"error": "User not found"}), 404
    
    # Deserialize data
    user_data = user_schema.dump(user)

    # Calculate calorie goal
    BMR = calculate_bmr(user)
    target_calories = apply_activity_multiplier(BMR, user.activity_level)
    target_calories = adjust_for_goal(target_calories, user.goal)

    # Calculate macors
    target_protein, target_carbs, target_fats = calculate_macros(target_calories, user.goal)

    goals = {
        "calories_goal": int(target_calories),
        "protein_goal": int(target_protein),
        "carbs_goal": int(target_carbs),
        "fats_goal": int(target_fats)
    }
    return jsonify(goals), 200


# Update a user
@app.route("/user/<int:id>", methods=["PUT"])
def update_user(id):
    # Query user by id
    user = User.query.get(id)

    # Check if user exists
    if user == None:
        return jsonify({"error": "User not found"}), 404

    try:
        # Serialize data
        user_data = user_schema.load(request.get_json(), partial=True)

        # Update attributes
        for key, value in user_data.items():
            setattr(user, key, value)

        db.session.commit()
        return jsonify(user_schema.dump(user)), 200
    except ValidationError as e:
        return jsonify({"error": e.messages}), 400
    except Exception as e:
        return jsonify({"error": "Internal server error"}), 500


# Delete a user
@app.route("/user/<int:id>", methods=["DELETE"])
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


# Returns entires and total intake for a user
@app.route('/entries/<int:user_id>', methods=['GET'])
def entries(user_id):
    # Validate user
    user = get_user(user_id)
    if user == None:
        return jsonify({"error": "User not found"}), 404
    
    # Get start and end of today
    today = datetime.now().date()
    start_of_today = datetime.combine(today, time.min)
    end_of_today = datetime.combine(today, time.max)

    # Query entries
    entries_query = Entry.query.filter(
        Entry.user_id == user_id, 
        Entry.time >= start_of_today, 
        Entry.time <= end_of_today
        ).order_by(Entry.time.desc())
    entries = entries_query.all()

    # Create response
    data = {}
    data["entries"] = entry_schema.dump(entries, many=True)
    data["today_calories"] = sum(entry.calories for entry in entries)
    data["today_protein"] = sum(entry.protein for entry in entries)
    data["today_fat"] = sum(entry.fat for entry in entries)
    data["today_carbs"] = sum(entry.carbs for entry in entries)

    return jsonify(data), 200


# Create a new entry
@app.route("/entry", methods=["POST"])
def create_entry():
    try:
        # Parse and validate data
        data = request.get_json()
        entry_data = entry_schema.load(data)

        # Check if user exists
        if User.query.get(entry_data["user_id"]) == None:
            return jsonify({"error": "User not found"}), 404

        # Create new entry
        new_entry = Entry(
            user_id=entry_data["user_id"],
            name=entry_data["name"],
            calories=entry_data["calories"],
            protein=entry_data["protein"],
            fat=entry_data["fat"],
            carbs=entry_data["carbs"],
            serving_size=entry_data["serving_size"],
            num_servings=entry_data["num_servings"],
            time=entry_data["time"],
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
@app.route("/entry/<int:id>", methods=["PUT"])
def update_entry(id):
    # Query entry by id
    entry = Entry.query.get(id)
    if entry == None:
        return jsonify({"error": "Entry not found"}), 404

    try:
        # Serialize data
        entry_data = entry_schema.load(request.get_json(), partial=True)

        # Ensure user_id is not changed
        if "user_id" in entry_data:
            return jsonify({"error": "user_id can not be changed"}), 400

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
@app.route("/entry/<int:id>", methods=["DELETE"])
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
    app.run(host="0.0.0.0", port=8080, debug=True)
