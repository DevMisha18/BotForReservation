from selenium import webdriver
from selenium.webdriver.chrome.service import Service
from selenium.webdriver.chrome.options import Options
from webdriver_manager.chrome import ChromeDriverManager
from selenium.webdriver.common.by import By

from time import sleep

import json

with open("data.json", "r") as file:
    data = json.load(file)

# Access the values in the dictionary
email = data["email"]
password = data["password"]
start_hour = data["start_hour"]
end_hour = data["end_hour"]

# Variables
min_resv_hour = 9   # For billiard, it's 9 a.m

# Setup
options = Options()
options.add_experimental_option("detach", True)

driver = webdriver.Chrome(service=Service(ChromeDriverManager().install()), options=options)

# Enter the website & max the window
driver.get("https://panel.dsnet.agh.edu.pl/reserv/rezerwuj/2369")
driver.maximize_window()

# Entering email and password and register
email_field = driver.find_element(By.ID, "username")     # email
email_field.send_keys(email)
password_field = driver.find_element(By.ID, "password")  # password
password_field.send_keys(password)
register_button = driver.find_element(By.XPATH, "/html/body/div[2]/div/main/form/div[3]/div/button")
register_button.click()

# Find buttons with XPATH and click
for index in range(start_hour, end_hour):
    reserve_button = driver.find_element(By.XPATH,
        f"/html/body/div[2]/div[1]/main/div[3]/form/table/tbody/tr[{index-min_resv_hour+1}]/td[4]/button")
    if reserve_button.text == "rezerwuj":
        reserve_button.click()
    sleep(1)

# Quiting Chrome
driver.quit()
