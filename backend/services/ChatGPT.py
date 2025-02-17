import base64
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
    

# Convert image to base64
def encode_image(image_path):
    with open(image_path, "rb") as image_file:
        return base64.b64encode(image_file.read()).decode("utf-8")

# Sends an image of a meal to ChatGPT and returns textual description
def classify_image(image_path):
    image_data = encode_image(image_path)

    response = client.chat.completions.create(
        model="gpt-4-turbo",
        messages=[
            {"role": "system", "content": "You are an AI that recognizes objects in Images."},
            {"role": "user", "content": [
                {"type": "text", "text": "Describe the object in this image."},
                {"type": "image_url", "image_url": {"url": image_path}}
            ]}
        ],
        max_tokens=50
    )

    return response["choices"][0]["message"]["content"]
    
# Testing purposes
if __name__ == "__main__":
    while True:
        user_input = input("What is the image file: ")
        print(classify_image(user_input))