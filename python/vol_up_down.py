# script to control system volume


import pyautogui
import time

while True:
    pyautogui.press('volumedown')
    time.sleep(2)
    pyautogui.press('volumeup')
    time.sleep(5)
