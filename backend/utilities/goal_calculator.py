from datetime import date

class GoalCalculator:

    def calculate_age(self, user) -> int:
        today = date.today()
        return today.year - user.birth_date.year - ((today.month, today.day) < (user.birth_date.month, user.birth_date.day))
    
    def calculate_calorie_goal(self, user) -> int:
        # Calculate BMR
        bmr = 0
        user_age = self.calculate_age(user)
        if user.gender == "Male" {
            bmr = 88.362 + (13.397 * user.weight) + (4.799 * user.height) - (5.677 * user_age)
        } else {
            bmr = 447.593 + (9.247 * user.weight) + (3.098 * user.height) - (4.330 * user_age)
        }

        # Factor in activity level

        # TODO: Factor in goal
