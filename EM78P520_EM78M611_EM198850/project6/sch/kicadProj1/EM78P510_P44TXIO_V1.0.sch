EESchema Schematic File Version 2  date 2010-5-20 14:29:16
LIBS:power
LIBS:device
LIBS:transistors
LIBS:conn
LIBS:linear
LIBS:regul
LIBS:74xx
LIBS:cmos4000
LIBS:adc-dac
LIBS:memory
LIBS:xilinx
LIBS:special
LIBS:microcontrollers
LIBS:dsp
LIBS:microchip
LIBS:analog_switches
LIBS:motorola
LIBS:texas
LIBS:intel
LIBS:audio
LIBS:interface
LIBS:digital-audio
LIBS:philips
LIBS:display
LIBS:cypress
LIBS:siliconi
LIBS:opto
LIBS:atmel
LIBS:contrib
LIBS:valves
LIBS:EM78P510_P44TXIO_V1.0-cache
EELAYER 24  0
EELAYER END
$Descr A4 11700 8267
Sheet 1 1
Title "noname.sch"
Date "20 may 2010"
Rev ""
Comp ""
Comment1 ""
Comment2 ""
Comment3 ""
Comment4 ""
$EndDescr
Text Notes 8700 950  0    60   ~ 0
TP module
Wire Notes Line
	8650 2100 8650 1000
Wire Notes Line
	8650 2100 9850 2100
Wire Notes Line
	9850 2100 9850 1000
Wire Notes Line
	9850 1000 8650 1000
Wire Wire Line
	8425 2725 8075 2725
Wire Wire Line
	8425 2325 8075 2325
Wire Wire Line
	8850 1700 9250 1700
Wire Wire Line
	8850 1400 9250 1400
Wire Wire Line
	8850 1200 9250 1200
Wire Wire Line
	6525 675  6525 1175
Wire Wire Line
	6725 675  6725 1175
Wire Wire Line
	6025 675  6025 1175
Wire Wire Line
	6425 5375 6425 4475
Wire Wire Line
	3200 925  3200 1475
Wire Wire Line
	7650 5700 7650 6100
Wire Wire Line
	7200 5700 7200 6100
Wire Wire Line
	3700 925  3700 1475
Wire Wire Line
	3000 1375 3000 1475
Wire Wire Line
	5925 4475 5925 5375
Wire Wire Line
	8475 3225 8075 3225
Wire Wire Line
	8475 3025 8075 3025
Wire Wire Line
	3075 3675 3075 2925
Wire Wire Line
	3075 2925 4775 2925
Wire Wire Line
	4175 3675 4175 3225
Wire Wire Line
	4175 3225 4775 3225
Wire Wire Line
	6825 5375 6825 4475
Wire Wire Line
	6625 5375 6625 4475
Wire Wire Line
	6225 5375 6225 4475
Wire Wire Line
	4775 2825 4575 2825
Wire Wire Line
	4325 2525 4775 2525
Wire Wire Line
	4325 2325 4775 2325
Connection ~ 9200 5150
Wire Wire Line
	9200 5300 9200 5150
Wire Wire Line
	9400 4750 8950 4750
Wire Wire Line
	6000 6100 6000 6800
Wire Wire Line
	5650 6800 5650 6100
Wire Wire Line
	3975 7100 3975 5000
Wire Wire Line
	3575 7100 3575 5000
Wire Wire Line
	2725 6850 4575 6850
Wire Wire Line
	2725 6050 4575 6050
Wire Wire Line
	3900 925  3900 1475
Wire Wire Line
	3500 925  3500 1475
Wire Wire Line
	3300 925  3300 1475
Wire Wire Line
	3400 925  3400 1475
Wire Wire Line
	3600 925  3600 1475
Wire Wire Line
	4000 925  4000 1475
Wire Wire Line
	2725 5650 4575 5650
Wire Wire Line
	2725 6450 4575 6450
Wire Wire Line
	3175 7100 3175 5000
Wire Wire Line
	4375 7100 4375 5000
Wire Wire Line
	6700 6100 6700 6800
Wire Wire Line
	6350 6100 6350 6800
Wire Wire Line
	9400 5150 8950 5150
Wire Wire Line
	9200 4650 9200 4750
Connection ~ 9200 4750
Wire Wire Line
	4325 2425 4775 2425
Wire Wire Line
	4325 2625 4775 2625
Wire Wire Line
	4775 2725 4425 2725
Wire Wire Line
	6725 5375 6725 4475
Wire Wire Line
	6925 5375 6925 4475
Wire Wire Line
	4775 3675 4775 3325
Wire Wire Line
	4775 4275 4775 4075
Wire Wire Line
	3675 3675 3675 3025
Wire Wire Line
	3675 3025 4775 3025
Wire Wire Line
	4775 4075 3075 4075
Wire Wire Line
	8475 3125 8075 3125
Wire Wire Line
	8475 3325 8075 3325
Wire Wire Line
	4775 3125 4425 3125
Wire Wire Line
	6650 7200 6650 7000
Connection ~ 6650 7000
Wire Wire Line
	2900 1375 2900 1475
Wire Wire Line
	3800 925  3800 1475
Wire Wire Line
	5850 7000 7650 7000
Wire Wire Line
	6025 5375 6025 4475
Wire Wire Line
	3100 925  3100 1475
Wire Wire Line
	6525 5375 6525 4475
Wire Wire Line
	5925 675  5925 1175
Wire Wire Line
	6625 675  6625 1175
Wire Wire Line
	6825 675  6825 1175
Wire Wire Line
	8850 1300 9250 1300
Wire Wire Line
	8850 1600 9250 1600
Wire Wire Line
	9250 1800 8850 1800
Wire Wire Line
	6925 675  6925 1175
Wire Wire Line
	8425 2525 8075 2525
Wire Wire Line
	8850 1800 8850 1900
$Comp
L DGND #PWR?
U 1 1 4BF4D201
P 8850 1900
F 0 "#PWR?" H 8850 1900 40  0001 C CNN
F 1 "DGND" H 8850 1830 40  0000 C CNN
	1    8850 1900
	1    0    0    -1  
$EndComp
Text Label 8075 2725 0    60   ~ 0
TS_REQ
Text Label 8075 2325 0    60   ~ 0
TS_SCK
Text Label 6925 1175 1    60   ~ 0
TS_CS
Text Label 8075 2525 0    60   ~ 0
TS_SDO
Text Label 8850 1400 0    60   ~ 0
TS_SDO
Text Label 8850 1700 0    60   ~ 0
TS_CS
Text Label 8850 1600 0    60   ~ 0
TS_SCK
Text Label 8850 1300 0    60   ~ 0
TS_REQ
$Comp
L VDD #PWR?
U 1 1 4BF221FC
P 8850 1200
F 0 "#PWR?" H 8850 1300 30  0001 C CNN
F 1 "VDD" H 8850 1310 30  0000 C CNN
	1    8850 1200
	1    0    0    -1  
$EndComp
$Comp
L CONN_8 TP
U 1 1 4BF22166
P 9600 1550
F 0 "TP" V 9550 1550 60  0000 C CNN
F 1 "CONN_8" V 9650 1550 60  0000 C CNN
	1    9600 1550
	1    0    0    -1  
$EndComp
NoConn ~ 6125 1175
NoConn ~ 6225 1175
NoConn ~ 6425 1175
Text Label 5925 1175 1    60   ~ 0
TX
Text Label 6025 1175 1    60   ~ 0
RX
$Comp
L CONN_12 P2
U 1 1 4A76C03F
P 3450 1825
F 0 "P2" V 3400 1825 60  0000 C CNN
F 1 "CONN_12" V 3500 1825 60  0000 C CNN
	1    3450 1825
	0    -1   1    0   
$EndComp
NoConn ~ 6325 4475
Text Label 6525 5375 1    60   ~ 0
ReferResis
Text Label 6425 5375 1    60   ~ 0
LeakResis
Text Label 3100 1375 1    50   ~ 0
LeakResis
Text Label 3200 1375 1    50   ~ 0
ReferResis
Text Label 6025 5375 1    50   ~ 0
P82_LED2
Text Label 7650 6100 1    50   ~ 0
P82_LED2
$Comp
L DIODE D3
U 1 1 4A4F22D1
P 7650 6800
F 0 "D3" H 7650 6900 40  0000 C CNN
F 1 "LED" H 7650 6700 40  0000 C CNN
	1    7650 6800
	0    1    1    0   
$EndComp
$Comp
L R R5
U 1 1 4A4F22BF
P 7650 6350
F 0 "R5" V 7730 6350 50  0000 C CNN
F 1 "471" V 7650 6350 50  0000 C CNN
	1    7650 6350
	1    0    0    -1  
$EndComp
Text HLabel 9200 7375 0    50   Input ~ 0
EM78P520 airui kescan v2.0
NoConn ~ 6125 4475
$Comp
L SW_PUSH_SMALL SW12
U 1 1 4A35E07E
P 3275 6750
F 0 "SW12" H 3425 6860 30  0000 C CNN
F 1 "LSW1" H 3275 6671 30  0000 C CNN
	1    3275 6750
	1    0    0    -1  
$EndComp
$Comp
L SW_PUSH_SMALL SW3
U 1 1 4A35E074
P 4475 5550
F 0 "SW3" H 4625 5660 30  0000 C CNN
F 1 "RSW2" H 4475 5471 30  0000 C CNN
	1    4475 5550
	1    0    0    -1  
$EndComp
Text Label 3500 1375 1    50   ~ 0
LSW1_P77
Text Label 4000 1375 1    50   ~ 0
RSW2_P94
$Comp
L R R4
U 1 1 4A35C3B7
P 7200 6350
F 0 "R4" V 7280 6350 50  0000 C CNN
F 1 "471" V 7200 6350 50  0000 C CNN
	1    7200 6350
	1    0    0    -1  
$EndComp
Text Label 5925 5375 1    50   ~ 0
P81_LED1
NoConn ~ 6325 1175
NoConn ~ 8075 2925
NoConn ~ 8075 2825
$Comp
L VDD #PWR7
U 1 1 4A09129A
P 4425 3125
F 0 "#PWR7" H 4425 3225 30  0001 C CNN
F 1 "VDD" H 4425 3235 30  0000 C CNN
	1    4425 3125
	0    -1   -1   0   
$EndComp
Text Label 6225 5375 1    50   ~ 0
P84_MOTOR
$Comp
L DGND #PWR11
U 1 1 4A08EC41
P 4775 4275
F 0 "#PWR11" H 4775 4275 40  0001 C CNN
F 1 "DGND" H 4775 4205 40  0000 C CNN
	1    4775 4275
	1    0    0    -1  
$EndComp
$Comp
L VDD #PWR5
U 1 1 4A08EA41
P 4425 2725
F 0 "#PWR5" H 4425 2825 30  0001 C CNN
F 1 "VDD" H 4425 2835 30  0000 C CNN
	1    4425 2725
	0    -1   -1   0   
$EndComp
$Comp
L DGND #PWR6
U 1 1 4A08EA28
P 4575 2825
F 0 "#PWR6" H 4575 2825 40  0001 C CNN
F 1 "DGND" H 4575 2755 40  0000 C CNN
	1    4575 2825
	0    1    1    0   
$EndComp
$Comp
L EM78P510_44PIN U2
U 1 1 4A08E769
P 6425 2825
F 0 "U2" H 5185 4185 60  0000 C CNN
F 1 "EM78P510_44PIN" H 6425 2825 60  0000 C CNN
	1    6425 2825
	1    0    0    -1  
$EndComp
$Comp
L LED D2
U 1 1 49DEB5D5
P 7200 6800
F 0 "D2" H 7200 6700 40  0000 C CNN
F 1 "LED" H 7200 6900 40  0000 C CNN
	1    7200 6800
	0    -1   1    0   
$EndComp
Text Label 7200 6100 1    50   ~ 0
P81_LED1
Text Label 6350 6500 1    50   ~ 0
PB1_LEFT
Text Label 6000 6500 1    50   ~ 0
PB2_DOWN
Text Label 6700 6500 1    50   ~ 0
PB0_RIGHT
Text Label 5650 6500 1    50   ~ 0
PB3_UP
Text Label 6525 1175 1    50   ~ 0
PB3_UP
Text Label 6825 1175 1    50   ~ 0
PB0_RIGHT
Text Label 6725 1175 1    50   ~ 0
PB1_LEFT
Text Label 6625 1175 1    50   ~ 0
PB2_DOWN
$Comp
L VDD #PWR14
U 1 1 49C20311
P 9200 4650
F 0 "#PWR14" H 9200 4750 30  0001 C CNN
F 1 "VDD" H 9200 4760 30  0000 C CNN
	1    9200 4650
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR17
U 1 1 49C202F8
P 9200 5300
F 0 "#PWR17" H 9200 5300 30  0001 C CNN
F 1 "GND" H 9200 5230 30  0001 C CNN
	1    9200 5300
	1    0    0    -1  
$EndComp
$Comp
L C C8
U 1 1 49C202BE
P 9400 4950
F 0 "C8" H 9450 5050 50  0000 L CNN
F 1 "4.7uF" H 9450 4850 50  0000 L CNN
	1    9400 4950
	1    0    0    -1  
$EndComp
$Comp
L C C7
U 1 1 49C202B1
P 8950 4950
F 0 "C7" H 9000 5050 50  0000 L CNN
F 1 "104" H 9000 4850 50  0000 L CNN
	1    8950 4950
	1    0    0    -1  
$EndComp
Text Label 4325 2625 0    50   ~ 0
P77
Text Label 4325 2525 0    50   ~ 0
P76
Text Label 4325 2425 0    50   ~ 0
P75
Text Label 4325 2325 0    50   ~ 0
P74
Text Label 2725 6850 0    60   ~ 0
P77
Text Label 2725 6450 0    60   ~ 0
P76
Text Label 2725 6050 0    60   ~ 0
P75
$Comp
L GND #PWR18
U 1 1 49C20019
P 6650 7200
F 0 "#PWR18" H 6650 7200 30  0001 C CNN
F 1 "GND" H 6650 7130 30  0001 C CNN
	1    6650 7200
	1    0    0    -1  
$EndComp
Text Label 8075 3325 0    60   ~ 0
P94
Text Label 8075 3225 0    60   ~ 0
P95
Text Label 8075 3125 0    60   ~ 0
P96
Text Label 8075 3025 0    60   ~ 0
P97
Text Label 2725 5650 0    60   ~ 0
P74
Text Label 4375 5200 1    60   ~ 0
P94
Text Label 3975 5200 1    60   ~ 0
P95
Text Label 3575 5200 1    60   ~ 0
P96
Text Label 3175 5200 1    60   ~ 0
P97
$Comp
L SW_PUSH_SMALL SW15
U 1 1 49C1F8B5
P 5750 6900
F 0 "SW15" H 5900 7010 30  0000 C CNN
F 1 "up" H 5750 6821 30  0000 C CNN
	1    5750 6900
	1    0    0    -1  
$EndComp
$Comp
L SW_PUSH_SMALL SW16
U 1 1 49C1F898
P 6800 6900
F 0 "SW16" H 6950 7010 30  0000 C CNN
F 1 "right" H 6800 6821 30  0000 C CNN
	1    6800 6900
	1    0    0    -1  
$EndComp
$Comp
L SW_PUSH_SMALL SW17
U 1 1 49C1F853
P 6100 6900
F 0 "SW17" H 6250 7010 30  0000 C CNN
F 1 "down" H 6100 6821 30  0000 C CNN
	1    6100 6900
	1    0    0    -1  
$EndComp
$Comp
L SW_PUSH_SMALL SW18
U 1 1 49C1F84B
P 6450 6900
F 0 "SW18" H 6600 7010 30  0000 C CNN
F 1 "left" H 6450 6821 30  0000 C CNN
	1    6450 6900
	1    0    0    -1  
$EndComp
$Comp
L SW_PUSH_SMALL SW14
U 1 1 49C1F811
P 4475 6750
F 0 "SW14" H 4625 6860 30  0000 C CNN
F 1 "D_4" H 4475 6671 30  0000 C CNN
	1    4475 6750
	1    0    0    -1  
$EndComp
$Comp
L SW_PUSH_SMALL SW13
U 1 1 49C1F80C
P 3675 6750
F 0 "SW13" H 3825 6860 30  0000 C CNN
F 1 "start_10" H 3675 6671 30  0000 C CNN
	1    3675 6750
	1    0    0    -1  
$EndComp
$Comp
L SW_PUSH_SMALL SW11
U 1 1 49C1F802
P 4475 6350
F 0 "SW11" H 4625 6460 30  0000 C CNN
F 1 "MACRO" H 4475 6271 30  0000 C CNN
	1    4475 6350
	1    0    0    -1  
$EndComp
$Comp
L SW_PUSH_SMALL SW10
U 1 1 49C1F7FF
P 4075 6350
F 0 "SW10" H 4225 6460 30  0000 C CNN
F 1 "C_3" H 4075 6271 30  0000 C CNN
	1    4075 6350
	1    0    0    -1  
$EndComp
$Comp
L SW_PUSH_SMALL SW9
U 1 1 49C1F7FB
P 3675 6350
F 0 "SW9" H 3825 6460 30  0000 C CNN
F 1 "R1_6" H 3675 6271 30  0000 C CNN
	1    3675 6350
	1    0    0    -1  
$EndComp
$Comp
L SW_PUSH_SMALL SW8
U 1 1 49C1F7F7
P 3275 6350
F 0 "SW8" H 3425 6460 30  0000 C CNN
F 1 "select_9" H 3275 6271 30  0000 C CNN
	1    3275 6350
	1    0    0    -1  
$EndComp
$Comp
L SW_PUSH_SMALL SW7
U 1 1 49C1F7F0
P 4475 5950
F 0 "SW7" H 4625 6060 30  0000 C CNN
F 1 "R2_8" H 4475 5871 30  0000 C CNN
	1    4475 5950
	1    0    0    -1  
$EndComp
$Comp
L SW_PUSH_SMALL SW6
U 1 1 49C1F7EC
P 4075 5950
F 0 "SW6" H 4225 6060 30  0000 C CNN
F 1 "MODE" H 4075 5871 30  0000 C CNN
	1    4075 5950
	1    0    0    -1  
$EndComp
$Comp
L SW_PUSH_SMALL SW5
U 1 1 49C1F7E4
P 3675 5950
F 0 "SW5" H 3825 6060 30  0000 C CNN
F 1 "B_2" H 3675 5871 30  0000 C CNN
	1    3675 5950
	1    0    0    -1  
$EndComp
$Comp
L SW_PUSH_SMALL SW4
U 1 1 49C1F7DD
P 3275 5950
F 0 "SW4" H 3425 6060 30  0000 C CNN
F 1 "L1_5" H 3275 5871 30  0000 C CNN
	1    3275 5950
	1    0    0    -1  
$EndComp
$Comp
L SW_PUSH_SMALL SW2
U 1 1 49C1F7CB
P 4075 5550
F 0 "SW2" H 4225 5660 30  0000 C CNN
F 1 "L2_7" H 4075 5471 30  0000 C CNN
	1    4075 5550
	1    0    0    -1  
$EndComp
$Comp
L SW_PUSH_SMALL SW1
U 1 1 49C1F7B3
P 3275 5550
F 0 "SW1" H 3425 5660 30  0000 C CNN
F 1 "A_1" H 3275 5471 30  0000 C CNN
	1    3275 5550
	1    0    0    -1  
$EndComp
Text Label 6625 5375 1    50   ~ 0
LY_P90/AD3
Text Label 6725 5375 1    50   ~ 0
LX_P91/AD2
Text Label 6825 5375 1    50   ~ 0
RY_P92/AD1
Text Label 6925 5375 1    50   ~ 0
RX_P93/AD0
$Comp
L GND #PWR15
U 1 1 49C1F594
P 2900 1375
F 0 "#PWR15" H 2900 1375 30  0001 C CNN
F 1 "GND" H 2900 1305 30  0001 C CNN
	1    2900 1375
	-1   0    0    1   
$EndComp
$Comp
L VDD #PWR16
U 1 1 49C1F588
P 3000 1375
F 0 "#PWR16" H 3000 1475 30  0001 C CNN
F 1 "VDD" H 3000 1485 30  0000 C CNN
	1    3000 1375
	1    0    0    -1  
$EndComp
Text Label 3900 1375 1    50   ~ 0
RSW2_P74
Text Label 3600 1375 1    50   ~ 0
LSW1_P97
Text Label 3700 1375 1    50   ~ 0
RY_P92/AD1
Text Label 3800 1375 1    50   ~ 0
RX_P93/AD0
Text Label 3300 1375 1    50   ~ 0
LY_P90/AD3
Text Label 3400 1375 1    50   ~ 0
LX_P91/AD2
$Comp
L C C6
U 1 1 49C1DD20
P 4775 3875
F 0 "C6" V 4875 4025 50  0000 C CNN
F 1 "40P" V 4875 3725 50  0000 C CNN
	1    4775 3875
	-1   0    0    1   
$EndComp
$Comp
L C C5
U 1 1 49C1DD1C
P 4175 3875
F 0 "C5" V 4275 4025 50  0000 C CNN
F 1 "40P" V 4275 3725 50  0000 C CNN
	1    4175 3875
	-1   0    0    1   
$EndComp
$Comp
L C C4
U 1 1 49C1DD15
P 3675 3875
F 0 "C4" V 3775 4025 50  0000 C CNN
F 1 "30P" V 3775 3725 50  0000 C CNN
	1    3675 3875
	-1   0    0    1   
$EndComp
$Comp
L C C3
U 1 1 49C1DD0E
P 3075 3875
F 0 "C3" V 3175 4025 50  0000 C CNN
F 1 "30P" V 3175 3725 50  0000 C CNN
	1    3075 3875
	-1   0    0    1   
$EndComp
$Comp
L CRYSTAL X2
U 1 1 49C1DCE2
P 4475 3675
F 0 "X2" H 4475 3825 60  0000 C CNN
F 1 "32.768KHz" H 4475 3525 60  0000 C CNN
	1    4475 3675
	-1   0    0    1   
$EndComp
$Comp
L CRYSTAL X1
U 1 1 49C1DCD3
P 3375 3675
F 0 "X1" H 3375 3825 60  0000 C CNN
F 1 "4MHz/8MHz" H 3375 3525 60  0000 C CNN
	1    3375 3675
	-1   0    0    1   
$EndComp
$EndSCHEMATC
