import serial
import time

ser = serial.Serial()
ser.baudrate = 115200
ser.port = 'COM6'
ser.bytesize = serial.EIGHTBITS
ser.parity   = serial.PARITY_NONE
ser.stopbits = serial.STOPBITS_ONE
ser.xonxoff  = 0

if(ser.is_open == False):
    ser.open()
print("Port Open")

time.sleep(1)
ser.write(b'\x00')
time.sleep(1)
ser.write(b'\x31')
time.sleep(1)
ser.write(b'\x32')
time.sleep(1)
ser.write(b'\x33')
time.sleep(1)
ser.write(b'\x34')
time.sleep(1)
ser.write(b'\x35')
time.sleep(1)
ser.write(b'\x36')
time.sleep(1)
ser.write(b'\x37')
time.sleep(1)
ser.write(b'\x38')
time.sleep(1)
ser.write(b'\x00')
time.sleep(1)
ser.write(b'\x00')
time.sleep(1)
ser.write(b'\x00')
time.sleep(1)
ser.write(b'\x00')
print("Write complete")

while True:
    c = ser.read()
    if len(c) == 0:
        break
    print(c)

ser.close()