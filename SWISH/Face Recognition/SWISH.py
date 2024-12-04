import time

# face regonition:
from picamera2 import Picamera2 # camera driver
import numpy as np
import cv2                      # openCV
import face_recognition         # facial recognition model
import pickle                   # model encodings driver

# GPIO:
from gpiozero import Button, LED, AngularServo # generic classes for I/O + servo
from gpiozero.pins.pigpio import PiGPIOFactory # Non-default GPIO factory for better stepper/servo control

# color sensor:
import board                
import busio                
import adafruit_tcs34725

# server requests
import requests    


# ball color to username dict
color_map = {"green": "luke", "blue": "george", "red": "gavin"}

# previous location dict in case user is not found
loc_map = {"luke": 50, "gavin": 50, "george": 50}


# input pins:
HOPPER = 17 # hopper line break
RIM = 5     # rim line break
SERVO = 21  # servo PWM wire

# output pins:
PWHEEL_DIR = 27 # stepper direction
PWHEEL_STP = 22 # stepper step 
MOTOR1_P1 = 26  # DC motor control pins
MOTOR1_P2 = 19
MOTOR2_P1 = 13
MOTOR2_P2 = 6


# initialize global variables
cv_scaler = 1 # how much to compress the image before analysis

made_shot = False # tracks if the previous shot passed through the hoop

# lists to track which faces were found in the last frame
face_locations = []
face_encodings = []
face_names = []


# interrupt callbacks:

# to be triggered when ball is detected in hopper
def hopper_callback():
    print("New ball in hopper")
    pass_back() 
    
# to be triggered when ball passes through the hoop
def rim_callback():
    global made_shot
    print("Shot made")
    made_shot = True
    

# initialize GPIO
print("Initilizing GPIO")
# define the special GPIO factory to be used
factory = PiGPIOFactory()

# define the aiming servo
servo = AngularServo(SERVO, pin_factory=factory, min_angle = 0, max_angle = 270, min_pulse_width = 0.0005, max_pulse_width = 0.0025)
# point launcher straight out
servo.angle = 50

# define the hopper detection object w/ debouncing and GPIO factory applied
hopper = Button(HOPPER, bounce_time=0.25, pin_factory=factory)
# hopper object will call hopper_callback() when a ball breaks the beam
hopper.when_pressed = hopper_callback

# define the rim detection object w/ no debouncing and GPIO factory applied
rim = Button(RIM, bounce_time=0.0, pin_factory=factory)
# rim object will call rim_callback() when a ball breaks the beam
rim.when_pressed = rim_callback

# define the stepper controls as simple outputs
pwheel_dir = LED(PWHEEL_DIR, pin_factory=factory)
pwheel_stp = LED(PWHEEL_STP, pin_factory=factory)

# define the DC motor controls as simple outputs and immediatley turn them off
m1_p1 = LED(MOTOR1_P1, pin_factory=factory)
m1_p1.off()

m1_p2 = LED(MOTOR1_P2, pin_factory=factory)
m1_p2.off()

m2_p1 = LED(MOTOR2_P1, pin_factory=factory)
m2_p1.off()

m2_p2 = LED(MOTOR2_P2, pin_factory=factory)
m2_p2.off()


# initialize the pi camera
print("Initilizing camera")
picam2 = Picamera2()
picam2.configure(picam2.create_preview_configuration(main={"format": 'XRGB8888', "size": (1920, 1080)}))
picam2.start()

# initialize i2c
print("Initilizing i2c")
i2c = busio.I2C(board.SCL, board.SDA)

#initialize color sensor
print("Initilizing color sensor")
rgb_sensor = adafruit_tcs34725.TCS34725(i2c)
rgb_sensor.integration_time = 100 # ms
rgb_sensor.gain = 16

# load pre-trained face encodings
print("Loading encodings")
with open("encodings.pickle", "rb") as f:
    data = pickle.loads(f.read())
known_face_encodings = data["encodings"]
known_face_names = data["names"]

# indicate that all initialization is complete
print("Ready for shots\n")

# face finding function, puts results into the global lists
def process_frame(frame):
    global face_locations, face_encodings, face_names
    
    # resize the frame using cv_scaler to increase performance (less pixels processed, less time spent)
    resized_frame = cv2.resize(frame, (0, 0), fx=(1/cv_scaler), fy=(1/cv_scaler))
    
    # convert the image from BGR to RGB colour space, the facial recognition library uses RGB, OpenCV uses BGR
    rgb_resized_frame = cv2.cvtColor(resized_frame, cv2.COLOR_BGR2RGB)
    
    # find all the faces and face encodings in the current frame of video
    face_locations = face_recognition.face_locations(rgb_resized_frame)
    face_encodings = face_recognition.face_encodings(rgb_resized_frame, face_locations, model='large')
    
    # dump the previous face data
    face_names = []
    for face_encoding in face_encodings:
        # see if the face is a match for the known face(s)
        matches = face_recognition.compare_faces(known_face_encodings, face_encoding)
        name = "Unknown"
        
        # use the known face with the smallest distance to the new face
        face_distances = face_recognition.face_distance(known_face_encodings, face_encoding)
        best_match_index = np.argmin(face_distances)
        if matches[best_match_index]:
            name = known_face_names[best_match_index]
        face_names.append(name)
    
    return frame

# linear mapping for converting pixel location to servo angle
def lin_map(x, old_min, old_max, new_min, new_max):
    return (int)(((x - old_min)/(old_max - old_min)) * (new_max - new_min) + new_min)

# finds target user's location
def find_target(target_name):
    # check if the user wasnt found
    if target_name not in face_names:
        return -1 # user is not found and thus there is no location to pass to
    
    # grab facial coordinates of the the target
    loc = face_locations[face_names.index(target_name)]

    # average the x value for exact middle for aiming
    avg_x = (loc[1]+loc[3])/2

    # convert pixel x coordinate to servo angle (servo spins backwards in relation to pixel coodinates)
    return lin_map(avg_x, 0, 1920, 100, 0)

# reads color from the sensor
def read_color():
    r, g, b, c = rgb_sensor.color_raw
    
    # simple color checking function for the three balls
    # could easily add more balls with simple thresholding
    if r > g and r > b:
        return "red"
    elif b > g and b > r:
        return "blue"
    else:
        return "green"
    
# moves servo to desired angle
def aim(angle):
    servo.angle = angle
            
# logs the shot to the database
def log_shot(name, status, location):
    # database url
    url = "http://18.232.148.171:5050/api/shot"

    # construct JSON packet
    payload = {
        "name": name,
        "shot_made": status,
        "shot_zone": location//20 + 1, # turning an angle [0,100] to [1, 5]
    }
    
    # attempt to post data
    try:
        response = requests.post(url, json=payload)
        
        if response.status_code == 201:
            print("Shot logged successfully:", response.json())
        else:
            print(f"Failed to log shot. Status code: {response.status_code}, Response: {response.text}")
        
    except requests.exceptions.RequestException as e:
        print(f"Failed to log shot: {e}")
    
# rotates pinwheel based on target location
def move_pinwheel(location):
    # put ball in bucket if user was not found
    if(location == -1):
        pwheel_dir.off() # ccw

        # rotate stepper for 50 steps (90 degrees)
        for i in range(50):
            pwheel_stp.on()
            time.sleep(0.01)
            pwheel_stp.off()
            time.sleep(0.01)
    else:
        pwheel_dir.on() # cw

        # rotate stepper for 50 steps (90 degrees)
        for i in range(50):
            pwheel_stp.on()
            time.sleep(0.01)
            pwheel_stp.off()
            time.sleep(0.01)

# turns on the DC motors in the desired direction
def spin_motors():
    m1_p2.on()
    m2_p2.on()

# turns off the DC motors
def stop_motors():
    m1_p2.off()
    m2_p2.off()

# passes the ball back
def pass_back():
    global made_shot
    
    # spin up motors first to give them time to reach max speed
    spin_motors()
    print("Motors spinning")
    
    # capture a frame from camera
    frame = picam2.capture_array()
    print("Frame captured")
        
    # process the frame
    process_frame(frame)
    print("Frame processed")
    
    # capture the ball color and map to user
    color = read_color()
    name = color_map[color]
    print(f"Color: {color} -> User: {name}")
        
    # get the targets location
    target_loc = find_target(name)

    # check if target was found
    if(target_loc != -1):
        print(f"Launching ball to {name} at {target_loc}")

        # aim servo and move the pinwheel
        aim(target_loc)
        move_pinwheel(target_loc)

        # allow ball time to launch
        time.sleep(2.5)

    # dump ball into storage if not found
    else:
        print(f"{name} not found")
        move_pinwheel(target_loc)

        # if user wasnt found, assume their location was their previous location
        target_loc = loc_map[name]
    
    # log shot to database
    log_shot(name, made_shot, target_loc)

    # update previous location
    loc_map[name] = target_loc
    
    # reset made variable
    made_shot = False
    
    # stop the motors
    stop_motors()

    print("Done\n")






