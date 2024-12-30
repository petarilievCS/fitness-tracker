import os

from flask import Flask
from flask_sqlalchemy import SQLAlchemy
from sqlalchemy.dialects.postgresql import ENUM

app = Flask(__name__)

# Database Variables
DB_USER = os.getenv("DB_USER")
DB_PASSWORD = os.getenv("DB_PASSWORD")
DB_NAME = os.getenv("DB_NAME")
DB_HOST = os.getenv("DB_HOST")

# Database Configuration
app.config["SQLALCHEMY_DATABASE_URI"] = (
    f"postgresql+psycopg2://{DB_USER}:{DB_PASSWORD}@{DB_HOST}:5432/{DB_NAME}"
)
app.config["SQLALCHEMY_TRACK_MODIFICATIONS"] = False
db = SQLAlchemy(app)


# Helper Functions
def positive_check(column_name):
    return db.CheckConstraint(f"{column_name} >= 0", name=f"{column_name}_check")


# Enums
gender_enum = ENUM("Male", "Female", name="gender", create_type=False)
activity_level_enum = ENUM(
    "Sedentary",
    "Lightly Active",
    "Moderately Active",
    "Very Active",
    "Super Active",
    name="activity_level",
    create_type=False,
)
goal_enum = ENUM("Cut", "Maintain", "Bulk", name="goal", create_type=False)


# User Model
class User(db.Model):
    __tablename__ = "users"
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
        positive_check("weight"),
        positive_check("height"),
        db.CheckConstraint(
            "email ~* '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$'",
            name="email_check",
        ),
    )


# Entry Model
class Entry(db.Model):
    __tablename__ = "entries"
    id = db.Column(db.Integer, primary_key=True)
    calories = db.Column(db.Integer, nullable=False)
    protein = db.Column(db.Integer, nullable=False)
    fat = db.Column(db.Integer, nullable=False)
    carbs = db.Column(db.Integer, nullable=False)
    serving_size = db.Column(db.String(25), nullable=False)
    num_servings = db.Column(db.Numeric(precision=4, scale=3), nullable=False)
    time = db.Column(db.DateTime, nullable=False, server_default=db.func.now())
    user_id = db.Column(db.Integer, db.ForeignKey("users.id"), nullable=False)

    __table_args__ = (
        positive_check("calories"),
        positive_check("protein"),
        positive_check("fat"),
        positive_check("carbs"),
        db.CheckConstraint("num_servings >= 0", name="num_servings_check"),
    )
