/*****************************************************************
* Filename     :  filter file
* Author       :  yu.wei
* Company      :  ELAN
* Version      :  1.0
* Creat date   :  2009-11-11 14:06:33
* tool ver.    :  WicePlus 2.7/eUIDE
* Description  :  build for cmos sensor samping filter
*****************************************************************/
;--------------------------------------------------------------
KalmanFilter.ASM     EQU    KalmanFilter.ASM

include "D:\include\lib\Arithmetic\KalmanFilter.H"

ifndef EM78CtrlIns.H
include "D:\include\EM78xx\EM78CtrlIns.H"
endif

ifndef EM78Math.H
include "D:\include\EM78xx\EM78Math.H"
endif

;--------------------------------------------------------------

	ORG    0X1C00    ;(PAGE7)
	MESSAGE "define 'KalmanFilter.ASM' ROM address"
;====================================================================
; Kalman Filter arithmetic
; input:
; output:
; description:
; date:
;====================================================================
KalmanFilter:



	RET