import re

from datetime import date, datetime
from flask import request, jsonify
from models import app, db, User, Entry
from marshmallow import ValidationError
from schema import user_schema, entry_schema

# Helper methods


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


# Root Route
@app.route("/")
def hello():
    return "Hello"


# Get all users
@app.route("/users", methods=["GET"])
def get_users():
    # Query all users
    users = User.query.all()

    # Serialize user data
    result = user_schema.dump(users, many=True)

    # Return JSON response
    return jsonify(result), 200


# Get a single user
@app.route("/user/<int:id>", methods=["GET"])
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
@app.route("/user/<string:email>", methods=["GET"])
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
@app.route("/user", methods=["POST"])
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


# Get a single entry
@app.route("/entry/<int:id>", methods=["GET"])
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
@app.route("/entries", methods=["GET"])
def get_entries():
    # Get query parameters
    user_id = request.args.get("user_id")
    if user_id != None and not user_id.isdigit():
        return jsonify({"error": "user_id must be an integer"})

    # Validate start_time
    start_time_str = request.args.get("start_time")
    start_time = None
    if start_time_str != None:
        start_time = validate_time(start_time_str)
        if not start_time:
            return jsonify(
                {
                    "error": "Invalid start_time, must be in the format YYYY-MM-DD or YYYY-MM-DDTHH:MM:SS"
                }
            )

    # Validate end_time
    end_time_str = request.args.get("end_time")
    end_time = None
    if end_time_str != None:
        end_time = validate_time(end_time_str)
        if not end_time:
            return jsonify(
                {
                    "error": "Invalid end_time, must be in the format YYYY-MM-DD or YYYY-MM-DDTHH:MM:SS"
                }
            )

    # Sorting parameter
    sort_by = request.args.get("sort_by", "time")
    order = request.args.get("order", "asc")

    # Validate sort by parameter
    if sort_by != "time":
        return jsonify({"error": "Invalid sort_by parameter"}), 400
    if order not in {"asc", "desc"}:
        return jsonify({"error": "Invalid order parameter"}), 400

    query = Entry.query

    # Apply filters
    if user_id:
        query = query.filter_by(user_id=user_id)
    if start_time:
        query = query.filter(Entry.time >= start_time)
    if end_time:
        query = query.filter(Entry.time <= end_time)

    # Apply sorting
    column = getattr(Entry, sort_by)
    if order == "desc":
        query = query.order_by(column.desc())
    else:
        query = query.order_by(column.asc())

    # Query all entries
    entries = query.all()

    # Serialize entry data
    result = entry_schema.dump(entries, many=True)

    # Return JSON response
    return jsonify(result), 200


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


# Authentication Routes

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


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8080, debug=True)
