from openai import OpenAI
import os
import json

client = OpenAI(api_key=os.getenv("OPENAI_API_KEY"))

# Sends meal to ChatGPT and returns structured JSON response
def parse_meal(meal_description):
    prompt = f"""
    You are a nutritionist AI that helps parse meals into structured nutritional information.

    Given a description of a meal, return a JSON object representing the meal's estimated nutritional content. The JSON should have the following structure:

    {{
      "name": "Meal name",
      "calories": (integer) total kcal,
      "protein": (integer) total grams of protein,
      "fat": (integer) total grams of fat,
      "carbs": (integer) total grams of carbohydrates,
      "num_servings": (float) number of servings,
      "serving_size": (string) unit of serving size (e.g., "cup", "bowl", "piece", "slice")
    }}

    ### **Guidelines:**
    - The "name" field should be a concise name for the meal.
    - Estimate the nutritional values based on common portion sizes.
    - The "num_servings" should be a decimal, representing the number of servings.
    - The "serving_size" should be a string describing the portion (e.g., "cup", "bowl", "piece").
    - Ensure the response is **valid JSON** with no extra text.

    Now, based on this structure, please parse the following meal description:

    "{meal_description}"
    """

    try:
        response = client.chat.completions.create(
            model="gpt-3.5-turbo",
            messages=[{"role": "user", "content": prompt}]
        )

        parsed_response = json.loads(response.choices[0].message.content)
        return parsed_response
    
    except json.JSONDecodeError:
        print("Error: OpenAI response is not valid JSON.")
        return {"error": "Failed to process meal"}
    except Exception as e:
        print(f"Error parsing meal: {e}")
        return {"error": "Failed to process meal"}
    
# Testing purposes
if __name__ == "__main__":
    while True:
        user_input = input("Describe your meal: ")
        print(parse_meal(user_input))