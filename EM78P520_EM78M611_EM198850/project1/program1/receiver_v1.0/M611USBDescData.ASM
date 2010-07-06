;==================================================================
;  Tilte:       EM78M198810 include file		;
;  NAME:        EM198810_FOR_EM78M611.ASM
;  Description: The Definition of EM78M198810 for EM78612 Registers ;
;  Company:     Elan Electronic Corp.		;
;  Author:      YU.WEI				;
;  Date:        2009.02.26			;
;  Version:     v1.0				;
;  Tool:        wiceplus 2.7
;=========================================================================
M611USBDescData.ASM    EQU    M611USBDescData.ASM
		ORG 	0XC00	;PAGE 3
DEVICE_TABLE:
		TBL
		RETL	@0X12;01	bLength
		RETL	@0X01;02	bDescriptorType
		RETL	@0X10;03	bcdUSB
		RETL	@0X01;04
		RETL	@0X00;05	bDeviceCalss
		RETL	@0X00;06	bDeviceSubClass
		RETL	@0X00;07	bDeviceProtocol
		RETL	@0X08;08	bMaxPacketSize0 ,MCU point0 byte length
		RETL	@0XF3;09	idVendor 0X04F3
		RETL	@0X04;0A
		RETL	@0X1F;0B	idProduct (joystick:0x0f1f)
		RETL	@0X0F;0C
		RETL	@0X70;0D	bcdDevice v1.7.0
		RETL	@0X01;0E
		RETL	@0X01;0F	iManufacturer
		RETL	@0X02;10	iProduct
		RETL	@0X03;11	iSerialNumber
		RETL	@0X01;12	bNumConfigurations


CONFIG_TABLE:
		TBL
		;Configuration Descriptor
		RETL	@0X09;01	bLength
		RETL	@0X02;02	bDescritorType
		RETL	@0X22;03	wTotalLength
		RETL	@0X00;04
		RETL	@0X01;05	bConfigurationValue
		RETL	@0X01;06	bNumInterfaces
		RETL	@0X00;07	iConfiguration
		RETL	@0X80;08	bmAttributes
		RETL	@0X32;09	bMaxPower ,Imax=100mA

		;Interface Descriptor
		RETL	@0X09;0A	bLength
		RETL	@0X04;0B	bDescriptorType
		RETL	@0X00;0C	bInterfaceNumber
		RETL	@0X00;0D	bAlternateSetting
		RETL	@0X01;0E	bNumEndpoints
		RETL	@0X03;0F	bInterfaceClass (Class:HID)
		RETL	@0X00;10	bInterfaceSubClass (BOOT DEVICE)
		RETL	@0X00;11	bInterfaceProtocol (joystick)
		RETL	@0X00;12	iConfiguration

		;HID Descriptor
		RETL	@0X09;13	bLength
		RETL	@0X21;14	bDescriptorType
		RETL	@0X10;15	bcdHID
		RETL	@0X01;16
		RETL	@0X21;17	bCountryCode
		RETL	@0X01;18	bNumDescriptors
		RETL	@0X22;19	bDescriptorType. report descriptor:0x22, physics descriptor:0x23
		RETL	@0XF8;1A    bLength of the Report Descriptor 
		RETL	@0X01;1B

		;Endpoint Descriptor
		RETL	@0X07;1C	bLength
		RETL	@0X05;1D	bDescriptorType
		RETL	@0X81;1E	bEndpointAddress
		RETL	@0X03;1F	bmAttributes
		RETL	@0X08;20	wMaxPackerSize
		RETL	@0X00;21
		RETL	@0X05;22	bInterval    ;change 20ms


;---------------------------------------------------------------------
;---------------------------------------------------------------------
STRING0T:
		;String Descriptor Of Languages
		TBL
		RETL	@0X04;01	bLength
		RETL	@0X03;02	bdescriptorType
		RETL	@0X09;03
		RETL	@0X04;04	END OF LANGUAGES


;---------------------------------------------------------------------
;---------------------------------------------------------------------
		ORG         0XD00
HID_REPORT_TABLE1:
		;--REPORT DESCRIPTOR--
		TBL
	Begin_HID_Report_Table1:
		RETL	@0X05				;USAGE PAGE
		RETL	@0X01				;(GENERIC DESKTOP CONTROL)
		RETL	@0X09				;USAGE
		RETL	@0X04				;(JOYSTICK)
	;{
		RETL	@0XA1				;COLLECTION
		RETL	@0X01				;(APPLICATION)
		RETL	@0X85				;REPORT ID
		RETL	@0X01
		;{
			RETL	@0XA1				;COLLECTION
			RETL	@0X02				;(LOGICAL)
			RETL	@0X75				;REPORT_SIZE
			RETL	@0X08				;(8)
			RETL	@0X95				;REPORT_COUNT
			RETL	@0X04				;(4)
			RETL	@0X15				;LOGICAL_MIN
			RETL	@0X00				;(0)
			RETL	@0X26				;LOGICAL_MAX
			RETL	@0XFF				;(255)
			RETL	@0X00
			RETL	@0X35				;PHYSICAL_MIN
			RETL	@0X00				;(0)
			RETL	@0X46				;PHYSICAL_MAX
			RETL	@0XFF				;(255)
			RETL	@0X00
			
			RETL	@0X09				;USAGE
			RETL	@0X30				;(X)       ;Left-Right
			RETL	@0X09				;USAGE
			RETL	@0X31				;(Y)       ;Up-Down
			RETL	@0X09				;USAGE
			RETL	@0X35				;(Rz)	   ;Left-Right			
			RETL	@0X09				;USAGE
			RETL	@0X32				;(Z)       ;Up-Down
			RETL	@0X81				;INPUT
			RETL	@0X02				;(Data Ary,Abs)

			RETL	@0X65				;UNIT
			RETL	@0X00				;(None)
			RETL	@0X75				;REPORT_SIZE
			RETL	@0X01				;(1)
			RETL	@0X95				;REPORT_COUNT
			RETL	@0X0C				;(12)
			RETL	@0X25				;LOGICAL_MAX
			RETL	@0X01				;(1)
			RETL	@0X45				;PHYSICAL_MAX
			RETL	@0X01				;(1)
			RETL	@0X05				;USAGE_PAGE
			RETL	@0X09				;(BUTTON)
			RETL	@0X19				;USAGE_MIN
			RETL	@0X01				;(BUTTON1)
			RETL	@0X29				;USAGE_MAX
			RETL	@0X0C				;(BUTTON12)
			RETL	@0X81				;INPUT
			RETL	@0X02				;(Data,Var,Abs)
			
			RETL	@0X06				;USAGE_PAGE
			RETL	@0X01				;(Generic Desktop)
			RETL	@0X00
			RETL	@0X75				;REPORT_SIZE
			RETL	@0X01				;(1)
			RETL	@0X95				;REPORT_COUNT
			RETL	@0X08				;(8)
			RETL	@0X15				;LOGICAL_MAX
			RETL	@0X00				;(1)			
			RETL	@0X25				;LOGICAL_MAX
			RETL	@0X01				;(1)
			RETL	@0X45				;PHYSICAL_MAX
			RETL	@0X01				;(1)
			RETL	@0X81				;INPUT
			RETL	@0X01				;(Data Ary,Abs)			
			
			RETL	@0X75				;REPORT_SIZE
			RETL	@0X04				;(4)
			RETL	@0X95				;REPORT_COUNT
			RETL	@0X01				;(1)
			RETL	@0X25				;LOGICAL_MAX
			RETL	@0X07				;(7)
			RETL	@0X46				;PHYSICAL_MAX
			RETL	@0X3B				;(315)
			RETL	@0X01
			RETL	@0X65				;UNIT
			RETL	@0X14				;(Eng Rot:Angular Pos)
			RETL	@0X09				;USAGE
			RETL	@0X39				;(Hat Switch)
			RETL	@0X81				;INPUT
			RETL	@0X42				;(Data,Var,Abs,Null)
					
			RETL	@0XC0				;END COLLECTION
		;}
		RETL	@0XC0				;END COLLECTION  74
	;}

		;--REPORT DESCRIPTOR--
		RETL	@0X05				;USAGE PAGE
		RETL	@0X01				;(GENERIC DESKTOP CONTROL)
		RETL	@0X09				;USAGE
		RETL	@0X04				;(JOYSTICK)
	;{
		RETL	@0XA1				;COLLECTION
		RETL	@0X01				;(APPLICATION)
		RETL	@0X85				;REPORT ID
		RETL	@0X02
		;{
			RETL	@0XA1				;COLLECTION
			RETL	@0X02				;(LOGICAL)
			RETL	@0X75				;REPORT_SIZE
			RETL	@0X08				;(8)
			RETL	@0X95				;REPORT_COUNT
			RETL	@0X04				;(4)
			RETL	@0X15				;LOGICAL_MIN
			RETL	@0X00				;(0)
			RETL	@0X26				;LOGICAL_MAX
			RETL	@0XFF				;(255)
			RETL	@0X00
			RETL	@0X35				;PHYSICAL_MIN
			RETL	@0X00				;(0)
			RETL	@0X46				;PHYSICAL_MAX
			RETL	@0XFF				;(255)
			RETL	@0X00
			
			RETL	@0X09				;USAGE
			RETL	@0X30				;(X)       ;Left-Right
			RETL	@0X09				;USAGE
			RETL	@0X31				;(Y)       ;Up-Down
			RETL	@0X09				;USAGE
			RETL	@0X35				;(Rz)	   ;Left-Right			
			RETL	@0X09				;USAGE
			RETL	@0X32				;(Z)       ;Up-Down
			RETL	@0X81				;INPUT
			RETL	@0X02				;(Data Ary,Abs)

			RETL	@0X65				;UNIT
			RETL	@0X00				;(None)
			RETL	@0X75				;REPORT_SIZE
			RETL	@0X01				;(1)
			RETL	@0X95				;REPORT_COUNT
			RETL	@0X0C				;(12)
			RETL	@0X25				;LOGICAL_MAX
			RETL	@0X01				;(1)
			RETL	@0X45				;PHYSICAL_MAX
			RETL	@0X01				;(1)
			RETL	@0X05				;USAGE_PAGE
			RETL	@0X09				;(BUTTON)
			RETL	@0X19				;USAGE_MIN
			RETL	@0X01				;(BUTTON1)
			RETL	@0X29				;USAGE_MAX
			RETL	@0X0C				;(BUTTON12)
			RETL	@0X81				;INPUT
			RETL	@0X02				;(Data,Var,Abs)
			
			RETL	@0X06				;USAGE_PAGE
			RETL	@0X01				;(Generic Desktop)
			RETL	@0X00
			RETL	@0X75				;REPORT_SIZE
			RETL	@0X01				;(1)
			RETL	@0X95				;REPORT_COUNT
			RETL	@0X08				;(8)
			RETL	@0X15				;LOGICAL_MAX
			RETL	@0X00				;(1)			
			RETL	@0X25				;LOGICAL_MAX
			RETL	@0X01				;(1)
			RETL	@0X45				;PHYSICAL_MAX
			RETL	@0X01				;(1)
			RETL	@0X81				;INPUT
			RETL	@0X01				;(Data Ary,Abs)			
			
			RETL	@0X75				;REPORT_SIZE
			RETL	@0X04				;(4)
			RETL	@0X95				;REPORT_COUNT
			RETL	@0X01				;(1)
			RETL	@0X25				;LOGICAL_MAX
			RETL	@0X07				;(7)
			RETL	@0X46				;PHYSICAL_MAX
			RETL	@0X3B				;(315)
			RETL	@0X01
			RETL	@0X65				;UNIT
			RETL	@0X14				;(Eng Rot:Angular Pos)
			RETL	@0X09				;USAGE
			RETL	@0X39				;(Hat Switch)
			RETL	@0X81				;INPUT
			RETL	@0X42				;(Data,Var,Abs,Null)
					
			RETL	@0XC0				;END COLLECTION
		;}
		RETL	@0XC0				;END COLLECTION  74
	;}
	End_HID_Report_Table1:

;---------------------------------------------------------------------
;---------------------------------------------------------------------
		ORG         0XE00
HID_REPORT_TABLE2:
		TBL
	Begin_HID_Report_Table2:	         ;--REPORT DESCRIPTOR--
		RETL	@0X05				;USAGE PAGE
		RETL	@0X01				;(GENERIC DESKTOP CONTROL)
		RETL	@0X09				;USAGE
		RETL	@0X04				;(JOYSTICK)
	;{
		RETL	@0XA1				;COLLECTION
		RETL	@0X01				;(APPLICATION)
		RETL	@0X85				;REPORT ID
		RETL	@0X03
		;{
			RETL	@0XA1				;COLLECTION
			RETL	@0X02				;(LOGICAL)
			RETL	@0X75				;REPORT_SIZE
			RETL	@0X08				;(8)
			RETL	@0X95				;REPORT_COUNT
			RETL	@0X04				;(4)
			RETL	@0X15				;LOGICAL_MIN
			RETL	@0X00				;(0)
			RETL	@0X26				;LOGICAL_MAX
			RETL	@0XFF				;(255)
			RETL	@0X00
			RETL	@0X35				;PHYSICAL_MIN
			RETL	@0X00				;(0)
			RETL	@0X46				;PHYSICAL_MAX
			RETL	@0XFF				;(255)
			RETL	@0X00
			
			RETL	@0X09				;USAGE
			RETL	@0X30				;(X)       ;Left-Right
			RETL	@0X09				;USAGE
			RETL	@0X31				;(Y)       ;Up-Down
			RETL	@0X09				;USAGE
			RETL	@0X35				;(Rz)	   ;Left-Right			
			RETL	@0X09				;USAGE
			RETL	@0X32				;(Z)       ;Up-Down
			RETL	@0X81				;INPUT
			RETL	@0X02				;(Data Ary,Abs)

			RETL	@0X65				;UNIT
			RETL	@0X00				;(None)
			RETL	@0X75				;REPORT_SIZE
			RETL	@0X01				;(1)
			RETL	@0X95				;REPORT_COUNT
			RETL	@0X0C				;(12)
			RETL	@0X25				;LOGICAL_MAX
			RETL	@0X01				;(1)
			RETL	@0X45				;PHYSICAL_MAX
			RETL	@0X01				;(1)
			RETL	@0X05				;USAGE_PAGE
			RETL	@0X09				;(BUTTON)
			RETL	@0X19				;USAGE_MIN
			RETL	@0X01				;(BUTTON1)
			RETL	@0X29				;USAGE_MAX
			RETL	@0X0C				;(BUTTON12)
			RETL	@0X81				;INPUT
			RETL	@0X02				;(Data,Var,Abs)
			
			RETL	@0X06				;USAGE_PAGE
			RETL	@0X01				;(Generic Desktop)
			RETL	@0X00
			RETL	@0X75				;REPORT_SIZE
			RETL	@0X01				;(1)
			RETL	@0X95				;REPORT_COUNT
			RETL	@0X08				;(8)
			RETL	@0X15				;LOGICAL_MAX
			RETL	@0X00				;(1)			
			RETL	@0X25				;LOGICAL_MAX
			RETL	@0X01				;(1)
			RETL	@0X45				;PHYSICAL_MAX
			RETL	@0X01				;(1)
			RETL	@0X81				;INPUT
			RETL	@0X01				;(Data Ary,Abs)			
			
			RETL	@0X75				;REPORT_SIZE
			RETL	@0X04				;(4)
			RETL	@0X95				;REPORT_COUNT
			RETL	@0X01				;(1)
			RETL	@0X25				;LOGICAL_MAX
			RETL	@0X07				;(7)
			RETL	@0X46				;PHYSICAL_MAX
			RETL	@0X3B				;(315)
			RETL	@0X01
			RETL	@0X65				;UNIT
			RETL	@0X14				;(Eng Rot:Angular Pos)
			RETL	@0X09				;USAGE
			RETL	@0X39				;(Hat Switch)
			RETL	@0X81				;INPUT
			RETL	@0X42				;(Data,Var,Abs,Null)
					
			RETL	@0XC0				;END COLLECTION
		;}
		RETL	@0XC0				;END COLLECTION  74
	;}


		;--REPORT DESCRIPTOR--
		RETL	@0X05				;USAGE PAGE
		RETL	@0X01				;(GENERIC DESKTOP CONTROL)
		RETL	@0X09				;USAGE
		RETL	@0X04				;(JOYSTICK)
	;{
		RETL	@0XA1				;COLLECTION
		RETL	@0X01				;(APPLICATION)
		RETL	@0X85				;REPORT ID
		RETL	@0X04
		;{
			RETL	@0XA1				;COLLECTION
			RETL	@0X02				;(LOGICAL)
			RETL	@0X75				;REPORT_SIZE
			RETL	@0X08				;(8)
			RETL	@0X95				;REPORT_COUNT
			RETL	@0X04				;(4)
			RETL	@0X15				;LOGICAL_MIN
			RETL	@0X00				;(0)
			RETL	@0X26				;LOGICAL_MAX
			RETL	@0XFF				;(255)
			RETL	@0X00
			RETL	@0X35				;PHYSICAL_MIN
			RETL	@0X00				;(0)
			RETL	@0X46				;PHYSICAL_MAX
			RETL	@0XFF				;(255)
			RETL	@0X00
			
			RETL	@0X09				;USAGE
			RETL	@0X30				;(X)       ;Left-Right
			RETL	@0X09				;USAGE
			RETL	@0X31				;(Y)       ;Up-Down
			RETL	@0X09				;USAGE
			RETL	@0X35				;(Rz)	   ;Left-Right			
			RETL	@0X09				;USAGE
			RETL	@0X32				;(Z)       ;Up-Down
			RETL	@0X81				;INPUT
			RETL	@0X02				;(Data Ary,Abs)

			RETL	@0X65				;UNIT
			RETL	@0X00				;(None)
			RETL	@0X75				;REPORT_SIZE
			RETL	@0X01				;(1)
			RETL	@0X95				;REPORT_COUNT
			RETL	@0X0C				;(12)
			RETL	@0X25				;LOGICAL_MAX
			RETL	@0X01				;(1)
			RETL	@0X45				;PHYSICAL_MAX
			RETL	@0X01				;(1)
			RETL	@0X05				;USAGE_PAGE
			RETL	@0X09				;(BUTTON)
			RETL	@0X19				;USAGE_MIN
			RETL	@0X01				;(BUTTON1)
			RETL	@0X29				;USAGE_MAX
			RETL	@0X0C				;(BUTTON12)
			RETL	@0X81				;INPUT
			RETL	@0X02				;(Data,Var,Abs)
			
			RETL	@0X06				;USAGE_PAGE
			RETL	@0X01				;(Generic Desktop)
			RETL	@0X00
			RETL	@0X75				;REPORT_SIZE
			RETL	@0X01				;(1)
			RETL	@0X95				;REPORT_COUNT
			RETL	@0X08				;(8)
			RETL	@0X15				;LOGICAL_MAX
			RETL	@0X00				;(1)			
			RETL	@0X25				;LOGICAL_MAX
			RETL	@0X01				;(1)
			RETL	@0X45				;PHYSICAL_MAX
			RETL	@0X01				;(1)
			RETL	@0X81				;INPUT
			RETL	@0X01				;(Data Ary,Abs)			
			
			RETL	@0X75				;REPORT_SIZE
			RETL	@0X04				;(4)
			RETL	@0X95				;REPORT_COUNT
			RETL	@0X01				;(1)
			RETL	@0X25				;LOGICAL_MAX
			RETL	@0X07				;(7)
			RETL	@0X46				;PHYSICAL_MAX
			RETL	@0X3B				;(315)
			RETL	@0X01
			RETL	@0X65				;UNIT
			RETL	@0X14				;(Eng Rot:Angular Pos)
			RETL	@0X09				;USAGE
			RETL	@0X39				;(Hat Switch)
			RETL	@0X81				;INPUT
			RETL	@0X42				;(Data,Var,Abs,Null)
					
			RETL	@0XC0				;END COLLECTION
		;}
		RETL	@0XC0				;END COLLECTION  74
	;}
	End_HID_Report_Table2:

;---------------------------------------------------------------------
;---------------------------------------------------------------------
		ORG         0XF00
HID_REPORT_TABLE3:
		TBL
	Begin_HID_Report_Table3:          ;--REPORT DESCRIPTOR--
		RETL	@0X05				;USAGE PAGE
		RETL	@0X01				;(GENERIC DESKTOP CONTROL)
		RETL	@0X09				;USAGE
		RETL	@0X04				;(JOYSTICK)
	;{
		RETL	@0XA1				;COLLECTION
		RETL	@0X01				;(APPLICATION)
		RETL	@0X85				;REPORT ID
		RETL	@0X05
		;{
			RETL	@0XA1				;COLLECTION
			RETL	@0X02				;(LOGICAL)
			RETL	@0X75				;REPORT_SIZE
			RETL	@0X08				;(8)
			RETL	@0X95				;REPORT_COUNT
			RETL	@0X04				;(4)
			RETL	@0X15				;LOGICAL_MIN
			RETL	@0X00				;(0)
			RETL	@0X26				;LOGICAL_MAX
			RETL	@0XFF				;(255)
			RETL	@0X00
			RETL	@0X35				;PHYSICAL_MIN
			RETL	@0X00				;(0)
			RETL	@0X46				;PHYSICAL_MAX
			RETL	@0XFF				;(255)
			RETL	@0X00
			
			RETL	@0X09				;USAGE
			RETL	@0X30				;(X)       ;Left-Right
			RETL	@0X09				;USAGE
			RETL	@0X31				;(Y)       ;Up-Down
			RETL	@0X09				;USAGE
			RETL	@0X35				;(Rz)	   ;Left-Right			
			RETL	@0X09				;USAGE
			RETL	@0X32				;(Z)       ;Up-Down
			RETL	@0X81				;INPUT
			RETL	@0X02				;(Data Ary,Abs)

			RETL	@0X65				;UNIT
			RETL	@0X00				;(None)
			RETL	@0X75				;REPORT_SIZE
			RETL	@0X01				;(1)
			RETL	@0X95				;REPORT_COUNT
			RETL	@0X0C				;(12)
			RETL	@0X25				;LOGICAL_MAX
			RETL	@0X01				;(1)
			RETL	@0X45				;PHYSICAL_MAX
			RETL	@0X01				;(1)
			RETL	@0X05				;USAGE_PAGE
			RETL	@0X09				;(BUTTON)
			RETL	@0X19				;USAGE_MIN
			RETL	@0X01				;(BUTTON1)
			RETL	@0X29				;USAGE_MAX
			RETL	@0X0C				;(BUTTON12)
			RETL	@0X81				;INPUT
			RETL	@0X02				;(Data,Var,Abs)
			
			RETL	@0X06				;USAGE_PAGE
			RETL	@0X01				;(Generic Desktop)
			RETL	@0X00
			RETL	@0X75				;REPORT_SIZE
			RETL	@0X01				;(1)
			RETL	@0X95				;REPORT_COUNT
			RETL	@0X08				;(8)
			RETL	@0X15				;LOGICAL_MAX
			RETL	@0X00				;(1)			
			RETL	@0X25				;LOGICAL_MAX
			RETL	@0X01				;(1)
			RETL	@0X45				;PHYSICAL_MAX
			RETL	@0X01				;(1)
			RETL	@0X81				;INPUT
			RETL	@0X01				;(Data Ary,Abs)			
			
			RETL	@0X75				;REPORT_SIZE
			RETL	@0X04				;(4)
			RETL	@0X95				;REPORT_COUNT
			RETL	@0X01				;(1)
			RETL	@0X25				;LOGICAL_MAX
			RETL	@0X07				;(7)
			RETL	@0X46				;PHYSICAL_MAX
			RETL	@0X3B				;(315)
			RETL	@0X01
			RETL	@0X65				;UNIT
			RETL	@0X14				;(Eng Rot:Angular Pos)
			RETL	@0X09				;USAGE
			RETL	@0X39				;(Hat Switch)
			RETL	@0X81				;INPUT
			RETL	@0X42				;(Data,Var,Abs,Null)
					
			RETL	@0XC0				;END COLLECTION
		;}
		RETL	@0XC0				;END COLLECTION  74
	;}

		;--REPORT DESCRIPTOR--
		RETL	@0X05				;USAGE PAGE
		RETL	@0X01				;(GENERIC DESKTOP CONTROL)
		RETL	@0X09				;USAGE
		RETL	@0X04				;(JOYSTICK)
	;{
		RETL	@0XA1				;COLLECTION
		RETL	@0X01				;(APPLICATION)
		RETL	@0X85				;REPORT ID
		RETL	@0X06
		;{
			RETL	@0XA1				;COLLECTION
			RETL	@0X02				;(LOGICAL)
			RETL	@0X75				;REPORT_SIZE
			RETL	@0X08				;(8)
			RETL	@0X95				;REPORT_COUNT
			RETL	@0X04				;(4)
			RETL	@0X15				;LOGICAL_MIN
			RETL	@0X00				;(0)
			RETL	@0X26				;LOGICAL_MAX
			RETL	@0XFF				;(255)
			RETL	@0X00
			RETL	@0X35				;PHYSICAL_MIN
			RETL	@0X00				;(0)
			RETL	@0X46				;PHYSICAL_MAX
			RETL	@0XFF				;(255)
			RETL	@0X00
			
			RETL	@0X09				;USAGE
			RETL	@0X30				;(X)       ;Left-Right
			RETL	@0X09				;USAGE
			RETL	@0X31				;(Y)       ;Up-Down
			RETL	@0X09				;USAGE
			RETL	@0X35				;(Rz)	   ;Left-Right			
			RETL	@0X09				;USAGE
			RETL	@0X32				;(Z)       ;Up-Down
			RETL	@0X81				;INPUT
			RETL	@0X02				;(Data Ary,Abs)

			RETL	@0X65				;UNIT
			RETL	@0X00				;(None)
			RETL	@0X75				;REPORT_SIZE
			RETL	@0X01				;(1)
			RETL	@0X95				;REPORT_COUNT
			RETL	@0X0C				;(12)
			RETL	@0X25				;LOGICAL_MAX
			RETL	@0X01				;(1)
			RETL	@0X45				;PHYSICAL_MAX
			RETL	@0X01				;(1)
			RETL	@0X05				;USAGE_PAGE
			RETL	@0X09				;(BUTTON)
			RETL	@0X19				;USAGE_MIN
			RETL	@0X01				;(BUTTON1)
			RETL	@0X29				;USAGE_MAX
			RETL	@0X0C				;(BUTTON12)
			RETL	@0X81				;INPUT
			RETL	@0X02				;(Data,Var,Abs)
			
			RETL	@0X06				;USAGE_PAGE
			RETL	@0X01				;(Generic Desktop)
			RETL	@0X00
			RETL	@0X75				;REPORT_SIZE
			RETL	@0X01				;(1)
			RETL	@0X95				;REPORT_COUNT
			RETL	@0X08				;(8)
			RETL	@0X15				;LOGICAL_MAX
			RETL	@0X00				;(1)			
			RETL	@0X25				;LOGICAL_MAX
			RETL	@0X01				;(1)
			RETL	@0X45				;PHYSICAL_MAX
			RETL	@0X01				;(1)
			RETL	@0X81				;INPUT
			RETL	@0X01				;(Data Ary,Abs)			
			
			RETL	@0X75				;REPORT_SIZE
			RETL	@0X04				;(4)
			RETL	@0X95				;REPORT_COUNT
			RETL	@0X01				;(1)
			RETL	@0X25				;LOGICAL_MAX
			RETL	@0X07				;(7)
			RETL	@0X46				;PHYSICAL_MAX
			RETL	@0X3B				;(315)
			RETL	@0X01
			RETL	@0X65				;UNIT
			RETL	@0X14				;(Eng Rot:Angular Pos)
			RETL	@0X09				;USAGE
			RETL	@0X39				;(Hat Switch)
			RETL	@0X81				;INPUT
			RETL	@0X42				;(Data,Var,Abs,Null)
					
			RETL	@0XC0				;END COLLECTION
		;}
		RETL	@0XC0				;END COLLECTION  74
	;}
	End_HID_Report_Table3:


