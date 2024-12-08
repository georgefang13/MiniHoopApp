# S.W.I.S.H. Basketball Mini-Hoop Auto Rebounder

Authors: George Fang, Luke Andresen, Gavin Kitch

Welcome to the MiniHoopApp repository! This project is part of the S.W.I.S.H. Basketball system, designed to enhance the experience of playing mini basketball. The app serves as the user interface for tracking and visualizing player performance, including shot data and heatmaps.

## Features
* Player Profiles: View performance statistics for each player.
* Shot Performance Tracking: Displays total shots, successful makes, and shooting percentages.
* Heatmaps: Visual representation of shot locations and success rates.
Responsive Web Interface: A clean and user-friendly interface designed for desktop and mobile devices.
## How It Works
* Sensors Integration: Data is collected from the S.W.I.S.H. Basketball system using a variety of sensors that detect shots and record data such as shot success and ball color.
* Data Processing: Shot data is processed and stored in a backend database (to be integrated).
* Visualization: The MiniHoopApp retrieves the processed data and presents it in a dynamic, interactive UI.

## Running on a Raspberry Pi

First, download the SWISH folder onto your Pi.

### Activating the Virtual Environment

After navigating to the SWISH folder on your Pi, activate the project's virtual environment in the terminal.

```
source bin/activate
```

### Capturing Face Data for the Users

For each individual user, open image_capture.py, fill in the line at the top with the specific user's name.
```
PERSON_NAME = "luke"
```
Run the script and walk around the room, pressing space-bar to capture a photo. Ensure that photos are captured from a wide variety of distances. 25-50 photos worked best.

Press 'q' to end the session.

### Training the Model:
Run model_training.py.

### Running SWISH:

Within SWISH.py, modify the color_map dictionary, filling in the names parameter with each trained user and the color parameter with the color you want the user to be mapped to, of "red," "green," and "blue." Also, fill in the url field of you AWS instance for where the data should be posted to on line 202 of SWISH.py.

Once all peripherals have been connected with the GPIO pins specified in SWISH.py, simply run SWISH.py to activate the system.

## Running the Server-side Code
1. Set up your AWS instance 
2. Create a PostgreSQL database in your AWS instance and name it 'swish_db'.
3. Open a tmux terminal and run the app.py file located in the mini_hoop_app/flask_code folder.

## Launching the Website

To launch the website on a local Chrome browser on VSCode, enter terminal and type 'flutter run'. When it prompts you with what platform to launch on, type '3' and it will launch on a local Chrome browser. 