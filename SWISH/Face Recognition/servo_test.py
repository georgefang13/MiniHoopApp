from gpiozero import AngularServo
from gpiozero.pins.pigpio import PiGPIOFactory
from time import sleep

factory = PiGPIOFactory()

servo = AngularServo(21, pin_factory=factory, min_angle = 0, max_angle = 270, min_pulse_width = 0.0005, max_pulse_width = 0.0025)

servo.angle = 0

servo.close()
# while (True):
#     servo.angle = 0
#     sleep(4)
#     servo.angle = 260
#     sleep(4)