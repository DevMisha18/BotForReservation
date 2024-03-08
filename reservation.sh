#!/bin/bash


# Installing selenium for python(needed for automatization)
echo "Installing Selenium(module for python automatization"
pip install selenium

# Warnings 
sleep 2.5
printf "\n\n\nAll the data should be related to DSNET:panel!\n"
sleep 3
printf "Enter correct data and don't change the position of the files, otherwise script won't work properly\n"
sleep 3
# Asking user for data
read -p "Enter your email: " email
read -p "Enter your password: " password
read -p "Enter hour you want to reserve FROM: " start_hour
read -p "Enter hour you want to reserve TILL: " end_hour

python3 <<EOF > data.json
import json

data = {
    "email": "$email",
    "password": "$password",
    "start_hour": "$start_hour",
    "end_hour": "$end_hour"
}

with open("data.json", "w") as file:
    json.dump(data, file, indent=2)
EOF


# Define the path to your Python script (relative or absolute)
SCRIPT_PATH="~/.billiard_reservation/bot.py"

# Determine the path to the python3 interpreter dynamically
PYTHON_PATH=$(which python3)

# Check if python3 is available
if [ -z "$PYTHON_PATH" ]; then
    echo "Error: python3 is not installed or not in PATH"
    exit 1
fi

# Define the cron schedule (every Thursday at 11:05 PM)
CRON_SCHEDULE="5 23 * * 4"

# Add the cron job to the crontab
echo "Setting up the crontab, THIS MAY REQUIRE CONFIRMATION FOR YOUR COMPUTER!(That's okay)"
sleep 2
echo "$CRON_SCHEDULE $PYTHON_PATH $SCRIPT_PATH" | crontab -


# Move all the files, so they don't disturb
echo "Creating folder ~/.billiard_reservation.."
mkdir ~/.billiard_reservation
sleep 2.5
echo "Moving files to this folder"
mv bot.py ~/.billiard_reservation
mv reservation.sh ~/.billiard_reservation
mv data.json ~/.billiard_reservation
sleep 2.5

# Cangratulatoins message
echo "Everything is complete!"

