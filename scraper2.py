from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
import firebase_admin
from firebase_admin import credentials, firestore

# Initialize Firebase Admin SDK
cred = credentials.Certificate('key.json')
firebase_admin.initialize_app(cred)

db = firestore.client()

# Initialize Selenium WebDriver
options = webdriver.ChromeOptions()
driver = webdriver.Chrome(options=options)

# UCSC Nutrition Page URL
url = 'https://nutrition.sa.ucsc.edu/'
driver.get(url)

# List of dining halls and meal types to scrape
dining_halls = [
    'College Nine/John R. Lewis Dining Hall',
    'Cowell/Stevenson Dining Hall',
    'Crown/Merrill Dining Hall',
    'Porter/Kresge Dining Hall',
    'Rachel Carson/Oakes Dining Hall',
    'Oakes Cafe',
    'Global Village Cafe',
]

meal_types = ['Breakfast', 'Lunch', 'Dinner', 'Late Night']
meal_type_xpath_template = "//div[contains(text(), '{}')]"
markers = {
    "Vegan": "vegan.gif",
    "Soy": "soy.gif",
    "Vegetarian": "veggie.gif",
    "Eggs": "eggs.gif",
    "Milk": "milk.gif",
    "Gluten": "gluten.gif",
    "Pork": "pork.gif",
    "Sesame": "sesame.gif",
    "Alcohol": "alcohol.gif",
    "Shellfish": "shellfish.gif",
    "Tree Nut": "treenut.gif",
    "Fish": "fish.gif",
    "Beef": "beef.gif",
    "Halal": "halal.gif",
    "Nuts": "nuts.gif",
}

# Extract dishes and their markers for a single meal section
def extract_dishes_and_markers(meal_section_element, hall, meal_type):
    # Since the actual dishes are located in 'tr' elements following the meal type header,
    # you need to navigate correctly in relation to the provided meal_section_element.

    # First, find the common parent container of the meal type header and the dishes.
    # Assuming each meal section (like Breakfast, Lunch) and its dishes are contained within a single 'table'.
    # Update: Based on the HTML snippet, it seems the dishes follow the 'div' with class 'shortmenucats' directly under 'tr's within the same 'table'.
    # Let's adjust the XPath to reflect this understanding.

    # Navigate from the meal_section_element to the common parent 'table', then find the dishes within.
    dishes = meal_section_element.find_elements(By.XPATH, "./following::tr[.//div[@class='shortmenurecipes']]")

    print(f"Found {len(dishes)} dishes under {meal_type}.")

    for dish in dishes:
        # The dish name is within a div with class 'shortmenurecipes'
        dish_name_div = dish.find_element(By.XPATH, ".//div[@class='shortmenurecipes']")
        dish_name = dish_name_div.text.strip()

        # Identifying markers for the current dish
        dish_markers = []
        marker_images = dish.find_elements(By.XPATH, ".//img")
        for img in marker_images:
            src = img.get_attribute('src')
            for marker_name, marker_filename in markers.items():
                if marker_filename in src:
                    dish_markers.append(marker_name)

        print(f"Dish found: {dish_name} with markers: {', '.join(dish_markers)}")

        # Firestore write logic remains unchanged
        hall_doc_ref = db.collection('dining_halls').document(hall.replace('/', '_').replace(' ', '_'))
        meal_type_ref = hall_doc_ref.collection(meal_type)
        dish_doc_ref = meal_type_ref.document(dish_name.replace(' ', '_'))
        dish_doc_ref.set({
            'name': dish_name,
            'attributes': dish_markers
        })

# Main scraping logic
for hall in dining_halls:
    print(f"Entering {hall}...")
    WebDriverWait(driver, 10).until(EC.presence_of_all_elements_located((By.CLASS_NAME, "locations")))
    try:
        xpath = f"//a[contains(text(), \"{hall}\")]"
        link = WebDriverWait(driver, 10).until(EC.element_to_be_clickable((By.XPATH, xpath)))
        link.click()

        for meal_type in meal_types:
            print(f"Processing {meal_type} for {hall}")
            meal_header_elements = driver.find_elements(By.XPATH, meal_type_xpath_template.format(meal_type))
            if meal_header_elements:
                print(f"Found {len(meal_header_elements)} header(s) for {meal_type}")

            for meal_header_element in meal_header_elements:
                extract_dishes_and_markers(meal_header_element, hall, meal_type)

        driver.get(url)  # Navigate back to the main page for the next dining hall
    except Exception as e:
        print(f"An error occurred while processing {hall}: {e}")

driver.quit()

