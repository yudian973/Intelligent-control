EESchema Schematic File Version 2  date 2010-1-18 13:05:59
LIBS:power,device,transistors,conn,linear,regul,74xx,cmos4000,adc-dac,memory,xilinx,special,microcontrollers,dsp,microchip,analog_switches,motorola,texas,intel,audio,interface,digital-audio,philips,display,cypress,siliconi,opto,atmel,contrib,valves,elan,.\EM78M611_PIN24_RX_V1.0.cache
EELAYER 24  0
EELAYER END
$Descr A4 11700 8267
Sheet 1 1
Title "noname.sch"
Date "19 may 2009"
Rev ""
Comp ""
Comment1 ""
Comment2 ""
Comment3 ""
Comment4 ""
$EndDescr
$Comp
L EM78M611_40PIN_DIL U4
U 1 1 4A12450A
P 5800 5950
F 0 "U4" H 5200 7000 60  0000 C CNN
F 1 "EM78M611_40PIN_DIL" V 5800 5950 60  0000 C CNN
	1    5800 5950
	1    0    0    -1  
$EndComp
Connection ~ 4400 1400
Wire Wire Line
	4400 1400 4400 2400
Wire Wire Line
	4400 2400 5100 2400
Connection ~ 3800 2750
Wire Wire Line
	3800 2750 3800 3100
Wire Wire Line
	3800 3100 5100 3100
Wire Wire Line
	4050 3050 4400 3050
Wire Wire Line
	3450 3200 3200 3200
Wire Wire Line
	4050 3400 5100 3400
Wire Wire Line
	4050 3200 5100 3200
Wire Wire Line
	5100 2800 5000 2800
Wire Wire Line
	5000 2800 5000 2750
Wire Wire Line
	5000 2750 4900 2750
Wire Wire Line
	4400 2950 4350 2950
Wire Wire Line
	7950 2400 7400 2400
Wire Wire Line
	4900 3000 5100 3000
Wire Wire Line
	5100 2600 2900 2600
Wire Wire Line
	2900 2800 2950 2800
Wire Wire Line
	8600 2600 8600 1400
Wire Wire Line
	8600 3300 7400 3300
Wire Wire Line
	8600 3100 7400 3100
Wire Wire Line
	8600 2900 7400 2900
Wire Wire Line
	8600 2700 7400 2700
Wire Wire Line
	8450 4650 8050 4650
Wire Wire Line
	5750 4350 6650 4350
Wire Wire Line
	5750 4550 6650 4550
Wire Wire Line
	5400 4550 4600 4550
Connection ~ 7800 1400
Wire Wire Line
	7800 1400 7800 1650
Wire Wire Line
	5100 2300 5100 1800
Wire Wire Line
	5100 1800 5950 1800
Wire Wire Line
	6550 1800 7400 1800
Wire Wire Line
	7400 1800 7400 2300
Wire Wire Line
	3250 2500 2900 2500
Wire Wire Line
	3200 4850 3200 4350
Wire Wire Line
	4600 4450 4600 4250
Wire Wire Line
	5400 4650 4600 4650
Wire Wire Line
	5750 4650 6650 4650
Wire Wire Line
	5750 4450 6650 4450
Wire Wire Line
	8050 4650 8050 4550
Wire Wire Line
	8050 4350 8050 4200
Wire Wire Line
	8600 2800 7400 2800
Wire Wire Line
	8600 3000 7400 3000
Wire Wire Line
	8600 3200 7400 3200
Wire Wire Line
	8600 3800 8600 3400
Wire Wire Line
	5100 2500 3650 2500
Wire Wire Line
	5100 2700 2900 2700
Wire Wire Line
	8600 1400 3100 1400
Wire Wire Line
	3100 1400 3100 2500
Connection ~ 3100 2500
Wire Wire Line
	4900 3050 4900 2950
Connection ~ 4900 3000
Connection ~ 4000 2750
Wire Wire Line
	4900 2850 4950 2850
Wire Wire Line
	4950 2850 4950 2900
Wire Wire Line
	4950 2900 5100 2900
Wire Wire Line
	4050 3300 5100 3300
Wire Wire Line
	3200 3200 3200 3400
Wire Wire Line
	3050 2800 3450 2800
Wire Wire Line
	3650 2750 4300 2750
Wire Wire Line
	4000 2850 4000 2750
$Comp
L VDD #PWR?
U 1 1 4A43377C
P 4050 3050
F 0 "#PWR?" H 4050 3150 30  0001 C CNN
F 1 "VDD" H 4050 3160 30  0000 C CNN
	1    4050 3050
	0    -1   -1   0   
$EndComp
$Comp
L +3.3V #PWR?
U 1 1 4A1A2E85
P 4350 2950
F 0 "#PWR?" H 4350 2910 30  0001 C CNN
F 1 "+3.3V" V 4350 3150 30  0000 C CNN
	1    4350 2950
	0    -1   -1   0   
$EndComp
$Comp
L R MTP
U 1 1 4A1A2E14
P 4650 2950
F 0 "MTP" V 4650 2850 50  0000 C CNN
F 1 "10K" V 4650 3050 50  0000 C CNN
	1    4650 2950
	0    1    1    0   
$EndComp
$Comp
L R MASK
U 1 1 4A1A2E04
P 4650 3050
F 0 "MASK" V 4650 2950 50  0000 C CNN
F 1 "10K" V 4650 3150 50  0000 C CNN
	1    4650 3050
	0    1    1    0   
$EndComp
$Comp
L DGND #PWR4
U 1 1 4A124028
P 3650 2750
F 0 "#PWR4" H 3650 2750 40  0001 C CNN
F 1 "DGND" H 3650 2680 40  0000 C CNN
	1    3650 2750
	0    1    1    0   
$EndComp
$Comp
L R R1
U 1 1 4A123FE4
P 4650 2850
F 0 "R1" V 4650 2750 50  0000 C CNN
F 1 "510" V 4650 2950 50  0000 C CNN
	1    4650 2850
	0    1    1    0   
$EndComp
$Comp
L LED D1
U 1 1 4A123F33
P 4200 2850
F 0 "D1" H 4250 2900 50  0000 C CNN
F 1 "LED" H 4200 2750 50  0001 C CNN
	1    4200 2850
	-1   0    0    -1  
$EndComp
$Comp
L SW_PUSH SW1
U 1 1 4A123B81
P 4600 2750
F 0 "SW1" H 4600 2750 50  0000 C CNN
F 1 "SW_PUSH" H 4600 2670 50  0001 C CNN
	1    4600 2750
	1    0    0    -1  
$EndComp
Text Label 4050 3400 0    60   ~ 0
93C46_CS_P56
Text Label 5750 4350 0    60   ~ 0
93C46_CS_P56
Text Label 4050 3300 0    60   ~ 0
IIC_SDA_P55
Text Label 4050 3200 0    60   ~ 0
IIC_SCL_P54
Text Label 5750 4450 0    60   ~ 0
SPI_CLK_P62
Text Label 5750 4550 0    60   ~ 0
SPI_MOSI_P63
Text Label 5750 4650 0    60   ~ 0
SPI_MISO_P60
NoConn ~ 8050 4450
$Comp
L VDD #PWR6
U 1 1 4A122DF1
P 8050 4200
F 0 "#PWR6" H 8050 4300 30  0001 C CNN
F 1 "VDD" H 8050 4310 30  0000 C CNN
	1    8050 4200
	1    0    0    -1  
$EndComp
$Comp
L DGND #PWR8
U 1 1 4A122DDE
P 8450 4650
F 0 "#PWR8" H 8450 4650 40  0001 C CNN
F 1 "DGND" H 8450 4580 40  0000 C CNN
	1    8450 4650
	0    -1   -1   0   
$EndComp
Text Label 4600 4650 0    60   ~ 0
IIC_SDA_P55
Text Label 4600 4550 0    60   ~ 0
IIC_SCL_P54
$Comp
L VDD #PWR7
U 1 1 4A122AEA
P 4600 4250
F 0 "#PWR7" H 4600 4350 30  0001 C CNN
F 1 "VDD" H 4600 4360 30  0000 C CNN
	1    4600 4250
	1    0    0    -1  
$EndComp
$Comp
L DGND #PWR9
U 1 1 4A122AD6
P 3200 4850
F 0 "#PWR9" H 3200 4850 40  0001 C CNN
F 1 "DGND" H 3200 4780 40  0000 C CNN
	1    3200 4850
	1    0    0    -1  
$EndComp
$Comp
L 93C46 U3
U 1 1 4A122A4A
P 7350 4500
F 0 "U3" H 7050 4750 60  0000 C CNN
F 1 "93C46" V 7350 4500 60  0000 C CNN
	1    7350 4500
	1    0    0    -1  
$EndComp
$Comp
L 24CXX U2
U 1 1 4A122A42
P 3900 4500
F 0 "U2" H 3600 4750 60  0000 C CNN
F 1 "24CXX" V 3900 4500 60  0000 C CNN
	1    3900 4500
	1    0    0    -1  
$EndComp
NoConn ~ 5100 3200
NoConn ~ 5100 3300
NoConn ~ 5100 3400
NoConn ~ 7400 3400
NoConn ~ 7400 2600
NoConn ~ 7400 2500
$Comp
L EM78M611_24PIN U1
U 1 1 49FFF056
P 6250 2850
F 0 "U1" H 5550 3500 60  0000 C CNN
F 1 "EM78M611_24PIN" V 6350 2850 60  0000 C CNN
	1    6250 2850
	1    0    0    -1  
$EndComp
$Comp
L USB_2 J1
U 1 1 49FFDF84
P 2700 2650
F 0 "J1" H 2625 2900 60  0000 C CNN
F 1 "USB_2" H 2600 2400 60  0001 C CNN
F 4 "VCC" H 2600 2800 50  0001 C CNN "VCC"
F 6 "D+" H 2650 2700 50  0001 C CNN "Data+"
F 8 "D-" H 2650 2600 50  0001 C CNN "Data-"
F 10 "GND" H 2600 2500 50  0001 C CNN "Ground"
	1    2700 2650
	1    0    0    1   
$EndComp
$Comp
L VDD #PWR2
U 1 1 49FFDD5A
P 7950 2400
F 0 "#PWR2" H 7950 2500 30  0001 C CNN
F 1 "VDD" H 7950 2510 30  0000 C CNN
	1    7950 2400
	0    1    1    0   
$EndComp
$Comp
L VDD #PWR3
U 1 1 49FFDD44
P 2950 2800
F 0 "#PWR3" H 2950 2900 30  0001 C CNN
F 1 "VDD" H 2950 2910 30  0000 C CNN
	1    2950 2800
	0    1    1    0   
$EndComp
$Comp
L DGND #PWR1
U 1 1 49FFDD07
P 7800 1650
F 0 "#PWR1" H 7800 1650 40  0001 C CNN
F 1 "DGND" H 7800 1580 40  0000 C CNN
	1    7800 1650
	1    0    0    -1  
$EndComp
Text Label 8600 3800 1    60   ~ 0
V3.3
Text Label 3700 2500 0    60   ~ 0
V3.3
Text Label 7500 3300 0    60   ~ 0
SPI_MISO_P60
Text Label 7500 3200 0    60   ~ 0
RESET_N_P61
Text Label 7500 3100 0    60   ~ 0
SPI_CLK_P62
Text Label 7500 3000 0    60   ~ 0
SPI_MOSI_P63
Text Label 7500 2900 0    60   ~ 0
SPI_SS_P64
Text Label 7500 2800 0    60   ~ 0
FIFO_FLAG_P65
Text Label 7500 2700 0    60   ~ 0
PKT_FLAG_P66
$Comp
L DGND #PWR5
U 1 1 49FFDA41
P 3200 3400
F 0 "#PWR5" H 3200 3400 40  0001 C CNN
F 1 "DGND" H 3200 3330 40  0000 C CNN
	1    3200 3400
	1    0    0    -1  
$EndComp
$Comp
L C C5
U 1 1 49FFD867
P 3450 3000
F 0 "C5" H 3300 2900 50  0000 L CNN
F 1 "10UF" H 3250 2800 50  0000 L CNN
	1    3450 3000
	1    0    0    -1  
$EndComp
$Comp
L C C2
U 1 1 49FFD96E
P 6550 1600
F 0 "C2" H 6600 1700 50  0000 L CNN
F 1 "33P" H 6600 1500 50  0000 L CNN
	1    6550 1600
	1    0    0    -1  
$EndComp
$Comp
L C C1
U 1 1 49FFD96A
P 5950 1600
F 0 "C1" H 5700 1700 50  0000 L CNN
F 1 "33p" H 5700 1500 50  0000 L CNN
	1    5950 1600
	1    0    0    -1  
$EndComp
$Comp
L CONN_9 P1
U 1 1 49FFD8AF
P 8950 3000
F 0 "P1" V 8900 3000 60  0000 C CNN
F 1 "CONN_9" V 9000 3000 60  0000 C CNN
	1    8950 3000
	1    0    0    1   
$EndComp
$Comp
L CRYSTAL X1
U 1 1 49FFD8A3
P 6250 1800
F 0 "X1" H 6250 1950 60  0000 C CNN
F 1 "6MHz" H 6250 1650 60  0000 C CNN
	1    6250 1800
	1    0    0    -1  
$EndComp
$Comp
L C C3
U 1 1 49FFD86F
P 3450 2500
F 0 "C3" H 3200 2400 50  0000 L CNN
F 1 "4.7UF" H 3050 2500 50  0000 L CNN
	1    3450 2500
	0    1    1    0   
$EndComp
$Comp
L C C4
U 1 1 49FFD86A
P 3200 3000
F 0 "C4" H 3000 2900 50  0000 L CNN
F 1 "101" H 3000 2800 50  0000 L CNN
	1    3200 3000
	1    0    0    -1  
$EndComp
$EndSCHEMATC
