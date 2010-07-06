;---------------------------------------------------
XX93C46_For_EM78M611.H         EQU        XX93C46_For_EM78M611.H

;---------------------------------------------------
;  93C46 INSTRUCTION  COmmAND
;--------------------------------------------------
        READ        EQU     0X80    ;93C46 Read Command.
        WRITE       EQU     0X40    ;93C46 Write Command.
        ERASE       EQU     0XC0    ;93C46 Erase Command.
        EWEN        EQU     0X30    ;93C46 Erase/Write Enable Command.
        EWDS        EQU     0X00    ;93C46 Erase/Write Disable Command.
        ERAL        EQU     0X20    ;92C46 Erase All Command.
        WRAL        EQU     0X10    ;92C46 Write All Command.
;--------------------------------------------------