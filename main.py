import serial
import time
from datetime import datetime

# serial init
ser = serial.Serial("COM5", 9600)
time.sleep(2)

# file sys init

while True:
    now = datetime.now()
    b = ser.readline()
    string_n = b.decode()  # decode byte string into Unicode  
    string = string_n.rstrip() # remove \n and \r
    if "WARNING" in string:
        string_new = string + " " + now.strftime("%Y-%m-%d %H:%M:%S")
        print("FILTERED: " + string_new)
        f = open("out.txt", "a+")
        f.write(string_new + "\n")          # add to the end of file
        f.close()


ser.close()
