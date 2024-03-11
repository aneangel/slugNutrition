import firebase_admin
from firebase_admin import credentials
from firebase_admin import firestore
import re
from selenium import webdriver
from selenium.common.exceptions import NoSuchElementException
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC

# Initialize Firebase Admin SDK
cred = credentials.Certificate('key.json')
firebase_admin.initialize_app(cred)

# Get Firestore client
db = firestore.client()

# Initialize Selenium WebDriver
options = webdriver.ChromeOptions()
driver = webdriver.Chrome(options=options)

# UCSC Nutrition Page URL
url = 'https://nutrition.sa.ucsc.edu/'
driver.get(url)

# List of dining halls to scrape
dining_halls = [
    'College Nine/John R. Lewis Dining Hall',
    'Cowell/Stevenson Dining Hall',
    'Crown/Merrill Dining Hall',
    'Porter/Kresge Dining Hall',
    'Rachel Carson/Oakes Dining Hall',
]

# Meal types to scrape
meal_types = ['Breakfast', 'Lunch', 'Dinner', 'Late Night']

def get_nutritional_facts(driver):
    # Initialize an empty dictionary to store nutritional facts
    nutritional_facts = {}

    # Extract Serving Size and Calories directly from the text
    try:
        # Serving Size
        serving_size_element = driver.find_element(By.XPATH, "//font[contains(text(), 'Serving Size')]/following-sibling::font")
        serving_size = serving_size_element.text if serving_size_element else 'Not found'
        nutritional_facts['Serving Size'] = serving_size

        # Calories
        calories_element = driver.find_element(By.XPATH, "//b[contains(text(), 'Calories')]")
        if calories_element:
            calories = calories_element.text.split('Calories ')[-1].strip()
        else:
            calories = 'Not found'
        nutritional_facts['Calories'] = calories


    except Exception as e:
        print(f"Error extracting Serving Size and Calories: {e}")

    # Extract main nutritional facts
    try:
        nutrient_elements = driver.find_elements(By.XPATH, "//td[font[contains(@size,'4')]]")
        for i in range(0, len(nutrient_elements), 2):
            nutrient_name_element = nutrient_elements[i].find_element(By.XPATH, "./font")
            nutrient_name = nutrient_name_element.text.strip().split('\n')[0]

            # Extract the amount
            amount = nutrient_elements[i].text.split(nutrient_name)[-1].strip()

            # Extract the percentage value
            percentage_element = nutrient_elements[i + 1].find_element(By.XPATH, ".//font")
            percentage = percentage_element.text.strip() + '%' if percentage_element else ''

            nutrient_value = f"{amount} ({percentage})" if percentage else amount

            nutritional_facts[nutrient_name] = nutrient_value
            print(f"{nutrient_name}: {nutrient_value}")

    except Exception as e:
        print(f"Error extracting main nutritional facts: {e}")

    # Extract additional nutritional facts at the bottom
    try:
        additional_nutrients = driver.find_elements(By.XPATH, "//td[contains(@colspan, '4')]//table//tr")
        for nutrient_row in additional_nutrients:
            nutrient_data = nutrient_row.find_elements(By.XPATH, ".//td")
            for data in nutrient_data:
                name_element = data.find_element(By.XPATH, ".//font[contains(@size, '3')]")
                name = name_element.text.strip() if name_element else 'Not found'

                value_element = data.find_element(By.XPATH, ".//font[contains(@size, '3')]/following-sibling::font")
                value = value_element.text.strip() if value_element else 'Not found'

                nutritional_facts[name] = value
                print(f"{name}: {value}")

    except Exception as e:
        print(f"Error extracting additional nutritional facts: {e}")

    return nutritional_facts

def process_items(driver, db, dining_hall, meal_type):
    items_data = []  # Initialize a list to store data for all items in the current meal type

    items = WebDriverWait(driver, 10).until(EC.presence_of_all_elements_located((By.CSS_SELECTOR, "div.longmenucoldispname a")))

    for index in range(len(items)):
        items = WebDriverWait(driver, 10).until(EC.presence_of_all_elements_located((By.CSS_SELECTOR, "div.longmenucoldispname a")))
        item = items[index]
        item_name = item.text.strip()
        print(f"Processing item: {item_name}")

        item.click()
        WebDriverWait(driver, 10).until(EC.presence_of_element_located((By.CSS_SELECTOR, "table")))

        nutritional_facts = get_nutritional_facts(driver)
        print(f"Nutritional facts for {item_name}: {nutritional_facts}")

        # Append item data to the list
        items_data.append({'name': item_name, 'facts': nutritional_facts})

        driver.back()
        WebDriverWait(driver, 10).until(EC.presence_of_all_elements_located((By.CSS_SELECTOR, "div.longmenucoldispname a")))

    # After processing all items, batch upload to Firestore
    for item_data in items_data:
        # print("Entering data sending loop\n")
        # Firestore write logic remains unchanged
        H_doc_ref = db.collection('Nutritional Facts').document(dining_hall.replace('/', '_').replace(' ', '_'))
        meal_type_ref = H_doc_ref.collection(meal_type)
        item_doc_ref = meal_type_ref.document(item_data['name'])
        item_doc_ref.set({
            'name': item_data['name'],
            'attributes': item_data['facts']
        })
        # db.collection('Nutritional Facts').document(dining_hall).collection(meal_type).document(item_data['name']).set(item_data['facts'])

    # Navigate back after processing all items for the current meal type
    driver.back()



# Main scraping logic
for hall in dining_halls:
    driver.get(url)
    print(f"Entering {hall}...")
    WebDriverWait(driver, 10).until(EC.presence_of_all_elements_located((By.CLASS_NAME, "locations")))
    try:
        xpath = f"//a[contains(text(), \"{hall}\")]"
        link = WebDriverWait(driver, 10).until(EC.element_to_be_clickable((By.XPATH, xpath)))
        link.click()

        for meal_type in meal_types:
            print(f"Processing {meal_type} for {hall}")
            try:
                meal_type_xpath = f"//div[@class='shortmenumeals' and contains(text(), '{meal_type}')]"
                meal_type_div = WebDriverWait(driver, 10).until(EC.presence_of_element_located((By.XPATH, meal_type_xpath)))
                nutrition_calculator_link = meal_type_div.find_element(By.XPATH, "../following-sibling::td/span/a[contains(text(), 'Nutrition Calculator')]")
                nutrition_calculator_link.click()

                process_items(driver, db, hall, meal_type)

                # Navigate back to the main page
                driver.get(url)
                WebDriverWait(driver, 10).until(EC.presence_of_all_elements_located((By.CLASS_NAME, "locations")))

                # Explicitly wait for the specific dining hall link to be clickable again
                link = WebDriverWait(driver, 10).until(EC.element_to_be_clickable((By.XPATH, xpath)))
                link.click()

            except Exception as e:
                print(f"Couldn't find/process the Nutrition Calculator for {meal_type} in {hall}: {e}")
                # Navigate back to the dining hall main page in case of an error
                driver.get(url)
                WebDriverWait(driver, 10).until(EC.presence_of_all_elements_located((By.CLASS_NAME, "locations")))
                link = WebDriverWait(driver, 10).until(EC.element_to_be_clickable((By.XPATH, xpath)))
                link.click()

    except Exception as e:
        print(f"An error occurred while processing {hall}: {e}")
        # Navigate back to the main page in case of an error, to continue with the next dining hall
        driver.get(url)

# Close the WebDriver after all dining halls and meal types have been processed
driver.quit()
