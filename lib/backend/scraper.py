import firebase_admin
from firebase_admin import credentials
from firebase_admin import firestore
from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC

from bs4 import BeautifulSoup

# Initialize Firebase App
cred = credentials.Certificate("./key.json")
firebase_admin.initialize_app(cred)

# Get Firestore client
db = firestore.client()

# Initialize Selenium WebDriver
driver = webdriver.Chrome()

# URL of the UCSC nutrition page
url = 'https://nutrition.sa.ucsc.edu/'

# Navigate to the URL
driver.get(url)

# List of dining halls to scrape
dining_halls = ['College Nine/John R. Lewis Dining Hall', 'Cowell/Stevenson Dining Hall',
                'Crown/Merrill Dining Hall', 'Porter/Kresge Dining Hall', 'Rachel Carson/Oakes Dining Hall']

# Loop through each dining hall
for hall in dining_halls:
    try:
        print(f"Entering {hall}...")  # Print message when entering a dining hall

        # Wait for the dining hall links to be loaded
        WebDriverWait(driver, 10).until(EC.presence_of_all_elements_located((By.CLASS_NAME, "locations")))

        # Use XPath to find the link to the dining hall
        xpath = f"//a[contains(text(), '{hall}')]"
        link = WebDriverWait(driver, 10).until(EC.element_to_be_clickable((By.XPATH, xpath)))
        link.click()

        # Wait for the nutrition calculator link to be clickable
        WebDriverWait(driver, 10).until(EC.element_to_be_clickable((By.LINK_TEXT, "Nutrition Calculator")))

        # Click the nutrition calculator link
        driver.find_element(By.LINK_TEXT, "Nutrition Calculator").click()

        # Initialize a dictionary to hold the category and its dishes
        menu = {}

        # Start by finding the <tbody> element that encompasses all categories and dishes
        tbody = driver.find_element(By.TAG_NAME, "tbody")

        # Then, find all rows within this <tbody>
        rows = tbody.find_elements(By.TAG_NAME, "tr")

        current_category = ""  # Variable to keep track of the current category
        for row in rows:
            # Check if the row contains a category
            category_elements = row.find_elements(By.XPATH, ".//div[@class='longmenucolmenucat']")
            if category_elements:
                current_category = category_elements[0].text.strip()
                menu[current_category] = []  # Initialize the category in the dictionary
            else:
                # Since this row doesn't contain a category, check for dishes
                dish_elements = row.find_elements(By.XPATH, ".//div[@class='longmenucoldispname']/a")
                for dish_element in dish_elements:
                    dish_name = dish_element.text.strip()
                    dish_images = []

                    # Find all <img> elements in the same row as the dish
                    img_elements = row.find_elements(By.XPATH, ".//td/img")
                    for img in img_elements:
                        # Extract the image name from the src attribute
                        img_src = img.get_attribute("src")
                        img_name = img_src.split("/")[-1]  # Extract the image file name
                        dish_images.append(img_name)

                    # Add the dish and its images to the current category
                    if current_category:
                        menu[current_category].append({"name": dish_name, "images": dish_images})


        # Initialize a new dictionary to hold the deduplicated menu
        deduplicated_menu = {}

        for category, dishes in menu.items():
            seen = set()  # Temporary set to track seen dish names
            deduplicated_dishes = []
            for dish in dishes:
                if dish['name'] not in seen:
                    seen.add(dish['name'])
                    deduplicated_dishes.append(dish)
            deduplicated_menu[category] = deduplicated_dishes

        # `deduplicated_menu` now contains each category with unique dishes

        for category, dishes in deduplicated_menu.items():
            for dish in dishes:
                # Remove '.gif' from each image name and rename 'images' key to 'attributes'
                dish['attributes'] = [image.replace('.gif', '') for image in dish.pop('images', [])]

        # Now, each dish has an 'attributes' key instead of 'images', with the '.gif' removed from each attribute name.

        print(deduplicated_menu)

        # Simplify the dining hall name to use as the document ID
        hall_doc_id = hall.replace('/', '').replace(' ', '')

        # Reference to the specific document for the dining hall
        hall_doc_ref = db.collection('Dining Hall Menus').document(hall_doc_id)

        # Prepare the data structure for Firestore accepts dictionaries, so you can directly use your
        # deduplicated_menu if it's structured appropriately
        data_to_upload = {
            "categories": deduplicated_menu
            # You can add more fields here if necessary, for example, a timestamp or additional metadata
        }

        # Upload the data to Firestore
        hall_doc_ref.set(data_to_upload)

    except Exception as e:
        print(f"An error occurred while processing {hall}: {e}")
        driver.save_screenshot(f"error_{hall}.png")  # Save a screenshot for debugging
        print("Page Source:", driver.page_source)  # Print page source for review

    finally:
        print(f"Exiting {hall}...")  # Print message when exiting a dining hall
        # Navigate back to the main page for the next dining hall
        driver.get(url)

# Close the WebDriver
driver.quit()
