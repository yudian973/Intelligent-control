/*****************************************************************
* Filename     :  KalmanFilter.asm
* Author       :  yu.wei
* Company      :  ELAN
* Version      :  1.0
* Creat date   :  2009-12-31
* tool ver.    :  WicePlus 2.7/eUIDE
* Description  :  kalman filter file.for EM78P520N special
*                 build for cmos sensor samping filter,
*                 tradition kalman filter.
*****************************************************************/
;--------------------------------------------------------------
KalmanFilter.asm     EQU    KalmanFilter.asm

include "D:\include\EM78xx\Arithmetic\KalmanFilter.H"

ifndef EM78CtrlIns.H
include "D:\include\EM78xx\inc\EM78CtrlIns.h"
endif

ifndef EM78Math.H
include "D:\include\EM78xx\inc\EM78Math.H"
endif

;--------------------------------------------------------------

	ORG                 0X1C00    ;(PAGE7)
  if MassageDisplay == 1
	MESSAGE "define 'KalmanFilter.ASM' ROM address"
  endif
;====================================================================
; name:        Kalman Filter arithmetic one
; input:
; output:
; description: a single value input plane(Point)
;              X(k|k-1) = AX(k-1|k-1)+BU(k)+W(k)
;              P(k|k-1) = AP(k-1|k-1)A'+Q
;              X(k|k)   = X(k|k-1)+Kg(k)(Z(k)-H X(k|k-1))
;              Kg(k)    = P(k|k-1)H¡¯/(HP(k|k-1)H¡¯+R)
;              P(k|k)   = (I-Kg(k)H)P(k|k-1)
;====================================================================

;------------------------------------------------------
KF1_A                   EQU    @1
KF1_B                   EQU    @1
KF1_H                   EQU    @1
;------------------------------------------------------

KalmanFilter_1:
;   X(k|k-1) = AX(k-1|k-1)+BU(k)+W(k) |
;   A=1                               |
;   B=1                               | => X(k|k-1) = X(k-1|k-1)
;   U(k)=0                            |
;   W(k)=0                            |
	BANK                5
	;MOV                 A,X_kR1_kR1
	;MOV                 X_k_kR1,A

;   P(k|k-1) = AP(k-1|k-1)A'+Q        |
;   A=1                               | => P(k|k-1) = P(k-1|k-1)+Q
;   Q=cov(W(k),W(k))=                 |




	RET



;====================================================================
; name:        Kalman Filter arithmetic two
; input:
; output:
; description: a plane coordinate value(2D)
;              X(k|k-1) = AX(k-1|k-1)+BU(k)
;              P(k|k-1) = AP(k-1|k-1)A'+Q
;              X(k|k)   = X(k|k-1)+Kg(k)(Z(k)-H X(k|k-1))
;              Kg(k)    = P(k|k-1)H¡¯/(HP(k|k-1)H¡¯+R)
;              P(k|k)   = (I-Kg(k)H)P(k|k-1)
;====================================================================
	ORG                 0X1D00
;------------------------------------------------------
KF2_A:
	ADD                 PC,A
	RETL                @1
	RETL                @0
	RETL                @0
	RETL                @1
;                          | a11,a12 |
; A[4]={a11,a12,a31,a32} = |         |
;                          | a31,a32 |

KF2_B:
	ADD                 PC,A
	RETL                @1
	RETL                @0
	RETL                @0
	RETL                @1
;                          | b11,b12 |
; B[4]={b11,b12,b31,b32} = |         |
;                          | b31,b32 |

KF2_H:
	ADD                 PC,A
	RETL                @1
	RETL                @0
	RETL                @0
	RETL                @1
;                          | h11,h12 |
; H[4]={h11,h12,h31,h32} = |         |
;                          | h31,h32 |

;------------------------------------------------------

KalmanFilter_2:
	NOP
	NOP




	RET

;====================================================================
; name:        Kalman Filter arithmetic three
; input:
; output:
; description: a three-dimensional space value(3D)
;              X(k|k-1) = AX(k-1|k-1)+BU(k)
;              P(k|k-1) = AP(k-1|k-1)A'+Q
;              X(k|k)   = X(k|k-1)+Kg(k)(Z(k)-H X(k|k-1))
;              Kg(k)    = P(k|k-1)H¡¯/(HP(k|k-1)H¡¯+R)
;              P(k|k)   = (I-Kg(k)H)P(k|k-1)
;====================================================================
	ORG                 0X1E00
;------------------------------------------------------
KF3_A:
	ADD                 PC,A
	RETL                @1
	RETL                @0
	RETL                @0
	RETL                @0
	RETL                @1
	RETL                @0
	RETL                @0
	RETL                @0
	RETL                @1
;                                              | a11,a12,a13 |
; A[9]={a11,a12,a13,a21,a22,a23,a31,a32,a33} = | a21,a22,a23 |
;                                              | a31,a32,a33 |

KF3_B:
	ADD                 PC,A
	RETL                @1
	RETL                @0
	RETL                @0
	RETL                @0
	RETL                @1
	RETL                @0
	RETL                @0
	RETL                @0
	RETL                @1

KF3_H:
	ADD                 PC,A
	RETL                @1
	RETL                @0
	RETL                @0
	RETL                @0
	RETL                @1
	RETL                @0
	RETL                @0
	RETL                @0
	RETL                @1

;------------------------------------------------------

KalmanFilter_3:
	NOP
	NOP




	RET