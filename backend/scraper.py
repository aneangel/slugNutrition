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
    egg_dishes = []  # Initialize list to store egg dishes for the current dining hall
    vegan_dishes = []  # Initialize list to store vegan dishes for the current dining hall
    fish_dishes = []  # Initialize list to store fish dishes for the current dining hall
    vegetarian_dishes = []  # Initialize list to store vegitarian dishes for the current dining hall
    gluten_dishes = []  # Initialize list to store gluten dishes for the current dining hall
    pork_dishes = []  # Initialize list to store pork dishes for the current dining hall
    milk_dishes = []  # Initialize list to store milk dishes for the current dining hall
    beef_dishes = []  # Initialize list to store beef dishes for the current dining hall
    peanut_dishes = []  # Initialize list to store peanut dishes for the current dining hall
    halal_dishes = []  # Initialize list to store halal dishes for the current dining hall
    soy_dishes = []  # Initialize list to store soy dishes for the current dining hall
    shellfish_dishes = []  # Initialize list to store shellfish dishes for the current dining hall
    treenut_dishes = []  # Initialize list to store treenut dishes for the current dining hall
    sesame_dishes = []  # Initialize list to store sesame dishes for the current dining hall
    alcohol_dishes = []  # Initialize list to store alcohol dishes for the current dining hall
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
        egg_markers = driver.find_elements(By.XPATH, "//img[@src='LegendImages/eggs.gif']")
        vegan_markers = driver.find_elements(By.XPATH, "//img[@src='LegendImages/vegan.gif']")
        fish_markers = driver.find_elements(By.XPATH, "//img[@src='LegendImages/fish.gif']")
        vegetarian_markers = driver.find_elements(By.XPATH, "//img[@src='LegendImages/veggie.gif']")
        gluten_markers = driver.find_elements(By.XPATH, "//img[@src='LegendImages/gluten.gif']")
        pork_markers = driver.find_elements(By.XPATH, "//img[@src='LegendImages/pork.gif']")
        milk_markers = driver.find_elements(By.XPATH, "//img[@src='LegendImages/milk.gif']")
        beef_markers = driver.find_elements(By.XPATH, "//img[@src='LegendImages/beef.gif']")
        peanut_markers = driver.find_elements(By.XPATH, "//img[@src='LegendImages/nuts.gif']")
        halal_markers = driver.find_elements(By.XPATH, "//img[@src='LegendImages/halal.gif']")
        soy_markers = driver.find_elements(By.XPATH, "//img[@src='LegendImages/soy.gif']")
        shellfish_markers = driver.find_elements(By.XPATH, "//img[@src='LegendImages/shellfish.gif']")
        treenut_markers = driver.find_elements(By.XPATH, "//img[@src='LegendImages/treenut.gif']")
        sesame_markers = driver.find_elements(By.XPATH, "//img[@src='LegendImages/sesame.gif']")
        alcohol_markers = driver.find_elements(By.XPATH, "//img[@src='LegendImages/alcohol.gif']")

        #Processing egg dishes
        for marker in egg_markers:
            parent_element = marker.find_element(By.XPATH, "../..")
            dish_name = parent_element.find_element(By.CLASS_NAME, "longmenucoldispname").text
            print(f"Egg dish found: {dish_name}")
            egg_dishes.append(dish_name)

        #Process each vegan item
        for marker in vegan_markers:
            # Get the parent element and then find the dish name within that element
            parent_element = marker.find_element(By.XPATH, "../..")  # Adjust according to the actual structure
            dish_name = parent_element.find_element(By.CLASS_NAME, "longmenucoldispname").text
            print(f"Vegan dish found: {dish_name}")
            vegan_dishes.append(dish_name)  # Add dish name to the list of vegan dishes

            # Additional logic to interact with the dish (e.g., clicking checkboxes)
            # ...
        
        #Processing fish dishes
        for marker in fish_markers:
            parent_element = marker.find_element(By.XPATH, "../..")
            dish_name = parent_element.find_element(By.CLASS_NAME, "longmenucoldispname").text
            print(f"Fish dish found: {dish_name}")
            egg_dishes.append(dish_name)

        # Processing each dietary restriction
        for marker in vegetarian_markers:
            parent_element = marker.find_element(By.XPATH, "../..")
            dish_name = parent_element.find_element(By.CLASS_NAME, "longmenucoldispname").text
            print(f"Vegitarian dish found: {dish_name}")
            egg_dishes.append(dish_name)

        for marker in gluten_markers:
            parent_element = marker.find_element(By.XPATH, "../..")
            dish_name = parent_element.find_element(By.CLASS_NAME, "longmenucoldispname").text
            print(f"Gluten dish found: {dish_name}")
            egg_dishes.append(dish_name)

        for marker in pork_markers:
            parent_element = marker.find_element(By.XPATH, "../..")
            dish_name = parent_element.find_element(By.CLASS_NAME, "longmenucoldispname").text
            print(f"Pork dish found: {dish_name}")
            egg_dishes.append(dish_name)

        for marker in milk_markers:
            parent_element = marker.find_element(By.XPATH, "../..")
            dish_name = parent_element.find_element(By.CLASS_NAME, "longmenucoldispname").text
            print(f"Milk dish found: {dish_name}")
            egg_dishes.append(dish_name)

        for marker in beef_markers:
            parent_element = marker.find_element(By.XPATH, "../..")
            dish_name = parent_element.find_element(By.CLASS_NAME, "longmenucoldispname").text
            print(f"Beef dish found: {dish_name}")
            egg_dishes.append(dish_name)
        
        for marker in peanut_markers:
            parent_element = marker.find_element(By.XPATH, "../..")
            dish_name = parent_element.find_element(By.CLASS_NAME, "longmenucoldispname").text
            print(f"Peanut dish found: {dish_name}")
            egg_dishes.append(dish_name)
        
        for marker in halal_markers:
            parent_element = marker.find_element(By.XPATH, "../..")
            dish_name = parent_element.find_element(By.CLASS_NAME, "longmenucoldispname").text
            print(f"Halal dish found: {dish_name}")
            egg_dishes.append(dish_name)

        for marker in soy_markers:
            parent_element = marker.find_element(By.XPATH, "../..")
            dish_name = parent_element.find_element(By.CLASS_NAME, "longmenucoldispname").text
            print(f"Soy dish found: {dish_name}")
            egg_dishes.append(dish_name)

        for marker in shellfish_markers:
            parent_element = marker.find_element(By.XPATH, "../..")
            dish_name = parent_element.find_element(By.CLASS_NAME, "longmenucoldispname").text
            print(f"Shellfish dish found: {dish_name}")
            egg_dishes.append(dish_name)

        for marker in treenut_markers:
            parent_element = marker.find_element(By.XPATH, "../..")
            dish_name = parent_element.find_element(By.CLASS_NAME, "longmenucoldispname").text
            print(f"Treenut dish found: {dish_name}")
            egg_dishes.append(dish_name)

        for marker in sesame_markers:
            parent_element = marker.find_element(By.XPATH, "../..")
            dish_name = parent_element.find_element(By.CLASS_NAME, "longmenucoldispname").text
            print(f"Sesame dish found: {dish_name}")
            egg_dishes.append(dish_name)

        for marker in alcohol_markers:
            parent_element = marker.find_element(By.XPATH, "../..")
            dish_name = parent_element.find_element(By.CLASS_NAME, "longmenucoldispname").text
            print(f"Alcohol dish found: {dish_name}")
            egg_dishes.append(dish_name)

        print(egg_dishes)
        print(vegan_dishes)
        print(fish_dishes)
        print(vegetarian_dishes)
        print(gluten_dishes)
        print(pork_dishes)
        print(milk_dishes)
        print(beef_dishes)
        # After collecting all vegan dishes for the dining hall, upload to Firestore
        hall_doc_id = hall.replace('/', '').replace(' ', '')  # Simplify hall name to use as document ID
        # db.collection('Dining Hall Data').document(hall_doc_id).set({
        #     'vegan_dishes': vegan_dishes
        # })

        # Firestore upload for all categories
        hall_doc_ref = db.collection('Dining Hall Menus').document(hall_doc_id)  # Consider a more structured collection name
        hall_doc_ref.set({
            'egg_dishes': egg_dishes,
            'vegan_dishes': vegan_dishes,
            'fish_dishes': fish_dishes,
            'vegetarian_dishes': vegetarian_dishes,
            'gluten_dishes': gluten_dishes,
            'pork_dishes': pork_dishes,
            'milk_dishes': milk_dishes,
            'beef_dishes': beef_dishes,
            'peanut_dishes': peanut_dishes,
            'halal_dishes': halal_dishes,
            'soy_dishes': soy_dishes,
            'shellfish_dishes': shellfish_dishes,
            'treenut_dishes': treenut_dishes,
            'sesame_dishes': sesame_dishes,
            'alcohol_dishes': alcohol_dishes
        }, merge=True)  # Using merge=True to update or create without deleting existing fields


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
