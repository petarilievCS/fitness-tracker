import os
from flask import Flask
from flask_sqlalchemy import SQLAlchemy
from sqlalchemy.dialects.postgresql import ENUM

app = Flask(__name__)

# Database Configuration
DB_IP = '35.238.16.183'
DB_NAME = 'postgres'
app.config['SQLALCHEMY_DATABASE_URI'] = (
    f"postgresql+psycopg2://{os.getenv('DB_USERNAME')}:{os.getenv('DB_PASSWORD')}@{DB_IP}/{DB_NAME}"
)
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
db = SQLAlchemy(app)

# Enums
gender_enum = ENUM('MALE', 'FEMALE', name='gender', create_type=False)
activity_level_enum = ENUM('Sedentary', 'Lightly Active', 'Moderately Active', 'Very Active', 'Super Active', name='activity_level', create_type=False)
goal_enum = ENUM('Cut', 'Maintain', 'Bulk', name='goal', create_type=False)

# User Model
class User(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    first_name = db.Column(db.String(50), nullable=False)
    last_name = db.Column(db.String(50), nullable=False)
    birth_date = db.Column(db.Date, nullable=False)
    weight = db.Column(db.Numeric(precision=4, scale=1), nullable=False)
    height = db.Column(db.Numeric(precision=4, scale=1), nullable=False)
    gender = db.Column(gender_enum, nullable=False)
    activity_level = db.Column(activity_level_enum, nullable=False)
    goal = db.Column(goal_enum, nullable=False)
    email = db.Column(db.String(100), nullable=False, unique=True)
    password_hash = db.Column(db.Text, nullable=False)

    __table_args__ = (
        db.CheckConstraint('weight >= 0', name='weight_check'),
        db.CheckConstraint('height >= 0', name='height_check'),
        db.CheckConstraint('email ~* \'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$\'', name='email_check'),
    )

# Entry Model
class Entry(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    calories = db.Column(db.Integer, nullable=False)
    protein = db.Column(db.Integer, nullable=False)
    fat = db.Column(db.Integer, nullable=False)
    carbs = db.Column(db.Integer, nullable=False)
    serving_size = db.Column(db.String(25), nullable=False)
    num_servings = db.Column(db.Numeric(precision=4, scale=3), nullable=False)
    time = db.Column(db.DateTime, nullable=False, server_default=db.func.now())
    user_id = db.Column(db.Integer, db.ForeignKey('user.id'), nullable=False)

    __table_args__ = (
        db.CheckConstraint('calories >= 0', name='calories_check'),
        db.CheckConstraint('protein >= 0', name='protein_check'),
        db.CheckConstraint('fat >= 0', name='fat_check'),
        db.CheckConstraint('carbs >= 0', name='carbs_check'),
        db.CheckConstraint('num_servings >= 0', name='num_servings_check'),
    )