from marshmallow import Schema, fields, validate
from models import User, Entry


# User Schema
class UserSchema(Schema):
    id = fields.Integer(dump_only=True)
    first_name = fields.Str(required=True, validate=validate.Length(min=1, max=50))
    last_name = fields.Str(required=True, validate=validate.Length(min=1, max=50))
    birth_date = fields.Date(required=True)
    weight = fields.Decimal(
        as_string=True, places=1, required=True, validate=validate.Range(min=0)
    )
    height = fields.Decimal(
        as_string=True, places=1, required=True, validate=validate.Range(min=0)
    )
    gender = fields.Str(required=True, validate=validate.OneOf(["Male", "Female"]))
    activity_level = fields.Str(
        required=True,
        validate=validate.OneOf(
            [
                "Sedentary",
                "Lightly Active",
                "Moderately Active",
                "Very Active",
                "Super Active",
            ]
        ),
    )
    goal = fields.Str(
        required=True, validate=validate.OneOf(["Cut", "Maintain", "Bulk"])
    )
    email = fields.Email(required=True)
    password_hash = fields.Str(load_only=True)


# Entry Schema
class EntrySchema(Schema):
    id = fields.Integer(dump_only=True)
    name = fields.Str(required=True, validate=validate.Length(min=1, max=100))
    calories = fields.Integer(required=True, validate=validate.Range(min=0))
    protein = fields.Integer(required=True, validate=validate.Range(min=0))
    fat = fields.Integer(required=True, validate=validate.Range(min=0))
    carbs = fields.Integer(required=True, validate=validate.Range(min=0))
    serving_size = fields.Str(required=True, validate=validate.Length(min=1, max=25))
    num_servings = fields.Decimal(
        as_string=True, places=3, required=True, validate=validate.Range(min=0)
    )
    time = fields.DateTime(required=True)
    user_id = fields.Integer(required=True)


# Instantiate Schemas
user_schema = UserSchema()
entry_schema = EntrySchema()
