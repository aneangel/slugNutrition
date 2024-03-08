from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC

# Initialize Selenium WebDriver
driver = webdriver.Chrome()

# Navigate to the main page URL
main_url = "https://nutrition.sa.ucsc.edu/"
driver.get(main_url)

# Define a function to extract calories information from the detail page
def get_calories_info():
    # Wait for the calories information to load
    WebDriverWait(driver, 10).until(EC.presence_of_element_located((By.XPATH, "//b[contains(text(), 'Calories')]")))
    # Extract the calories information
    calories_element = driver.find_element(By.XPATH, "//b[contains(text(), 'Calories')]")
    calories_value = calories_element.text.strip()
    return calories_value

# Loop through each dining hall by its location number
dining_halls = {'40': 'College Nine/John R. Lewis Dining Hall'}

# List of dining halls to scrape
dining_halls = ['College Nine/John R. Lewis Dining Hall', 'Cowell/Stevenson Dining Hall',
                'Crown/Merrill Dining Hall', 'Porter/Kresge Dining Hall', 'Rachel Carson/Oakes Dining Hall']

# Navigate to the main page URL
driver.get(main_url)

# Loop through each dining hall
for hall in dining_halls:
    print(f"Entering {hall}...")  # Print message when entering a dining hall

    # Wait for the dining hall links to be loaded
    WebDriverWait(driver, 10).until(EC.presence_of_all_elements_located((By.CLASS_NAME, "locations")))

    # Use XPath to find the link to the dining hall
    xpath = f"//a[contains(text(), '{hall}')]"
    link = WebDriverWait(driver, 10).until(EC.element_to_be_clickable((By.XPATH, xpath)))
    link.click()

    # Wait for the nutrition calculator link to be clickable
    WebDriverWait(driver, 10).until(EC.element_to_be_clickable((By.LINK_TEXT, "Nutrition Calculator"))).click()

    # Wait for the page with the nutrition calculator to load
    WebDriverWait(driver, 10).until(EC.presence_of_element_located((By.TAG_NAME, "tbody")))
    
    tbody = driver.find_element(By.TAG_NAME, "tbody")
    rows = tbody.find_elements(By.TAG_NAME, "tr")

    current_category = ""
    nutrition = {}

    for row in rows:
        category_elements = row.find_elements(By.XPATH, ".//div[@class='longmenucolmenucat']")
        if category_elements:
            current_category = category_elements[0].text.strip()
            nutrition[current_category] = []
        else:
            dish_elements = row.find_elements(By.XPATH, ".//div[@class='longmenucoldispname']/a")
            for dish_element in dish_elements:
                    dish_name = dish_element.text.strip()
                    
                    # Open the link in a new tab to avoid losing the context
                    dish_url = dish_element.get_attribute('href')
                    driver.execute_script(f"window.open('{dish_url}', 'new_window')")
                    
                    # Switch to the new window
                    driver.switch_to.window('new_window')
                    
                    # Wait for the new page to load (adjust the wait time and condition as necessary)
                    WebDriverWait(driver, 10).until(EC.presence_of_element_located((By.TAG_NAME, "b")))
                    
                    # Extract data from the dish detail page
                    detail_element = driver.find_element(By.XPATH, "//b[contains(text(), 'Calories')]")
                    calories_value = detail_element.text.strip()
                    
                    # Add the dish name and its calories value to the current category in the nutrition dictionary
                    nutrition[current_category].append((dish_name, calories_value))
                    
                    # Close the new window
                    driver.close()
                    
                    # Switch back to the original window
                    driver.switch_to.window(driver.window_handles[0])
        # print(f"Completed scraping {hall_name}.")
        # Print the nutrition data
        print(nutrition)

        # Navigate back to the main page for the next dining hall
        driver.get(main_url)

    # Close the WebDriver
driver.quit()

# for locationNum, hall_name in dining_halls.items():
#     print(f"Entering {hall_name}...")

#     # Construct the URL for the dining hall's menu page
#     dining_hall_url = f"{main_url}shortmenu.aspx?sName=UC+Santa+Cruz+Dining&locationNum={locationNum}&locationName={hall_name.replace(' ', '+')}&naFlag=1"
#     driver.get(dining_hall_url)

#     # Click the link to the long menu (nutrition calculator)
#     long_menu_url = f"{main_url}longmenu.aspx?sName=UC+Santa+Cruz+Dining&locationNum={locationNum}&locationName={hall_name.replace(' ', '+')}&naFlag=1&WeeksMenus=UCSC+-+This+Week%27s+Menus&dtdate=03%2f04%2f2024&mealName=Breakfast"
#     driver.get(long_menu_url)

#     # Wait for the table of food items to load
#     WebDriverWait(driver, 10).until(EC.presence_of_element_located((By.TAG_NAME, "tbody")))
#     tbody = driver.find_element(By.TAG_NAME, "tbody")
#     rows = tbody.find_elements(By.TAG_NAME, "tr")

    # current_category = ""
    # nutrition = {}

    # for row in rows:
    #     category_elements = row.find_elements(By.XPATH, ".//div[contains(@class, 'longmenucolmenucat')]")
    #     if category_elements:
    #         current_category = category_elements[0].text.strip()
    #         nutrition[current_category] = []
    #     else:
    #         dish_elements = row.find_elements(By.XPATH, ".//div[contains(@class, 'longmenucoldispname')]/a")
    #         for dish_element in dish_elements:
    #             dish_name = dish_element.text.strip()

    #             # Open the dish detail page
    #             dish_url = dish_element.get_attribute('href')
    #             driver.get(dish_url)

    #             # Extract calories information from the detail page
    #             calories_value = get_calories_info()

    #             # Store the dish and its calories value
    #             nutrition[current_category].append((dish_name, calories_value))

    #             # Navigate back to the list of food items
    #             driver.back()
    #             WebDriverWait(driver, 10).until(EC.presence_of_element_located((By.TAG_NAME, "tbody")))

        
