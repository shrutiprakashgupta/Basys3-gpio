# Basys3-gpio
This repository contains RTL implementation of UART driver for utilization on FPGA board. It is further used in [DLX-Processor](https://github.com/shrutipgupta/DLX-Processor) project to communicate with Basys3 board. The aim is to setup a simple interface between the computer and FPGA board. As Basys3 is enabled with a USB-UART bridge <br/>
![USB-UART bridge](https://github.com/shrutipgupta/Basys3-gpio/blob/main/Basys3_GPIO.rpt/usb-uart-bridge.png) <br/>
with a serial communication driver implemented on a smaller section of the board itself and using a USB cable, a communication link can be setup, with the computer or other boards enabled with UART. Using the [serial communication library](https://pypi.org/project/pyserial/) in python, the input and output can directly be given from a text file and dumped into another. 
# UART Protocol
The details of UART Protocol are linked [here](https://www.ti.com/lit/ug/sprugp1/sprugp1.pdf?ts=1622210583454). The configurations used for this project are ![UART confg](https://github.com/shrutipgupta/Basys3-gpio/blob/main/Basys3_GPIO.rpt/uart_confg.png)
# Receiver module
The [receiver](https://github.com/shrutipgupta/Basys3-gpio/blob/main/Basys3_Gpio.srcs/sources_1/new/receive.v) module uses an FSM, which starts off when the start bit (a low bit, after transition from high bit) is detected. It then samples the bitline at instants close to the mid of each bit period and writes the received value in a register when the stop bit (a high bit after 8 data bits) is detected. It also raises an acknowledgment signal, which is utilized while integrating the block in bigger designs. 
![Receiver FSM](https://github.com/shrutipgupta/Basys3-gpio/blob/main/Basys3_GPIO.rpt/receiver.png)
# Transmitter module
The [transmitter](https://github.com/shrutipgupta/Basys3-gpio/blob/main/Basys3_Gpio.srcs/sources_1/new/transmit.v) module uses a similar FSM, as the receiver and generates the high and low bit values at the tx line. It takes in the new value to be transmitted only when the previous transmission is finished and the FSM is in IDLE state again. An enable signal is required to trigger the transmission, which provides better control while integration in bigger designs.
![Transmitter FSM](https://github.com/shrutipgupta/Basys3-gpio/blob/main/Basys3_GPIO.rpt/transmitter.png)
# Top module
The previously mentioned modules are integrated into a top module with the following FSM stages. ![Top module FSM](https://github.com/shrutipgupta/Basys3-gpio/blob/main/Basys3_GPIO.rpt/top_module.png) The process stage in the top level FSM can be replaced with the main design (for ex. the processor stage which works on input data and generates output). This stage is independent from others in terms of the triggering clock. This enables the processing RTL and the serial communication to work on two different clock speeds. This concept is used in [DLX Processor](https://github.com/shrutipgupta/DLX-Processor) project as well.
# Interface
Input can be given manually over a serial console via terminal. A terminal emulator PuTTY[https://www.putty.org/] is used to show the results here. <br/> ![UART interface](https://github.com/shrutipgupta/Basys3-gpio/blob/main/Basys3_GPIO.rpt/uart_interface.PNG) <br/> <br/>
Alternatively, [uart.py](https://github.com/shrutipgupta/Basys3-gpio/blob/main/uart.py) is used to give automated input and show the received values on terminal. ![uart_py_output](https://github.com/shrutipgupta/Basys3-gpio/blob/main/Basys3_GPIO.rpt/uart_py_output.png)

