import firebase_admin
from firebase_admin import credentials
from firebase_admin import firestore

# Initialize Firebase App
cred = credentials.Certificate("./slugnutrition-firebase-adminsdk-6m3ya-aa2dd8290f.json")
firebase_admin.initialize_app(cred)

# Get Firestore client
db = firestore.client()

from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC

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
    vegan_dishes = []  # Initialize list to store vegan dishes for the current dining hall
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

        # Find all vegan markers
        vegan_markers = driver.find_elements(By.XPATH, "//img[@src='LegendImages/vegan.gif']")

        # Process each vegan item
        for marker in vegan_markers:
            # Get the parent element and then find the dish name within that element
            parent_element = marker.find_element(By.XPATH, "../..")  # Adjust according to the actual structure
            dish_name = parent_element.find_element(By.CLASS_NAME, "longmenucoldispname").text
            print(f"Vegan dish found: {dish_name}")
            vegan_dishes.append(dish_name)  # Add dish name to the list of vegan dishes

            # Additional logic to interact with the dish (e.g., clicking checkboxes)
            # ...

        # After collecting all vegan dishes for the dining hall, upload to Firestore
        hall_doc_id = hall.replace('/', '').replace(' ', '')  # Simplify hall name to use as document ID
        db.collection('Dining Hall Data').document(hall_doc_id).set({
            'vegan_dishes': vegan_dishes
        })

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
