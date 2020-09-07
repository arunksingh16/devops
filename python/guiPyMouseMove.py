#! python3
# Program to move mouse to random location to avoid locking workstation, to interupt the program press ctrl+C or move the cursol to top left side of monitor. Thanks

import pyautogui
import time
import random
from datetime import datetime

print(pyautogui.size())
w, h = pyautogui.size()
print(pyautogui.position())

start_time = time.time()

try:
    while True:
        print(pyautogui.position())
        print(datetime.now().strftime('%Y-%m-%d %H:%M:%S'))
        pyautogui.moveTo(random.randint(700, 786), random.randint(500, 786), duration=5.0)
        print("--- %s seconds ---" % (time.time() - start_time))
        print()
        print()

except KeyboardInterrupt:
    print('\nDone.')


exit()
