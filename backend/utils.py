from datetime import date

def calculate_age(birth_date) -> int:
    today = date.today()
    return today.year - birth_date.year - ((today.month, today.day) < (birth_date.month, birth_date.day))

def calculate_bmr(user) -> int:
    user_age = calculate_age(user.birth_date)
    if user.gender == "Male":
        return 88.362 + (13.397 * user.weight) + (4.799 * user.height) - (5.677 * user_age)
    else:
        return 447.593 + (9.247 * user.weight) + (3.098 * user.height) - (4.330 * user_age)
    
def apply_activity_multiplier(BMR, activity_level):
    multipliers = {
        "Sedentary": 1.2,
        "Lightly Active": 1.375,
        "Moderately Active": 1.55,
        "Very Active": 1.725,
        "Super Active": 1.9,
    }
    return BMR * multipliers.get(activity_level, 1)

def adjust_for_goal(calories, goal):
    adjustments = {
        "Cut": -500,
        "Bulk": 250,
        "Maintain": 0
    }
    return calories + adjustments.get(goal, 0)

def calculate_macros(calories, goal):
    # Calculate ratio
    if goal == "Cut":
        ratios = {"protein": 0.3, "carbs": 0.4, "fats": 0.3}
    elif goal == "Bulk":
        ratios = {"protein": 0.2, "carbs": 0.5, "fats": 0.3}
    else:  # Maintain
        ratios = {"protein": 0.25, "carbs": 0.45, "fats": 0.3}

    # Calculate macro goals
    protein = ratios["protein"] * calories / 4
    carbs = ratios["carbs"] * calories / 4
    fats = ratios["fats"] * calories / 9

    return protein, carbs, fats