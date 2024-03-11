import firebase_admin
from firebase_admin import credentials
from firebase_admin import firestore
from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from bs4 import BeautifulSoup
from urllib.parse import urlparse, parse_qs

# Initialize Firebase App
cred = credentials.Certificate("./key.json")
firebase_admin.initialize_app(cred)

# Get Firestore client
db = firestore.client()
# Reference to the collection where you want to store your dining hall information
collection_ref = db.collection('Dining_Information')

driver = webdriver.Chrome()  # Initialize the driver
driver.get("https://nutrition.sa.ucsc.edu/")  # Go to the website

# List of dining halls to scrape
dining_halls = [
    'College Nine/John R. Lewis Dining Hall',
    'Cowell/Stevenson Dining Hall',
    'Crown/Merrill Dining Hall',
    'Porter/Kresge Dining Hall',
    'Rachel Carson/Oakes Dining Hall'
]

for hall in dining_halls:
    # Simplify the dining hall name to use as the document ID
    hall_doc_id = hall.replace('/', '').replace(' ', '')
    # Reference to the document for the dining hall
    hall_doc_ref = collection_ref.document(hall_doc_id)

    try:
        print(f"Entering ... {hall}")
        # Navigate to the main page and wait for it to load
        driver.get("https://nutrition.sa.ucsc.edu/")
        WebDriverWait(driver, 10).until(EC.presence_of_all_elements_located((By.CLASS_NAME, "locations")))

        # Find the link to the dining hall using XPath and click it
        xpath = f"//a[contains(text(), '{hall}')]"
        link = WebDriverWait(driver, 10).until(EC.element_to_be_clickable((By.XPATH, xpath)))
        link.click()

        # Now that the dining hall menu page has loaded, fetch the HTML content
        WebDriverWait(driver, 10).until(EC.presence_of_element_located((By.CLASS_NAME, "shortmenumeals")))  # This is for the meal types, assuming this is the correct class name
        html_content = driver.page_source

        # Parse the page with BeautifulSoup
        soup = BeautifulSoup(html_content, 'html.parser')
        nutrition_calculators = soup.find_all(class_='shortmenunutritive')

        # Separate the links by meal times
        meal_types = {'Breakfast': [], 'Lunch': [], 'Dinner': [], 'Late Night': []}

        for calculator in nutrition_calculators:
            # Parse the href attribute of the <a> tag
            link = calculator.find('a')['href']
            parsed_link = urlparse(link)
            query_params = parse_qs(parsed_link.query)
            
            # Get the meal name from the query parameters
            meal_name = query_params.get('mealName', [None])[0]
            
            # Append the link to the corresponding meal time list
            if meal_name and meal_name in meal_types:
                meal_types[meal_name].append(link)

        # Print or process the separated links
        for meal_type, links in meal_types.items():
            print(f"{meal_type} Nutrition Calculators:")
            for link in links:
                print(link)

        # Extract meal types
        for meal_type in soup.find_all(class_='shortmenumeals'):
            meal_type_name = meal_type.get_text()
            print(f"Meal Type: {meal_type_name}")

        # Go to each link and scrape the information
        for meal_type, links in meal_types.items():
            for link in links:
                print(f"Scraping {meal_type}")
                # Use Selenium to go to the nutrition calculator link
                if not link.startswith('http'):
                    link = 'https://nutrition.sa.ucsc.edu/' + link
                
                print(f"Going to {link}")
                driver.get(link)

                # Wait until the page is loaded
                WebDriverWait(driver, 10).until(EC.presence_of_element_located((By.TAG_NAME, "tbody")))
                print("at nutrition calculator")

                # Initialize a dictionary to hold the category and its dishes
                menu = {}
                current_category = ""
                tbody = driver.find_element(By.TAG_NAME, "tbody")
                rows = tbody.find_elements(By.TAG_NAME, "tr")

                for row in rows:
                    category_elements = row.find_elements(By.XPATH, ".//div[@class='longmenucolmenucat']")
                    if category_elements:
                        current_category = category_elements[0].text.strip()
                        menu[current_category] = []
                    else:
                        dish_elements = row.find_elements(By.XPATH, ".//div[@class='longmenucoldispname']/a")
                        for dish_element in dish_elements:
                            dish_name = dish_element.text.strip()
                            dish_images = row.find_elements(By.XPATH, ".//td/img")
                            image_names = [img.get_attribute("src").split("/")[-1] for img in dish_images]
                            menu[current_category].append({"name": dish_name, "attributes": image_names})

                # Deduplicate dishes within each category
                deduplicated_menu = {}
                for category, dishes in menu.items():
                    seen = set()
                    deduplicated_dishes = []
                    for dish in dishes:
                        if dish['name'] not in seen:
                            seen.add(dish['name'])
                            # Removing the '.gif' extension from image names
                            dish['attributes'] = [img.split('/')[-1].replace('.gif', '') for img in dish['attributes']]
                            deduplicated_dishes.append(dish)
                    deduplicated_menu[category] = deduplicated_dishes
                
                # After deduplication, save the menu data to Firestore
                meal_type_sanitized = meal_type.replace(' ', '_')
                meal_type_ref = hall_doc_ref.collection(meal_type_sanitized)

                # Save each category and its dishes in the meal type collection
                for category, dishes in deduplicated_menu.items():
                    category_sanitized = category.replace(' ', '').replace('--', '').strip()
                    category_doc_ref = meal_type_ref.document(category_sanitized)
                    category_doc_ref.set({'dishes': dishes})

                # Print the deduplicated menu
                print(f"{meal_type}: {deduplicated_menu}")



    except Exception as e:
        print(f"An error occurred while processing {hall}: {e}")
        driver.save_screenshot(f"error_{hall}.png")  # Save a screenshot for debugging

    finally:
        # Make sure to navigate back to the main page if an error occurs
        if driver.current_url != "https://nutrition.sa.ucsc.edu/":
            driver.get("https://nutrition.sa.ucsc.edu/")

# Close the WebDriver
driver.quit()
