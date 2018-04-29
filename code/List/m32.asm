
;CodeVisionAVR C Compiler V2.05.0 Professional
;(C) Copyright 1998-2010 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Chip type                : ATmega32A
;Program type             : Application
;Clock frequency          : 16.000000 MHz
;Memory model             : Small
;Optimize for             : Size
;(s)printf features       : int, width
;(s)scanf features        : int, width
;External RAM size        : 0
;Data Stack size          : 512 byte(s)
;Heap size                : 0 byte(s)
;Promote 'char' to 'int'  : Yes
;'char' is unsigned       : Yes
;8 bit enums              : Yes
;global 'const' stored in FLASH: No
;Enhanced core instructions    : On
;Smart register allocation     : On
;Automatic register allocation : On

	#pragma AVRPART ADMIN PART_NAME ATmega32A
	#pragma AVRPART MEMORY PROG_FLASH 32768
	#pragma AVRPART MEMORY EEPROM 1024
	#pragma AVRPART MEMORY INT_SRAM SIZE 2143
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x60

	#define CALL_SUPPORTED 1

	.LISTMAC
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU USR=0xB
	.EQU UDR=0xC
	.EQU SPSR=0xE
	.EQU SPDR=0xF
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU EECR=0x1C
	.EQU EEDR=0x1D
	.EQU EEARL=0x1E
	.EQU EEARH=0x1F
	.EQU WDTCR=0x21
	.EQU MCUCR=0x35
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F

	.DEF R0X0=R0
	.DEF R0X1=R1
	.DEF R0X2=R2
	.DEF R0X3=R3
	.DEF R0X4=R4
	.DEF R0X5=R5
	.DEF R0X6=R6
	.DEF R0X7=R7
	.DEF R0X8=R8
	.DEF R0X9=R9
	.DEF R0XA=R10
	.DEF R0XB=R11
	.DEF R0XC=R12
	.DEF R0XD=R13
	.DEF R0XE=R14
	.DEF R0XF=R15
	.DEF R0X10=R16
	.DEF R0X11=R17
	.DEF R0X12=R18
	.DEF R0X13=R19
	.DEF R0X14=R20
	.DEF R0X15=R21
	.DEF R0X16=R22
	.DEF R0X17=R23
	.DEF R0X18=R24
	.DEF R0X19=R25
	.DEF R0X1A=R26
	.DEF R0X1B=R27
	.DEF R0X1C=R28
	.DEF R0X1D=R29
	.DEF R0X1E=R30
	.DEF R0X1F=R31

	.EQU __SRAM_START=0x0060
	.EQU __SRAM_END=0x085F
	.EQU __DSTACK_SIZE=0x0200
	.EQU __HEAP_SIZE=0x0000
	.EQU __CLEAR_SRAM_SIZE=__SRAM_END-__SRAM_START+1

	.MACRO __CPD1N
	CPI  R30,LOW(@0)
	LDI  R26,HIGH(@0)
	CPC  R31,R26
	LDI  R26,BYTE3(@0)
	CPC  R22,R26
	LDI  R26,BYTE4(@0)
	CPC  R23,R26
	.ENDM

	.MACRO __CPD2N
	CPI  R26,LOW(@0)
	LDI  R30,HIGH(@0)
	CPC  R27,R30
	LDI  R30,BYTE3(@0)
	CPC  R24,R30
	LDI  R30,BYTE4(@0)
	CPC  R25,R30
	.ENDM

	.MACRO __CPWRR
	CP   R@0,R@2
	CPC  R@1,R@3
	.ENDM

	.MACRO __CPWRN
	CPI  R@0,LOW(@2)
	LDI  R30,HIGH(@2)
	CPC  R@1,R30
	.ENDM

	.MACRO __ADDB1MN
	SUBI R30,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDB2MN
	SUBI R26,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDW1MN
	SUBI R30,LOW(-@0-(@1))
	SBCI R31,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW2MN
	SUBI R26,LOW(-@0-(@1))
	SBCI R27,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	SBCI R22,BYTE3(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1N
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	SBCI R22,BYTE3(-@0)
	SBCI R23,BYTE4(-@0)
	.ENDM

	.MACRO __ADDD2N
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	SBCI R24,BYTE3(-@0)
	SBCI R25,BYTE4(-@0)
	.ENDM

	.MACRO __SUBD1N
	SUBI R30,LOW(@0)
	SBCI R31,HIGH(@0)
	SBCI R22,BYTE3(@0)
	SBCI R23,BYTE4(@0)
	.ENDM

	.MACRO __SUBD2N
	SUBI R26,LOW(@0)
	SBCI R27,HIGH(@0)
	SBCI R24,BYTE3(@0)
	SBCI R25,BYTE4(@0)
	.ENDM

	.MACRO __ANDBMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ANDI R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ANDD1N
	ANDI R30,LOW(@0)
	ANDI R31,HIGH(@0)
	ANDI R22,BYTE3(@0)
	ANDI R23,BYTE4(@0)
	.ENDM

	.MACRO __ANDD2N
	ANDI R26,LOW(@0)
	ANDI R27,HIGH(@0)
	ANDI R24,BYTE3(@0)
	ANDI R25,BYTE4(@0)
	.ENDM

	.MACRO __ORBMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ORI  R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ORD1N
	ORI  R30,LOW(@0)
	ORI  R31,HIGH(@0)
	ORI  R22,BYTE3(@0)
	ORI  R23,BYTE4(@0)
	.ENDM

	.MACRO __ORD2N
	ORI  R26,LOW(@0)
	ORI  R27,HIGH(@0)
	ORI  R24,BYTE3(@0)
	ORI  R25,BYTE4(@0)
	.ENDM

	.MACRO __DELAY_USB
	LDI  R24,LOW(@0)
__DELAY_USB_LOOP:
	DEC  R24
	BRNE __DELAY_USB_LOOP
	.ENDM

	.MACRO __DELAY_USW
	LDI  R24,LOW(@0)
	LDI  R25,HIGH(@0)
__DELAY_USW_LOOP:
	SBIW R24,1
	BRNE __DELAY_USW_LOOP
	.ENDM

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
	.ENDM

	.MACRO __PUTD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R31
	STD  Y+@0+2,R22
	STD  Y+@0+3,R23
	.ENDM

	.MACRO __PUTD2S
	STD  Y+@0,R26
	STD  Y+@0+1,R27
	STD  Y+@0+2,R24
	STD  Y+@0+3,R25
	.ENDM

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __CLRD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+(@1))
	LDI  R31,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	LDI  R22,BYTE3(2*@0+(@1))
	LDI  R23,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+(@2))
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+(@3))
	LDI  R@1,HIGH(@2+(@3))
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+(@3))
	LDI  R@1,HIGH(@2*2+(@3))
	.ENDM

	.MACRO __GETD1N
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __GETD2N
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __GETB1MN
	LDS  R30,@0+(@1)
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+(@1)
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	LDS  R22,@0+(@1)+2
	LDS  R23,@0+(@1)+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+(@2)
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+(@3)
	LDS  R@1,@2+(@3)+1
	.ENDM

	.MACRO __GETWRZ
	LDD  R@0,Z+@2
	LDD  R@1,Z+@2+1
	.ENDM

	.MACRO __GETD2Z
	LDD  R26,Z+@0
	LDD  R27,Z+@0+1
	LDD  R24,Z+@0+2
	LDD  R25,Z+@0+3
	.ENDM

	.MACRO __GETB2MN
	LDS  R26,@0+(@1)
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	LDS  R24,@0+(@1)+2
	LDS  R25,@0+(@1)+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+(@1),R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	STS  @0+(@1)+2,R22
	STS  @0+(@1)+3,R23
	.ENDM

	.MACRO __PUTB1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRD
	.ENDM

	.MACRO __PUTBR0MN
	STS  @0+(@1),R0
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+(@1),R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+(@1),R@2
	STS  @0+(@1)+1,R@3
	.ENDM

	.MACRO __PUTBZR
	STD  Z+@1,R@0
	.ENDM

	.MACRO __PUTWZR
	STD  Z+@2,R@0
	STD  Z+@2+1,R@1
	.ENDM

	.MACRO __GETW1R
	MOV  R30,R@0
	MOV  R31,R@1
	.ENDM

	.MACRO __GETW2R
	MOV  R26,R@0
	MOV  R27,R@1
	.ENDM

	.MACRO __GETWRN
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __PUTW1R
	MOV  R@0,R30
	MOV  R@1,R31
	.ENDM

	.MACRO __PUTW2R
	MOV  R@0,R26
	MOV  R@1,R27
	.ENDM

	.MACRO __ADDWRN
	SUBI R@0,LOW(-@2)
	SBCI R@1,HIGH(-@2)
	.ENDM

	.MACRO __ADDWRR
	ADD  R@0,R@2
	ADC  R@1,R@3
	.ENDM

	.MACRO __SUBWRN
	SUBI R@0,LOW(@2)
	SBCI R@1,HIGH(@2)
	.ENDM

	.MACRO __SUBWRR
	SUB  R@0,R@2
	SBC  R@1,R@3
	.ENDM

	.MACRO __ANDWRN
	ANDI R@0,LOW(@2)
	ANDI R@1,HIGH(@2)
	.ENDM

	.MACRO __ANDWRR
	AND  R@0,R@2
	AND  R@1,R@3
	.ENDM

	.MACRO __ORWRN
	ORI  R@0,LOW(@2)
	ORI  R@1,HIGH(@2)
	.ENDM

	.MACRO __ORWRR
	OR   R@0,R@2
	OR   R@1,R@3
	.ENDM

	.MACRO __EORWRR
	EOR  R@0,R@2
	EOR  R@1,R@3
	.ENDM

	.MACRO __GETWRS
	LDD  R@0,Y+@2
	LDD  R@1,Y+@2+1
	.ENDM

	.MACRO __PUTBSR
	STD  Y+@1,R@0
	.ENDM

	.MACRO __PUTWSR
	STD  Y+@2,R@0
	STD  Y+@2+1,R@1
	.ENDM

	.MACRO __MOVEWRR
	MOV  R@0,R@2
	MOV  R@1,R@3
	.ENDM

	.MACRO __INWR
	IN   R@0,@2
	IN   R@1,@2+1
	.ENDM

	.MACRO __OUTWR
	OUT  @2+1,R@1
	OUT  @2,R@0
	.ENDM

	.MACRO __CALL1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	CALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMRDW
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R26,SPL
	IN   R27,SPH
	ADIW R26,@0+1
	LD   R30,X+
	LD   R31,X
	.ENDM

	.MACRO __GETD1STACK
	IN   R26,SPL
	IN   R27,SPH
	ADIW R26,@0+1
	LD   R30,X+
	LD   R31,X+
	LD   R22,X
	.ENDM

	.MACRO __NBST
	BST  R@0,@1
	IN   R30,SREG
	LDI  R31,0x40
	EOR  R30,R31
	OUT  SREG,R30
	.ENDM


	.MACRO __PUTB1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOVW R26,R@0
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	CALL __PUTDP1
	.ENDM


	.MACRO __GETB1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R30,Z
	.ENDM

	.MACRO __GETB1HSX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	.ENDM

	.MACRO __GETW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z+
	LD   R23,Z
	MOVW R30,R0
	.ENDM

	.MACRO __GETB2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R26,X
	.ENDM

	.MACRO __GETW2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R1,X+
	LD   R24,X+
	LD   R25,X
	MOVW R26,R0
	.ENDM

	.MACRO __GETBRSX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	LD   R@0,Z
	.ENDM

	.MACRO __GETWRSX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	LD   R@0,Z+
	LD   R@1,Z
	.ENDM

	.MACRO __GETBRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	LD   R@0,X
	.ENDM

	.MACRO __GETWRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	LD   R@0,X+
	LD   R@1,X
	.ENDM

	.MACRO __LSLW8SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	CLR  R30
	.ENDM

	.MACRO __PUTB1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __CLRW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __CLRD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R30
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __PUTB2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R26
	.ENDM

	.MACRO __PUTW2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z,R27
	.ENDM

	.MACRO __PUTD2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z+,R27
	ST   Z+,R24
	ST   Z,R25
	.ENDM

	.MACRO __PUTBSRX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	ST   Z,R@0
	.ENDM

	.MACRO __PUTWSRX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	ST   Z+,R@0
	ST   Z,R@1
	.ENDM

	.MACRO __PUTB1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __MULBRR
	MULS R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRRU
	MUL  R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRR0
	MULS R@0,R@1
	.ENDM

	.MACRO __MULBRRU0
	MUL  R@0,R@1
	.ENDM

	.MACRO __MULBNWRU
	LDI  R26,@2
	MUL  R26,R@0
	MOVW R30,R0
	MUL  R26,R@1
	ADD  R31,R0
	.ENDM

;NAME DEFINITIONS FOR GLOBAL VARIABLES ALLOCATED TO REGISTERS
	.DEF _status=R5
	.DEF _i=R4
	.DEF _st=R7
	.DEF _menu_count=R6
	.DEF _tag_read_counter=R8
	.DEF _rx_wr_index=R11
	.DEF _rx_rd_index=R10
	.DEF _rx_counter=R13
	.DEF __lcd_x=R12

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	JMP  __RESET
	JMP  _ext_int0_isr
	JMP  _ext_int1_isr
	JMP  _ext_int2_isr
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  _timer1_compa_isr
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  _timer0_ovf_isr
	JMP  0x00
	JMP  _usart_rx_isr
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00

_tbl10_G102:
	.DB  0x10,0x27,0xE8,0x3,0x64,0x0,0xA,0x0
	.DB  0x1,0x0
_tbl16_G102:
	.DB  0x0,0x10,0x0,0x1,0x10,0x0,0x1,0x0

;REGISTER BIT VARIABLES INITIALIZATION
__REG_BIT_VARS:
	.DW  0x0000

_0xFA:
	.DB  0x1,0x0,0x0,0x0
_0x0:
	.DB  0x43,0x6C,0x65,0x61,0x72,0x20,0x53,0x75
	.DB  0x63,0x63,0x65,0x73,0x73,0x66,0x75,0x6C
	.DB  0x0,0x20,0x20,0x52,0x65,0x6D,0x6F,0x74
	.DB  0x65,0x20,0x73,0x65,0x74,0x20,0x21,0x0
	.DB  0x20,0x20,0x20,0x20,0x20,0x4C,0x4F,0x43
	.DB  0x4B,0x21,0x0,0x55,0x6E,0x6C,0x6F,0x63
	.DB  0x6B,0x20,0x74,0x61,0x67,0x20,0x43,0x6F
	.DB  0x64,0x65,0x3A,0x0,0x20,0x20,0x20,0x20
	.DB  0x55,0x4E,0x4C,0x4F,0x43,0x4B,0x20,0x21
	.DB  0x0,0x20,0x44,0x65,0x74,0x65,0x63,0x74
	.DB  0x65,0x64,0x20,0x43,0x6F,0x64,0x65,0x3A
	.DB  0x0,0x20,0x54,0x61,0x67,0x20,0x63,0x6F
	.DB  0x64,0x65,0x20,0x53,0x61,0x76,0x65,0x64
	.DB  0x21,0x0,0x20,0x20,0x54,0x61,0x67,0x20
	.DB  0x43,0x6C,0x65,0x61,0x72,0x65,0x64,0x21
	.DB  0x0,0x20,0x52,0x46,0x49,0x44,0x20,0x62
	.DB  0x61,0x73,0x65,0x64,0x20,0x43,0x61,0x72
	.DB  0x0,0x53,0x65,0x63,0x75,0x72,0x69,0x74
	.DB  0x79,0x20,0x20,0x53,0x79,0x73,0x74,0x65
	.DB  0x6D,0x0,0x20,0x20,0x20,0x57,0x72,0x6F
	.DB  0x6E,0x67,0x20,0x74,0x61,0x67,0x21,0x0
	.DB  0x20,0x20,0x20,0x53,0x65,0x74,0x20,0x52
	.DB  0x65,0x6D,0x6F,0x74,0x65,0x0,0x20,0x20
	.DB  0x43,0x6C,0x65,0x61,0x72,0x20,0x52,0x65
	.DB  0x6D,0x6F,0x74,0x65,0x0,0x20,0x20,0x53
	.DB  0x65,0x74,0x20,0x52,0x46,0x49,0x44,0x20
	.DB  0x54,0x61,0x67,0x0,0x20,0x43,0x6C,0x65
	.DB  0x61,0x72,0x20,0x52,0x46,0x49,0x44,0x20
	.DB  0x54,0x61,0x67,0x0,0x20,0x52,0x65,0x61
	.DB  0x64,0x20,0x52,0x46,0x49,0x44,0x20,0x54
	.DB  0x61,0x67,0x0,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x4C,0x6F,0x63,0x6B,0x0,0x20,0x20
	.DB  0x20,0x20,0x20,0x55,0x6E,0x6C,0x6F,0x63
	.DB  0x6B,0x0,0x20,0x50,0x72,0x65,0x73,0x73
	.DB  0x20,0x4C,0x6F,0x63,0x6B,0x20,0x6B,0x65
	.DB  0x79,0x0,0x20,0x20,0x20,0x4F,0x6E,0x20
	.DB  0x20,0x52,0x65,0x6D,0x6F,0x74,0x65,0x0
	.DB  0x20,0x20,0x20,0x20,0x77,0x61,0x69,0x74
	.DB  0x65,0x2E,0x2E,0x2E,0x0,0x57,0x61,0x69
	.DB  0x74,0x65,0x20,0x66,0x6F,0x72,0x20,0x54
	.DB  0x61,0x67,0x2E,0x2E,0x2E,0x0
_0x2000003:
	.DB  0x80,0xC0
_0x2020060:
	.DB  0x1
_0x2020000:
	.DB  0x2D,0x4E,0x41,0x4E,0x0,0x49,0x4E,0x46
	.DB  0x0

__GLOBAL_INI_TBL:
	.DW  0x01
	.DW  0x02
	.DW  __REG_BIT_VARS*2

	.DW  0x11
	.DW  _0x74
	.DW  _0x0*2

	.DW  0x0F
	.DW  _0x74+17
	.DW  _0x0*2+17

	.DW  0x0B
	.DW  _0x74+32
	.DW  _0x0*2+32

	.DW  0x11
	.DW  _0x74+43
	.DW  _0x0*2+43

	.DW  0x0D
	.DW  _0x74+60
	.DW  _0x0*2+60

	.DW  0x10
	.DW  _0x8B
	.DW  _0x0*2+73

	.DW  0x11
	.DW  _0x8B+16
	.DW  _0x0*2+89

	.DW  0x0F
	.DW  _0x8B+33
	.DW  _0x0*2+106

	.DW  0x10
	.DW  _0xAD
	.DW  _0x0*2+121

	.DW  0x11
	.DW  _0xAD+16
	.DW  _0x0*2+137

	.DW  0x0D
	.DW  _0xAD+33
	.DW  _0x0*2+60

	.DW  0x0E
	.DW  _0xAD+46
	.DW  _0x0*2+154

	.DW  0x0E
	.DW  _0xC3
	.DW  _0x0*2+168

	.DW  0x0F
	.DW  _0xC3+14
	.DW  _0x0*2+182

	.DW  0x0F
	.DW  _0xC3+29
	.DW  _0x0*2+197

	.DW  0x10
	.DW  _0xC3+44
	.DW  _0x0*2+212

	.DW  0x0F
	.DW  _0xC3+60
	.DW  _0x0*2+228

	.DW  0x0B
	.DW  _0xC3+75
	.DW  _0x0*2+243

	.DW  0x0C
	.DW  _0xC3+86
	.DW  _0x0*2+254

	.DW  0x10
	.DW  _0xCF
	.DW  _0x0*2+266

	.DW  0x0E
	.DW  _0xCF+16
	.DW  _0x0*2+282

	.DW  0x0D
	.DW  _0xCF+30
	.DW  _0x0*2+296

	.DW  0x11
	.DW  _0xCF+43
	.DW  _0x0*2+309

	.DW  0x11
	.DW  _0xCF+60
	.DW  _0x0*2+309

	.DW  0x11
	.DW  _0xCF+77
	.DW  _0x0*2+309

	.DW  0x0B
	.DW  _0xCF+94
	.DW  _0x0*2+32

	.DW  0x11
	.DW  _0xCF+105
	.DW  _0x0*2+43

	.DW  0x0D
	.DW  _0xCF+122
	.DW  _0x0*2+60

	.DW  0x04
	.DW  0x06
	.DW  _0xFA*2

	.DW  0x02
	.DW  __base_y_G100
	.DW  _0x2000003*2

	.DW  0x01
	.DW  __seed_G101
	.DW  _0x2020060*2

_0xFFFFFFFF:
	.DW  0

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  MCUCR,R31
	OUT  MCUCR,R30

;DISABLE WATCHDOG
	LDI  R31,0x18
	OUT  WDTCR,R31
	OUT  WDTCR,R30

;CLEAR R2-R14
	LDI  R24,(14-2)+1
	LDI  R26,2
	CLR  R27
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(__CLEAR_SRAM_SIZE)
	LDI  R25,HIGH(__CLEAR_SRAM_SIZE)
	LDI  R26,__SRAM_START
__CLEAR_SRAM:
	ST   X+,R30
	SBIW R24,1
	BRNE __CLEAR_SRAM

;GLOBAL VARIABLES INITIALIZATION
	LDI  R30,LOW(__GLOBAL_INI_TBL*2)
	LDI  R31,HIGH(__GLOBAL_INI_TBL*2)
__GLOBAL_INI_NEXT:
	LPM  R24,Z+
	LPM  R25,Z+
	SBIW R24,0
	BREQ __GLOBAL_INI_END
	LPM  R26,Z+
	LPM  R27,Z+
	LPM  R0,Z+
	LPM  R1,Z+
	MOVW R22,R30
	MOVW R30,R0
__GLOBAL_INI_LOOP:
	LPM  R0,Z+
	ST   X+,R0
	SBIW R24,1
	BRNE __GLOBAL_INI_LOOP
	MOVW R30,R22
	RJMP __GLOBAL_INI_NEXT
__GLOBAL_INI_END:

;HARDWARE STACK POINTER INITIALIZATION
	LDI  R30,LOW(__SRAM_END-__HEAP_SIZE)
	OUT  SPL,R30
	LDI  R30,HIGH(__SRAM_END-__HEAP_SIZE)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)
	LDI  R29,HIGH(__SRAM_START+__DSTACK_SIZE)

	JMP  _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x260

	.CSEG
;/*****************************************************
;This program was produced by the
;CodeWizardAVR V2.05.0 Professional
;Automatic Program Generator
;© Copyright 1998-2010 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com
;
;Project :
;Version :
;Date    : 2/7/2015
;Author  : NeVaDa
;Company :
;Comments:
;
;
;Chip type               : ATmega16
;Program type            : Application
;AVR Core Clock frequency: 16.000000 MHz
;Memory model            : Small
;External RAM size       : 0
;Data Stack size         : 256
;*****************************************************/
;
;#include <mega32.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
;#include <delay.h>
;#include <alcd.h>
;#include <stdlib.h>
;#include <stdio.h>
;
;#include "MFRC522.h"
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif

	.CSEG
_PcdReset:
	LDI  R30,LOW(1)
	ST   -Y,R30
	LDI  R30,LOW(15)
	ST   -Y,R30
	RCALL _WriteRawRC
	LDI  R30,LOW(17)
	ST   -Y,R30
	LDI  R30,LOW(61)
	ST   -Y,R30
	RCALL _WriteRawRC
	LDI  R30,LOW(45)
	ST   -Y,R30
	LDI  R30,LOW(30)
	ST   -Y,R30
	RCALL _WriteRawRC
	LDI  R30,LOW(44)
	CALL SUBOPT_0x0
	LDI  R30,LOW(42)
	ST   -Y,R30
	LDI  R30,LOW(141)
	ST   -Y,R30
	RCALL _WriteRawRC
	LDI  R30,LOW(43)
	ST   -Y,R30
	LDI  R30,LOW(62)
	ST   -Y,R30
	RCALL _WriteRawRC
	LDI  R30,LOW(21)
	ST   -Y,R30
	LDI  R30,LOW(64)
	ST   -Y,R30
	RCALL _WriteRawRC
	LDI  R30,LOW(0)
	RET
_PcdAntennaOn:
	ST   -Y,R17
;	i -> R17
	LDI  R30,LOW(20)
	CALL SUBOPT_0x1
	MOV  R30,R17
	ANDI R30,LOW(0x3)
	BRNE _0x3
	CALL SUBOPT_0x2
	RCALL _SetBitMask
_0x3:
	LD   R17,Y+
	RET
_PcdAntennaOff:
	CALL SUBOPT_0x2
	RCALL _ClearBitMask
	RET
_PcdRequest:
	SBIW R28,18
	CALL __SAVELOCR4
;	req_code -> Y+24
;	*pTagType -> Y+22
;	status -> R17
;	unLen -> R18,R19
;	ucComMF522Buf -> Y+4
	CALL SUBOPT_0x3
	ST   -Y,R30
	LDI  R30,LOW(7)
	ST   -Y,R30
	RCALL _WriteRawRC
	CALL SUBOPT_0x2
	RCALL _SetBitMask
	LDD  R30,Y+24
	STD  Y+4,R30
	LDI  R30,LOW(12)
	ST   -Y,R30
	MOVW R30,R28
	ADIW R30,5
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	MOVW R30,R28
	ADIW R30,8
	ST   -Y,R31
	ST   -Y,R30
	IN   R30,SPL
	IN   R31,SPH
	SBIW R30,1
	ST   -Y,R31
	ST   -Y,R30
	PUSH R19
	PUSH R18
	RCALL _PcdComMF522
	POP  R18
	POP  R19
	MOV  R17,R30
	CPI  R17,0
	BRNE _0x5
	LDI  R30,LOW(16)
	LDI  R31,HIGH(16)
	CP   R30,R18
	CPC  R31,R19
	BREQ _0x6
_0x5:
	RJMP _0x4
_0x6:
	LDD  R30,Y+4
	LDD  R26,Y+22
	LDD  R27,Y+22+1
	ST   X,R30
	LDD  R30,Y+5
	__PUTB1SNS 22,1
	RJMP _0x7
_0x4:
	LDI  R17,LOW(254)
_0x7:
	MOV  R30,R17
	CALL __LOADLOCR4
	ADIW R28,25
	RET
_PcdAnticoll:
	SBIW R28,18
	CALL __SAVELOCR6
;	*pSnr -> Y+24
;	status -> R17
;	i -> R16
;	snr_check -> R19
;	unLen -> R20,R21
;	ucComMF522Buf -> Y+6
	LDI  R19,0
	CALL SUBOPT_0x3
	CALL SUBOPT_0x0
	LDI  R30,LOW(14)
	CALL SUBOPT_0x4
	LDI  R30,LOW(147)
	STD  Y+6,R30
	LDI  R30,LOW(32)
	STD  Y+7,R30
	LDI  R30,LOW(12)
	ST   -Y,R30
	MOVW R30,R28
	ADIW R30,7
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(2)
	ST   -Y,R30
	MOVW R30,R28
	ADIW R30,10
	ST   -Y,R31
	ST   -Y,R30
	IN   R30,SPL
	IN   R31,SPH
	SBIW R30,1
	ST   -Y,R31
	ST   -Y,R30
	PUSH R21
	PUSH R20
	RCALL _PcdComMF522
	POP  R20
	POP  R21
	MOV  R17,R30
	CPI  R17,0
	BRNE _0x8
	LDI  R16,LOW(0)
_0xA:
	CPI  R16,4
	BRSH _0xB
	CALL SUBOPT_0x5
	MOVW R22,R30
	LDD  R26,Y+24
	LDD  R27,Y+24+1
	ADD  R30,R26
	ADC  R31,R27
	MOVW R0,R30
	MOVW R30,R22
	CALL SUBOPT_0x6
	MOVW R26,R0
	ST   X,R30
	CALL SUBOPT_0x5
	CALL SUBOPT_0x6
	EOR  R19,R30
	SUBI R16,-1
	RJMP _0xA
_0xB:
	CALL SUBOPT_0x5
	CALL SUBOPT_0x6
	CP   R30,R19
	BREQ _0xC
	LDI  R17,LOW(254)
_0xC:
_0x8:
	LDI  R30,LOW(14)
	CALL SUBOPT_0x7
	MOV  R30,R17
	CALL __LOADLOCR6
	ADIW R28,26
	RET
;	*pSnr -> Y+22
;	status -> R17
;	i -> R16
;	unLen -> R18,R19
;	ucComMF522Buf -> Y+4
;	auth_mode -> Y+27
;	addr -> Y+26
;	*pKey -> Y+24
;	*pSnr -> Y+22
;	status -> R17
;	unLen -> R18,R19
;	i -> R16
;	ucComMF522Buf -> Y+4
;	addr -> Y+24
;	*pData -> Y+22
;	status -> R17
;	unLen -> R18,R19
;	i -> R16
;	ucComMF522Buf -> Y+4
;	addr -> Y+24
;	*pData -> Y+22
;	status -> R17
;	unLen -> R18,R19
;	i -> R16
;	ucComMF522Buf -> Y+4
;	dd_mode -> Y+25
;	addr -> Y+24
;	*pValue -> Y+22
;	status -> R17
;	unLen -> R18,R19
;	i -> R16
;	ucComMF522Buf -> Y+4
;	sourceaddr -> Y+23
;	goaladdr -> Y+22
;	status -> R17
;	unLen -> R18,R19
;	ucComMF522Buf -> Y+4
;	status -> R17
;	unLen -> R18,R19
;	ucComMF522Buf -> Y+4
_PcdComMF522:
	SBIW R28,2
	CALL __SAVELOCR6
;	Command -> Y+15
;	*pInData -> Y+13
;	InLenByte -> Y+12
;	*pOutData -> Y+10
;	*pOutLenBit -> Y+8
;	status -> R17
;	irqEn -> R16
;	waitFor -> R19
;	lastBits -> R18
;	n -> R21
;	i -> Y+6
	LDI  R17,254
	LDI  R16,0
	LDI  R19,0
	LDD  R30,Y+15
	LDI  R31,0
	CPI  R30,LOW(0xE)
	LDI  R26,HIGH(0xE)
	CPC  R31,R26
	BRNE _0x46
	LDI  R16,LOW(18)
	LDI  R19,LOW(16)
	RJMP _0x45
_0x46:
	CPI  R30,LOW(0xC)
	LDI  R26,HIGH(0xC)
	CPC  R31,R26
	BRNE _0x48
	LDI  R16,LOW(119)
	LDI  R19,LOW(48)
_0x48:
_0x45:
	LDI  R30,LOW(2)
	ST   -Y,R30
	MOV  R30,R16
	ORI  R30,0x80
	ST   -Y,R30
	RCALL _WriteRawRC
	LDI  R30,LOW(4)
	CALL SUBOPT_0x4
	LDI  R30,LOW(1)
	CALL SUBOPT_0x0
	LDI  R30,LOW(10)
	CALL SUBOPT_0x7
	LDI  R30,LOW(0)
	STD  Y+6,R30
	STD  Y+6+1,R30
_0x4A:
	LDD  R30,Y+12
	CALL SUBOPT_0x8
	BRSH _0x4B
	LDI  R30,LOW(9)
	ST   -Y,R30
	LDD  R30,Y+7
	LDD  R31,Y+7+1
	LDD  R26,Y+14
	LDD  R27,Y+14+1
	ADD  R26,R30
	ADC  R27,R31
	LD   R30,X
	ST   -Y,R30
	RCALL _WriteRawRC
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ADIW R30,1
	STD  Y+6,R30
	STD  Y+6+1,R31
	RJMP _0x4A
_0x4B:
	LDI  R30,LOW(1)
	ST   -Y,R30
	LDD  R30,Y+16
	ST   -Y,R30
	RCALL _WriteRawRC
	LDD  R26,Y+15
	CPI  R26,LOW(0xC)
	BRNE _0x4C
	LDI  R30,LOW(13)
	CALL SUBOPT_0x7
_0x4C:
	LDI  R30,LOW(600)
	LDI  R31,HIGH(600)
	STD  Y+6,R30
	STD  Y+6+1,R31
_0x4E:
	LDI  R30,LOW(4)
	ST   -Y,R30
	RCALL _ReadRawRC
	MOV  R21,R30
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	SBIW R30,1
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	SBIW R26,0
	BREQ _0x50
	SBRC R21,0
	RJMP _0x50
	MOV  R30,R19
	AND  R30,R21
	BREQ _0x51
_0x50:
	RJMP _0x4F
_0x51:
	RJMP _0x4E
_0x4F:
	LDI  R30,LOW(13)
	CALL SUBOPT_0x4
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	SBIW R30,0
	BRNE PC+3
	JMP _0x52
	LDI  R30,LOW(6)
	ST   -Y,R30
	RCALL _ReadRawRC
	ANDI R30,LOW(0x1B)
	BREQ PC+3
	JMP _0x53
	LDI  R17,LOW(0)
	MOV  R30,R16
	AND  R30,R21
	ANDI R30,LOW(0x1)
	BREQ _0x54
	LDI  R17,LOW(255)
_0x54:
	LDD  R26,Y+15
	CPI  R26,LOW(0xC)
	BREQ PC+3
	JMP _0x55
	LDI  R30,LOW(10)
	ST   -Y,R30
	RCALL _ReadRawRC
	MOV  R21,R30
	LDI  R30,LOW(12)
	ST   -Y,R30
	RCALL _ReadRawRC
	ANDI R30,LOW(0x7)
	MOV  R18,R30
	CPI  R18,0
	BREQ _0x56
	MOV  R30,R21
	LDI  R31,0
	SBIW R30,1
	CALL __LSLW3
	MOVW R26,R30
	MOV  R30,R18
	LDI  R31,0
	ADD  R30,R26
	ADC  R31,R27
	RJMP _0xF4
_0x56:
	LDI  R30,LOW(8)
	MUL  R30,R21
	MOVW R30,R0
_0xF4:
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	ST   X+,R30
	ST   X,R31
	CPI  R21,0
	BRNE _0x58
	LDI  R21,LOW(1)
_0x58:
	CPI  R21,19
	BRLO _0x59
	LDI  R21,LOW(18)
_0x59:
	LDI  R30,LOW(0)
	STD  Y+6,R30
	STD  Y+6+1,R30
_0x5B:
	MOV  R30,R21
	CALL SUBOPT_0x8
	BRSH _0x5C
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	ADD  R30,R26
	ADC  R31,R27
	PUSH R31
	PUSH R30
	LDI  R30,LOW(9)
	ST   -Y,R30
	RCALL _ReadRawRC
	POP  R26
	POP  R27
	ST   X,R30
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ADIW R30,1
	STD  Y+6,R30
	STD  Y+6+1,R31
	RJMP _0x5B
_0x5C:
_0x55:
	RJMP _0x5D
_0x53:
	LDI  R17,LOW(254)
_0x5D:
_0x52:
	LDI  R30,LOW(12)
	CALL SUBOPT_0x7
	LDI  R30,LOW(1)
	CALL SUBOPT_0x0
	MOV  R30,R17
	CALL __LOADLOCR6
	ADIW R28,16
	RET
;	*pIndata -> Y+5
;	len -> Y+4
;	*pOutData -> Y+2
;	i -> R17
;	n -> R16
_WriteRawRC:
;	reg -> Y+1
;	value -> Y+0
	CBI  0x18,4
	LDD  R30,Y+1
	LSL  R30
	ST   -Y,R30
	CALL _spi
	LD   R30,Y
	ST   -Y,R30
	CALL _spi
	SBI  0x18,4
	JMP  _0x20E0003
_ReadRawRC:
;	reg -> Y+0
	CBI  0x18,4
	LD   R30,Y
	LSL  R30
	ORI  R30,0x80
	ST   -Y,R30
	CALL _spi
	LDI  R30,LOW(0)
	ST   -Y,R30
	CALL _spi
	ST   Y,R30
	SBI  0x18,4
	JMP  _0x20E0001
_SetBitMask:
	ST   -Y,R17
;	reg -> Y+2
;	mask -> Y+1
;	tmp -> R17
	LDD  R30,Y+2
	CALL SUBOPT_0x1
	LDD  R30,Y+1
	OR   R17,R30
	LDD  R30,Y+2
	ST   -Y,R30
	ST   -Y,R17
	RCALL _WriteRawRC
	JMP  _0x20E0002
_ClearBitMask:
	ST   -Y,R17
;	reg -> Y+2
;	mask -> Y+1
;	tmp -> R17
	LDD  R30,Y+2
	CALL SUBOPT_0x1
	LDD  R30,Y+1
	COM  R30
	AND  R17,R30
	LDD  R30,Y+2
	ST   -Y,R30
	ST   -Y,R17
	RCALL _WriteRawRC
	JMP  _0x20E0002
;
;
;
;void int0_on();
;void int0_off();
;
;void int1_on();
;void int1_off();
;
;void int2_on();
;void int2_off();
;
;void menu();
;void sub_menu();
;
;void siren_on();
;void siren_off();
;
;void dor_lock();
;void dor_unlock();
;
;void beep();
;  bit lock=0;
; unsigned char status,i;
; unsigned char st=0;
;unsigned char g_ucTempbuf[20];
;
;#define ledg PORTD.6
;#define ledr PORTD.7
;
;#define in1 PORTB.0
;#define in2 PORTB.1
;
;#define en PORTA.7
;
;#define rfid_rst PORTB.3
;
; unsigned char menu_count=1;
; unsigned int tag_read_counter=0;
; eeprom  unsigned char tag_code[4];
;
;#ifndef RXB8
;#define RXB8 1
;#endif
;
;#ifndef TXB8
;#define TXB8 0
;#endif
;
;#ifndef UPE
;#define UPE 2
;#endif
;
;#ifndef DOR
;#define DOR 3
;#endif
;
;#ifndef FE
;#define FE 4
;#endif
;
;#ifndef UDRE
;#define UDRE 5
;#endif
;
;#ifndef RXC
;#define RXC 7
;#endif
;
;#define FRAMING_ERROR (1<<FE)
;#define PARITY_ERROR (1<<UPE)
;#define DATA_OVERRUN (1<<DOR)
;#define DATA_REGISTER_EMPTY (1<<UDRE)
;#define RX_COMPLETE (1<<RXC)
;
;// USART Receiver buffer
;#define RX_BUFFER_SIZE 8
;char rx_buffer[RX_BUFFER_SIZE];
;
;#if RX_BUFFER_SIZE <= 256
;unsigned char rx_wr_index,rx_rd_index,rx_counter;
;#else
;unsigned int rx_wr_index,rx_rd_index,rx_counter;
;#endif
;
;// This flag is set on USART Receiver buffer overflow
;bit rx_buffer_overflow;
;
;// USART Receiver interrupt service routine
;interrupt [USART_RXC] void usart_rx_isr(void)
; 0000 0079 {
_usart_rx_isr:
	CALL SUBOPT_0x9
; 0000 007A unsigned char s[4];
; 0000 007B char status,data;
; 0000 007C status=UCSRA;
	ST   -Y,R17
	ST   -Y,R16
;	s -> Y+2
;	status -> R17
;	data -> R16
	IN   R17,11
; 0000 007D data=UDR;
	IN   R16,12
; 0000 007E if ((status & (FRAMING_ERROR | PARITY_ERROR | DATA_OVERRUN))==0)
	MOV  R30,R17
	ANDI R30,LOW(0x1C)
	BRNE _0x6E
; 0000 007F    {
; 0000 0080    rx_buffer[rx_wr_index++]=data;
	MOV  R30,R11
	INC  R11
	LDI  R31,0
	SUBI R30,LOW(-_rx_buffer)
	SBCI R31,HIGH(-_rx_buffer)
	ST   Z,R16
; 0000 0081 #if RX_BUFFER_SIZE == 256
; 0000 0082    // special case for receiver buffer size=256
; 0000 0083    if (++rx_counter == 0)
; 0000 0084       {
; 0000 0085 #else
; 0000 0086    if (rx_wr_index == RX_BUFFER_SIZE) rx_wr_index=0;
	LDI  R30,LOW(8)
	CP   R30,R11
	BRNE _0x6F
	CLR  R11
; 0000 0087    if (++rx_counter == RX_BUFFER_SIZE)
_0x6F:
	INC  R13
	LDI  R30,LOW(8)
	CP   R30,R13
	BRNE _0x70
; 0000 0088       {
; 0000 0089       rx_counter=0;
	CLR  R13
; 0000 008A #endif
; 0000 008B       rx_buffer_overflow=1;
	SET
	BLD  R2,1
; 0000 008C       }
; 0000 008D    }
_0x70:
; 0000 008E    if (rx_buffer[0]=='*' && rx_buffer[1]=='c'&& rx_buffer[2]=='c' ) {
_0x6E:
	LDS  R26,_rx_buffer
	CPI  R26,LOW(0x2A)
	BRNE _0x72
	__GETB2MN _rx_buffer,1
	CPI  R26,LOW(0x63)
	BRNE _0x72
	__GETB2MN _rx_buffer,2
	CPI  R26,LOW(0x63)
	BREQ _0x73
_0x72:
	RJMP _0x71
_0x73:
; 0000 008F    lcd_clear();
	CALL _lcd_clear
; 0000 0090    lcd_puts("Clear Successful");
	__POINTW1MN _0x74,0
	CALL SUBOPT_0xA
; 0000 0091    delay_ms(1500);
	LDI  R30,LOW(1500)
	LDI  R31,HIGH(1500)
	CALL SUBOPT_0xB
; 0000 0092    menu_count--;
	DEC  R6
; 0000 0093    menu();
	RJMP _0xF5
; 0000 0094    }
; 0000 0095    else if (rx_buffer[0]=='*' && rx_buffer[1]=='w')
_0x71:
	LDS  R26,_rx_buffer
	CPI  R26,LOW(0x2A)
	BRNE _0x77
	__GETB2MN _rx_buffer,1
	CPI  R26,LOW(0x77)
	BREQ _0x78
_0x77:
	RJMP _0x76
_0x78:
; 0000 0096    {lcd_clear();
	CALL _lcd_clear
; 0000 0097    lcd_puts("  Remote set !");
	__POINTW1MN _0x74,17
	CALL SUBOPT_0xA
; 0000 0098    }
; 0000 0099    else   if  (rx_buffer[0]=='#' ) {
	RJMP _0x79
_0x76:
	LDS  R26,_rx_buffer
	CPI  R26,LOW(0x23)
	BREQ PC+3
	JMP _0x7A
; 0000 009A 
; 0000 009B    if (rx_buffer[2]==2&& lock==0){
	__GETB2MN _rx_buffer,2
	CPI  R26,LOW(0x2)
	BRNE _0x7C
	LDI  R26,0
	SBRC R2,0
	LDI  R26,1
	CPI  R26,LOW(0x0)
	BREQ _0x7D
_0x7C:
	RJMP _0x7B
_0x7D:
; 0000 009C     lcd_puts("     LOCK!");
	__POINTW1MN _0x74,32
	CALL SUBOPT_0xA
; 0000 009D 
; 0000 009E      dor_lock();
	CALL SUBOPT_0xC
; 0000 009F   delay_ms(10);
; 0000 00A0   GIFR=0xE0;
	CALL SUBOPT_0xD
; 0000 00A1   lock=1;
; 0000 00A2   int0_on();
; 0000 00A3   int1_on();
; 0000 00A4         lcd_clear();
; 0000 00A5          lcd_puts("Unlock tag Code:");
	__POINTW1MN _0x74,43
	CALL SUBOPT_0xA
; 0000 00A6          lcd_gotoxy(0,1);
	CALL SUBOPT_0xE
; 0000 00A7          itoa(tag_code[0],s);
	CALL SUBOPT_0xF
	CALL SUBOPT_0x10
; 0000 00A8          lcd_puts(s);
; 0000 00A9          lcd_gotoxy(4,1);
	CALL SUBOPT_0x11
; 0000 00AA          itoa(tag_code[1],s);
	CALL SUBOPT_0x12
	CALL SUBOPT_0x10
; 0000 00AB          lcd_puts(s);
; 0000 00AC          lcd_gotoxy(8,1);
	CALL SUBOPT_0x13
; 0000 00AD          itoa(tag_code[2],s);
	CALL SUBOPT_0x14
	CALL SUBOPT_0x10
; 0000 00AE          lcd_puts(s);
; 0000 00AF          lcd_gotoxy(12,1);
	CALL SUBOPT_0x15
; 0000 00B0          itoa(tag_code[3],s);
	CALL SUBOPT_0x16
	CALL SUBOPT_0x10
; 0000 00B1          lcd_puts(s);
; 0000 00B2          }
; 0000 00B3   else if (rx_buffer[2]==4 && lock==1) {
	RJMP _0x7E
_0x7B:
	__GETB2MN _rx_buffer,2
	CPI  R26,LOW(0x4)
	BRNE _0x80
	SBRC R2,0
	RJMP _0x81
_0x80:
	RJMP _0x7F
_0x81:
; 0000 00B4    siren_off();
	RCALL _siren_off
; 0000 00B5    lcd_clear();
	CALL _lcd_clear
; 0000 00B6   lcd_puts("    UNLOCK !");
	__POINTW1MN _0x74,60
	CALL SUBOPT_0xA
; 0000 00B7   ledr=0;
	CALL SUBOPT_0x17
; 0000 00B8   lock=0;
; 0000 00B9   GIFR=0xE0;
; 0000 00BA   int0_off();
; 0000 00BB   int1_off();
; 0000 00BC   dor_unlock();
; 0000 00BD   delay_ms(1000);
	LDI  R30,LOW(1000)
	LDI  R31,HIGH(1000)
	CALL SUBOPT_0xB
; 0000 00BE   menu_count=1;
	LDI  R30,LOW(1)
	MOV  R6,R30
; 0000 00BF 
; 0000 00C0   menu();
_0xF5:
	RCALL _menu
; 0000 00C1   }
; 0000 00C2  }
_0x7F:
_0x7E:
; 0000 00C3 }
_0x7A:
_0x79:
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,6
	RJMP _0xF9

	.DSEG
_0x74:
	.BYTE 0x49
;
;#ifndef _DEBUG_TERMINAL_IO_
;// Get a character from the USART Receiver buffer
;#define _ALTERNATE_GETCHAR_
;#pragma used+
;char getchar(void)
; 0000 00CA {

	.CSEG
; 0000 00CB char data;
; 0000 00CC while (rx_counter==0);
;	data -> R17
; 0000 00CD data=rx_buffer[rx_rd_index++];
; 0000 00CE #if RX_BUFFER_SIZE != 256
; 0000 00CF if (rx_rd_index == RX_BUFFER_SIZE) rx_rd_index=0;
; 0000 00D0 #endif
; 0000 00D1 #asm("cli")
; 0000 00D2 --rx_counter;
; 0000 00D3 #asm("sei")
; 0000 00D4 return data;
; 0000 00D5 }
;#pragma used-
;#endif
;
;
;
;
;
;interrupt [TIM0_OVF] void timer0_ovf_isr(void)
; 0000 00DE {
_timer0_ovf_isr:
	CALL SUBOPT_0x9
; 0000 00DF unsigned char s[4];
; 0000 00E0 
; 0000 00E1 status = PcdRequest(PICC_REQALL, g_ucTempbuf);
;	s -> Y+0
	CALL SUBOPT_0x18
; 0000 00E2         if (status != MI_OK)
	BREQ _0x88
; 0000 00E3          {
; 0000 00E4             PcdReset();
	RCALL _PcdReset
; 0000 00E5             delay_ms(1);
	CALL SUBOPT_0x19
; 0000 00E6             PcdAntennaOff();
	RCALL _PcdAntennaOff
; 0000 00E7             delay_ms(1);
	CALL SUBOPT_0x19
; 0000 00E8             PcdAntennaOn();
	RCALL _PcdAntennaOn
; 0000 00E9             delay_ms(1);
	CALL SUBOPT_0x19
; 0000 00EA              }
; 0000 00EB 
; 0000 00EC 
; 0000 00ED 	   else{
	RJMP _0x89
_0x88:
; 0000 00EE 
; 0000 00EF         status = PcdAnticoll(g_ucTempbuf);
	CALL SUBOPT_0x1A
; 0000 00F0         if (status == MI_OK)
	BREQ PC+3
	JMP _0x8A
; 0000 00F1         {
; 0000 00F2         lcd_clear();
	CALL _lcd_clear
; 0000 00F3          lcd_puts(" Detected Code:");
	__POINTW1MN _0x8B,0
	CALL SUBOPT_0xA
; 0000 00F4          lcd_gotoxy(0,1);
	CALL SUBOPT_0xE
; 0000 00F5          itoa(g_ucTempbuf[0],s);
	LDS  R30,_g_ucTempbuf
	CALL SUBOPT_0x1B
; 0000 00F6          lcd_puts(s);
; 0000 00F7          lcd_gotoxy(4,1);
	CALL SUBOPT_0x11
; 0000 00F8          itoa(g_ucTempbuf[1],s);
	__GETB1MN _g_ucTempbuf,1
	CALL SUBOPT_0x1B
; 0000 00F9          lcd_puts(s);
; 0000 00FA          lcd_gotoxy(8,1);
	CALL SUBOPT_0x13
; 0000 00FB          itoa(g_ucTempbuf[2],s);
	__GETB1MN _g_ucTempbuf,2
	CALL SUBOPT_0x1B
; 0000 00FC          lcd_puts(s);
; 0000 00FD          lcd_gotoxy(12,1);
	CALL SUBOPT_0x15
; 0000 00FE          itoa(g_ucTempbuf[3],s);
	__GETB1MN _g_ucTempbuf,3
	CALL SUBOPT_0x1B
; 0000 00FF          lcd_puts(s);
; 0000 0100          beep();
	RCALL _beep
; 0000 0101          TCCR0=0x00;
	LDI  R30,LOW(0)
	OUT  0x33,R30
; 0000 0102          delay_ms(2000);
	CALL SUBOPT_0x1C
; 0000 0103          if (st==1){
	LDI  R30,LOW(1)
	CP   R30,R7
	BRNE _0x8C
; 0000 0104          tag_code[0]=g_ucTempbuf[0];
	LDS  R30,_g_ucTempbuf
	LDI  R26,LOW(_tag_code)
	LDI  R27,HIGH(_tag_code)
	CALL SUBOPT_0x1D
; 0000 0105          delay_ms(10);
; 0000 0106          tag_code[1]=g_ucTempbuf[1];
	__POINTW2MN _tag_code,1
	__GETB1MN _g_ucTempbuf,1
	CALL SUBOPT_0x1D
; 0000 0107          delay_ms(10);
; 0000 0108          tag_code[2]=g_ucTempbuf[2];
	__POINTW2MN _tag_code,2
	__GETB1MN _g_ucTempbuf,2
	CALL SUBOPT_0x1D
; 0000 0109          delay_ms(10);
; 0000 010A          tag_code[3]=g_ucTempbuf[3];
	__POINTW2MN _tag_code,3
	__GETB1MN _g_ucTempbuf,3
	CALL SUBOPT_0x1D
; 0000 010B          delay_ms(10);
; 0000 010C          lcd_clear();
	CALL _lcd_clear
; 0000 010D          lcd_puts(" Tag code Saved!");
	__POINTW1MN _0x8B,16
	RJMP _0xF6
; 0000 010E          st=0;
; 0000 010F          delay_ms(2000);
; 0000 0110          menu_count--;
; 0000 0111          }
; 0000 0112          else if (st==2)
_0x8C:
	LDI  R30,LOW(2)
	CP   R30,R7
	BRNE _0x8E
; 0000 0113          {
; 0000 0114          tag_code[0]=0;
	LDI  R26,LOW(_tag_code)
	LDI  R27,HIGH(_tag_code)
	LDI  R30,LOW(0)
	CALL SUBOPT_0x1D
; 0000 0115          delay_ms(10);
; 0000 0116          tag_code[1]=0;
	__POINTW2MN _tag_code,1
	LDI  R30,LOW(0)
	CALL SUBOPT_0x1D
; 0000 0117          delay_ms(10);
; 0000 0118          tag_code[2]=0;
	__POINTW2MN _tag_code,2
	LDI  R30,LOW(0)
	CALL SUBOPT_0x1D
; 0000 0119          delay_ms(10);
; 0000 011A          tag_code[3]=0;
	__POINTW2MN _tag_code,3
	LDI  R30,LOW(0)
	CALL SUBOPT_0x1D
; 0000 011B          delay_ms(10);
; 0000 011C          lcd_clear();
	CALL _lcd_clear
; 0000 011D          lcd_puts("  Tag Cleared!");
	__POINTW1MN _0x8B,33
_0xF6:
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_puts
; 0000 011E          st=0;
	CLR  R7
; 0000 011F          delay_ms(2000);
	CALL SUBOPT_0x1C
; 0000 0120          menu_count--;
	DEC  R6
; 0000 0121          }
; 0000 0122          menu_count--;
_0x8E:
	DEC  R6
; 0000 0123          menu();
	RCALL _menu
; 0000 0124          }
; 0000 0125          }
_0x8A:
_0x89:
; 0000 0126    if (tag_read_counter<400) tag_read_counter++;
	LDI  R30,LOW(400)
	LDI  R31,HIGH(400)
	CP   R8,R30
	CPC  R9,R31
	BRSH _0x8F
	MOVW R30,R8
	ADIW R30,1
	MOVW R8,R30
; 0000 0127    else {
	RJMP _0x90
_0x8F:
; 0000 0128         TCCR0=0x00;
	CALL SUBOPT_0x1E
; 0000 0129         TCNT0=0x00;
; 0000 012A         OCR0=0x00;
; 0000 012B         st=0;
	CLR  R7
; 0000 012C        menu_count--;
	DEC  R6
; 0000 012D        menu();
	RCALL _menu
; 0000 012E        }
_0x90:
; 0000 012F 
; 0000 0130 }
	ADIW R28,4
	RJMP _0xF9

	.DSEG
_0x8B:
	.BYTE 0x30
;
;interrupt [EXT_INT2] void ext_int2_isr(void)
; 0000 0133 {

	.CSEG
_ext_int2_isr:
	ST   -Y,R0
	ST   -Y,R1
	ST   -Y,R15
	ST   -Y,R22
	ST   -Y,R23
	ST   -Y,R24
	ST   -Y,R25
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 0134 
; 0000 0135 TCCR0=0x00;
	CALL SUBOPT_0x1E
; 0000 0136 TCNT0=0x00;
; 0000 0137 OCR0=0x00;
; 0000 0138 delay_ms(500);
	LDI  R30,LOW(500)
	LDI  R31,HIGH(500)
	CALL SUBOPT_0xB
; 0000 0139 menu();
	RCALL _menu
; 0000 013A 
; 0000 013B }
	RJMP _0xF9
;
;interrupt [EXT_INT0] void ext_int0_isr(void)
; 0000 013E {
_ext_int0_isr:
; 0000 013F int0_off();
; 0000 0140 int1_off();
; 0000 0141 siren_on();
; 0000 0142 }
;
;interrupt [EXT_INT1] void ext_int1_isr(void)
; 0000 0145 {
_ext_int1_isr:
_0xF8:
	ST   -Y,R0
	ST   -Y,R1
	ST   -Y,R15
	ST   -Y,R22
	ST   -Y,R23
	ST   -Y,R24
	ST   -Y,R25
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 0146 int0_off();
	RCALL _int0_off
; 0000 0147 int1_off();
	RCALL _int1_off
; 0000 0148 siren_on();
	RCALL _siren_on
; 0000 0149 }
_0xF9:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	LD   R25,Y+
	LD   R24,Y+
	LD   R23,Y+
	LD   R22,Y+
	LD   R15,Y+
	LD   R1,Y+
	LD   R0,Y+
	RETI
;
;
;interrupt [TIM1_COMPA] void timer1_compa_isr(void)
; 0000 014D {
_timer1_compa_isr:
	ST   -Y,R26
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 014E   if (OCR1A<500) OCR1A=OCR1A+1;
	IN   R30,0x2A
	IN   R31,0x2A+1
	CPI  R30,LOW(0x1F4)
	LDI  R26,HIGH(0x1F4)
	CPC  R31,R26
	BRSH _0x91
	IN   R30,0x2A
	IN   R31,0x2A+1
	ADIW R30,1
	RJMP _0xF7
; 0000 014F   else OCR1A=0xa0;
_0x91:
	LDI  R30,LOW(160)
	LDI  R31,HIGH(160)
_0xF7:
	OUT  0x2A+1,R31
	OUT  0x2A,R30
; 0000 0150 
; 0000 0151 }
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R26,Y+
	RETI
;
;void main(void)
; 0000 0154 {
_main:
; 0000 0155 char s[4];
; 0000 0156 
; 0000 0157 int j;
; 0000 0158 
; 0000 0159 
; 0000 015A 
; 0000 015B PORTA=0x00;
	SBIW R28,4
;	s -> Y+0
;	j -> R16,R17
	LDI  R30,LOW(0)
	OUT  0x1B,R30
; 0000 015C DDRA=0x00;
	OUT  0x1A,R30
; 0000 015D DDRA.7=1;
	SBI  0x1A,7
; 0000 015E 
; 0000 015F 
; 0000 0160 PORTB=0x00;
	OUT  0x18,R30
; 0000 0161 DDRB=0x00;
	OUT  0x17,R30
; 0000 0162 DDRB.0=1;
	SBI  0x17,0
; 0000 0163 DDRB.1=1;
	SBI  0x17,1
; 0000 0164 DDRB.3=1;
	SBI  0x17,3
; 0000 0165 DDRB.4=1;
	SBI  0x17,4
; 0000 0166 DDRB.5=1;
	SBI  0x17,5
; 0000 0167 DDRB.7=1;
	SBI  0x17,7
; 0000 0168 rfid_rst=0;
	CBI  0x18,3
; 0000 0169 
; 0000 016A PORTC=0x00;
	OUT  0x15,R30
; 0000 016B DDRC=0x00;
	OUT  0x14,R30
; 0000 016C 
; 0000 016D PORTD=0x00;
	OUT  0x12,R30
; 0000 016E DDRD=0x00;
	OUT  0x11,R30
; 0000 016F DDRD.5=1;
	SBI  0x11,5
; 0000 0170 
; 0000 0171 DDRD.6=1;
	SBI  0x11,6
; 0000 0172 DDRD.7=1;
	SBI  0x11,7
; 0000 0173 
; 0000 0174 // Timer/Counter 0 initialization
; 0000 0175 // Clock source: System Clock
; 0000 0176 // Clock value: Timer 0 Stopped
; 0000 0177 // Mode: Normal top=0xFF
; 0000 0178 // OC0 output: Disconnected
; 0000 0179 TCCR0=0x00;
	CALL SUBOPT_0x1E
; 0000 017A TCNT0=0x00;
; 0000 017B OCR0=0x00;
; 0000 017C 
; 0000 017D // Timer/Counter 1 initialization
; 0000 017E // Clock source: System Clock
; 0000 017F // Clock value: Timer1 Stopped
; 0000 0180 // Mode: Normal top=0xFFFF
; 0000 0181 // OC1A output: Discon.
; 0000 0182 // OC1B output: Discon.
; 0000 0183 // Noise Canceler: Off
; 0000 0184 // Input Capture on Falling Edge
; 0000 0185 // Timer1 Overflow Interrupt: Off
; 0000 0186 // Input Capture Interrupt: Off
; 0000 0187 // Compare A Match Interrupt: Off
; 0000 0188 // Compare B Match Interrupt: Off
; 0000 0189 //TCCR1A=0x40;
; 0000 018A //TCCR1B=0x0B;
; 0000 018B TCNT1H=0x00;
	LDI  R30,LOW(0)
	OUT  0x2D,R30
; 0000 018C TCNT1L=0x00;
	OUT  0x2C,R30
; 0000 018D ICR1H=0x00;
	OUT  0x27,R30
; 0000 018E ICR1L=0x00;
	OUT  0x26,R30
; 0000 018F //OCR1A=0xa0;
; 0000 0190 OCR1BH=0x00;
	OUT  0x29,R30
; 0000 0191 OCR1BL=0x00;
	OUT  0x28,R30
; 0000 0192 
; 0000 0193 // Timer/Counter 2 initialization
; 0000 0194 // Clock source: System Clock
; 0000 0195 // Clock value: Timer2 Stopped
; 0000 0196 // Mode: Normal top=0xFF
; 0000 0197 // OC2 output: Disconnected
; 0000 0198 ASSR=0x00;
	OUT  0x22,R30
; 0000 0199 TCCR2=0x00;
	OUT  0x25,R30
; 0000 019A TCNT2=0x00;
	OUT  0x24,R30
; 0000 019B OCR2=0x00;
	OUT  0x23,R30
; 0000 019C 
; 0000 019D // External Interrupt(s) initialization
; 0000 019E // INT0: Off
; 0000 019F // INT1: Off
; 0000 01A0 // INT2: Off
; 0000 01A1 GICR=0x00;
	OUT  0x3B,R30
; 0000 01A2 MCUCR=0x0A;
	LDI  R30,LOW(10)
	OUT  0x35,R30
; 0000 01A3 MCUCSR=0x00;
	LDI  R30,LOW(0)
	OUT  0x34,R30
; 0000 01A4 GIFR=0x00;
	OUT  0x3A,R30
; 0000 01A5 
; 0000 01A6 // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 01A7 TIMSK=0x11;
	LDI  R30,LOW(17)
	OUT  0x39,R30
; 0000 01A8 
; 0000 01A9 // USART initialization
; 0000 01AA // Communication Parameters: 8 Data, 1 Stop, No Parity
; 0000 01AB // USART Receiver: On
; 0000 01AC // USART Transmitter: On
; 0000 01AD // USART Mode: Asynchronous
; 0000 01AE // USART Baud Rate: 600
; 0000 01AF UCSRA=0x00;
	LDI  R30,LOW(0)
	OUT  0xB,R30
; 0000 01B0 UCSRB=0x98;
	LDI  R30,LOW(152)
	OUT  0xA,R30
; 0000 01B1 UCSRC=0x06;
	LDI  R30,LOW(6)
	OUT  0x20,R30
; 0000 01B2 UBRRH=0x06;
	OUT  0x20,R30
; 0000 01B3 UBRRL=0x82;
	LDI  R30,LOW(130)
	OUT  0x9,R30
; 0000 01B4 
; 0000 01B5 
; 0000 01B6 ACSR=0x80;
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 01B7 SFIOR=0x00;
	LDI  R30,LOW(0)
	OUT  0x30,R30
; 0000 01B8 
; 0000 01B9 
; 0000 01BA ADCSRA=0x00;
	OUT  0x6,R30
; 0000 01BB 
; 0000 01BC // SPI initialization
; 0000 01BD // SPI Type: Master
; 0000 01BE // SPI Clock Rate: 125.000 kHz
; 0000 01BF // SPI Clock Phase: Cycle Start
; 0000 01C0 // SPI Clock Polarity: Low
; 0000 01C1 // SPI Data Order: MSB First
; 0000 01C2 SPCR=0x53;
	LDI  R30,LOW(83)
	OUT  0xD,R30
; 0000 01C3 SPSR=0x00;
	LDI  R30,LOW(0)
	OUT  0xE,R30
; 0000 01C4 
; 0000 01C5 // TWI initialization
; 0000 01C6 // TWI disabled
; 0000 01C7 TWCR=0x00;
	OUT  0x36,R30
; 0000 01C8 
; 0000 01C9 
; 0000 01CA 
; 0000 01CB #asm("sei")
	sei
; 0000 01CC 
; 0000 01CD rfid_rst=0;
	CBI  0x18,3
; 0000 01CE delay_ms(100);
	CALL SUBOPT_0x1F
; 0000 01CF rfid_rst=1;
	SBI  0x18,3
; 0000 01D0 delay_ms(100);
	CALL SUBOPT_0x1F
; 0000 01D1 status=PcdReset();
	RCALL _PcdReset
	MOV  R5,R30
; 0000 01D2 
; 0000 01D3 lcd_init(16);
	LDI  R30,LOW(16)
	ST   -Y,R30
	CALL _lcd_init
; 0000 01D4 
; 0000 01D5 lcd_clear();
	CALL _lcd_clear
; 0000 01D6 lcd_puts(" RFID based Car");
	__POINTW1MN _0xAD,0
	CALL SUBOPT_0xA
; 0000 01D7 lcd_gotoxy(0,1);
	CALL SUBOPT_0xE
; 0000 01D8 lcd_puts("Security  System");
	__POINTW1MN _0xAD,16
	CALL SUBOPT_0xA
; 0000 01D9 
; 0000 01DA int2_on();
	RCALL _int2_on
; 0000 01DB while(1){
_0xAE:
; 0000 01DC 
; 0000 01DD if (lock==1){
	SBRS R2,0
	RJMP _0xB1
; 0000 01DE      ledr=~ledr;
	SBIS 0x12,7
	RJMP _0xB2
	CBI  0x12,7
	RJMP _0xB3
_0xB2:
	SBI  0x12,7
_0xB3:
; 0000 01DF status = PcdRequest(PICC_REQALL, g_ucTempbuf);
	CALL SUBOPT_0x18
; 0000 01E0         if (status != MI_OK)
	BREQ _0xB4
; 0000 01E1          {
; 0000 01E2             PcdReset();
	RCALL _PcdReset
; 0000 01E3             delay_ms(100);
	CALL SUBOPT_0x1F
; 0000 01E4             PcdAntennaOff();
	RCALL _PcdAntennaOff
; 0000 01E5             delay_ms(100);
	CALL SUBOPT_0x1F
; 0000 01E6             PcdAntennaOn();
	RCALL _PcdAntennaOn
; 0000 01E7             delay_ms(100);
	CALL SUBOPT_0x1F
; 0000 01E8              }
; 0000 01E9 
; 0000 01EA 
; 0000 01EB 	   else{
	RJMP _0xB5
_0xB4:
; 0000 01EC 
; 0000 01ED         status = PcdAnticoll(g_ucTempbuf);
	CALL SUBOPT_0x1A
; 0000 01EE         if (status == MI_OK)
	BRNE _0xB6
; 0000 01EF         {
; 0000 01F0         if (g_ucTempbuf[0]==tag_code[0] && g_ucTempbuf[1]==tag_code[1] &&
; 0000 01F1         g_ucTempbuf[2]==tag_code[2] && g_ucTempbuf[3]==tag_code[3]  ){
	CALL SUBOPT_0xF
	LDS  R26,_g_ucTempbuf
	CP   R30,R26
	BRNE _0xB8
	CALL SUBOPT_0x12
	__GETB2MN _g_ucTempbuf,1
	CP   R30,R26
	BRNE _0xB8
	CALL SUBOPT_0x14
	__GETB2MN _g_ucTempbuf,2
	CP   R30,R26
	BRNE _0xB8
	CALL SUBOPT_0x16
	__GETB2MN _g_ucTempbuf,3
	CP   R30,R26
	BREQ _0xB9
_0xB8:
	RJMP _0xB7
_0xB9:
; 0000 01F2         siren_off();
	RCALL _siren_off
; 0000 01F3         int0_off();
	RCALL _int0_off
; 0000 01F4         int1_off();
	RCALL _int1_off
; 0000 01F5         GIFR=0xE0;
	LDI  R30,LOW(224)
	OUT  0x3A,R30
; 0000 01F6         lcd_clear();
	RCALL _lcd_clear
; 0000 01F7          lcd_puts("    UNLOCK !");
	__POINTW1MN _0xAD,33
	CALL SUBOPT_0xA
; 0000 01F8          lock=0;
	CLT
	BLD  R2,0
; 0000 01F9          ledr=0;
	CBI  0x12,7
; 0000 01FA          dor_unlock();
	RCALL _dor_unlock
; 0000 01FB          delay_ms(2000);
	CALL SUBOPT_0x1C
; 0000 01FC          menu();
	RCALL _menu
; 0000 01FD          }
; 0000 01FE          else {
	RJMP _0xBC
_0xB7:
; 0000 01FF                  lcd_clear();
	RCALL _lcd_clear
; 0000 0200                 lcd_puts("   Wrong tag!");
	__POINTW1MN _0xAD,46
	CALL SUBOPT_0xA
; 0000 0201                 }
_0xBC:
; 0000 0202          }
; 0000 0203          }
_0xB6:
_0xB5:
; 0000 0204          }
; 0000 0205 }
_0xB1:
	RJMP _0xAE
; 0000 0206 }
_0xBD:
	RJMP _0xBD

	.DSEG
_0xAD:
	.BYTE 0x3C
;
;
;void int0_on(){
; 0000 0209 void int0_on(){

	.CSEG
_int0_on:
; 0000 020A 
; 0000 020B GICR|=0x40;
	IN   R30,0x3B
	ORI  R30,0x40
	RJMP _0x20E0006
; 0000 020C 
; 0000 020D }
;
;void int0_off(){
; 0000 020F void int0_off(){
_int0_off:
; 0000 0210 GICR&=0xA0;
	IN   R30,0x3B
	ANDI R30,LOW(0xA0)
	RJMP _0x20E0006
; 0000 0211 
; 0000 0212 }
;
;void int1_on(){
; 0000 0214 void int1_on(){
_int1_on:
; 0000 0215 GICR|=0x80;
	IN   R30,0x3B
	ORI  R30,0x80
	RJMP _0x20E0006
; 0000 0216 }
;
;void int1_off(){
; 0000 0218 void int1_off(){
_int1_off:
; 0000 0219 GICR&=0x60;
	IN   R30,0x3B
	ANDI R30,LOW(0x60)
	RJMP _0x20E0006
; 0000 021A 
; 0000 021B }
;
;void int2_on(){
; 0000 021D void int2_on(){
_int2_on:
; 0000 021E GICR|=0x20;
	IN   R30,0x3B
	ORI  R30,0x20
_0x20E0006:
	OUT  0x3B,R30
; 0000 021F }
	RET
;
;void int2_off(){
; 0000 0221 void int2_off(){
; 0000 0222 GICR&=0xDF;
; 0000 0223 
; 0000 0224 }
;
;void menu(){
; 0000 0226 void menu(){
_menu:
; 0000 0227 if (PINB.2==1){
	SBIS 0x16,2
	RJMP _0xBE
; 0000 0228 lcd_clear();
	CALL SUBOPT_0x20
; 0000 0229 switch (menu_count)
; 0000 022A {
; 0000 022B case 1:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0xC2
; 0000 022C   lcd_puts("   Set Remote");
	__POINTW1MN _0xC3,0
	CALL SUBOPT_0xA
; 0000 022D   menu_count++;
	INC  R6
; 0000 022E   break;
	RJMP _0xC1
; 0000 022F case 2:
_0xC2:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0xC4
; 0000 0230    lcd_puts("  Clear Remote");
	__POINTW1MN _0xC3,14
	CALL SUBOPT_0xA
; 0000 0231    menu_count++;
	INC  R6
; 0000 0232    break;
	RJMP _0xC1
; 0000 0233 case 3:
_0xC4:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0xC5
; 0000 0234    lcd_puts("  Set RFID Tag");
	__POINTW1MN _0xC3,29
	CALL SUBOPT_0xA
; 0000 0235    menu_count++;
	INC  R6
; 0000 0236    break;
	RJMP _0xC1
; 0000 0237 case 4:
_0xC5:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0xC6
; 0000 0238    lcd_puts(" Clear RFID Tag");
	__POINTW1MN _0xC3,44
	CALL SUBOPT_0xA
; 0000 0239    menu_count++;
	INC  R6
; 0000 023A    break;
	RJMP _0xC1
; 0000 023B case 5:
_0xC6:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BRNE _0xC7
; 0000 023C    lcd_puts(" Read RFID Tag");
	__POINTW1MN _0xC3,60
	CALL SUBOPT_0xA
; 0000 023D    menu_count++;
	INC  R6
; 0000 023E    break;
	RJMP _0xC1
; 0000 023F case 6:
_0xC7:
	CPI  R30,LOW(0x6)
	LDI  R26,HIGH(0x6)
	CPC  R31,R26
	BRNE _0xC8
; 0000 0240    lcd_puts("      Lock");
	__POINTW1MN _0xC3,75
	CALL SUBOPT_0xA
; 0000 0241    menu_count++;
	INC  R6
; 0000 0242    break;
	RJMP _0xC1
; 0000 0243 case 7:
_0xC8:
	CPI  R30,LOW(0x7)
	LDI  R26,HIGH(0x7)
	CPC  R31,R26
	BRNE _0xC1
; 0000 0244    lcd_puts("     Unlock");
	__POINTW1MN _0xC3,86
	CALL SUBOPT_0xA
; 0000 0245    menu_count=1;
	LDI  R30,LOW(1)
	MOV  R6,R30
; 0000 0246    break;
; 0000 0247     }
_0xC1:
; 0000 0248  }
; 0000 0249 else {
	RJMP _0xCA
_0xBE:
; 0000 024A delay_ms(500);
	LDI  R30,LOW(500)
	LDI  R31,HIGH(500)
	CALL SUBOPT_0xB
; 0000 024B sub_menu();
	RCALL _sub_menu
; 0000 024C }
_0xCA:
; 0000 024D }
	RET

	.DSEG
_0xC3:
	.BYTE 0x62
;
;void sub_menu(){
; 0000 024F void sub_menu(){

	.CSEG
_sub_menu:
; 0000 0250 unsigned char s[4];
; 0000 0251 lcd_clear();
	SBIW R28,4
;	s -> Y+0
	CALL SUBOPT_0x20
; 0000 0252 switch (menu_count)
; 0000 0253 {
; 0000 0254 case 2:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0xCE
; 0000 0255   lcd_puts(" Press Lock key");
	__POINTW1MN _0xCF,0
	CALL SUBOPT_0xA
; 0000 0256   lcd_gotoxy(0,1);
	CALL SUBOPT_0xE
; 0000 0257   lcd_puts("   On  Remote");
	__POINTW1MN _0xCF,16
	CALL SUBOPT_0xA
; 0000 0258   UDR='0';
	LDI  R30,LOW(48)
	OUT  0xC,R30
; 0000 0259   break;
	RJMP _0xCD
; 0000 025A case 3:
_0xCE:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0xD0
; 0000 025B   lcd_puts("    waite...");
	__POINTW1MN _0xCF,30
	CALL SUBOPT_0xA
; 0000 025C   UDR='6';
	LDI  R30,LOW(54)
	OUT  0xC,R30
; 0000 025D   break;
	RJMP _0xCD
; 0000 025E case 4:
_0xD0:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0xD1
; 0000 025F   lcd_puts("Waite for Tag...");
	__POINTW1MN _0xCF,43
	CALL SUBOPT_0xA
; 0000 0260   tag_read_counter=0;
	CLR  R8
	CLR  R9
; 0000 0261   st=1;
	LDI  R30,LOW(1)
	CALL SUBOPT_0x21
; 0000 0262   TIMSK|=0x01;
; 0000 0263   TCCR0=0x05;
; 0000 0264   break;
	RJMP _0xCD
; 0000 0265 
; 0000 0266 case 5:
_0xD1:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BRNE _0xD2
; 0000 0267   lcd_puts("Waite for Tag...");
	__POINTW1MN _0xCF,60
	CALL SUBOPT_0xA
; 0000 0268   tag_read_counter=0;
	CLR  R8
	CLR  R9
; 0000 0269   st=2;
	LDI  R30,LOW(2)
	CALL SUBOPT_0x21
; 0000 026A   TIMSK|=0x01;
; 0000 026B   TCCR0=0x05;
; 0000 026C   break;
	RJMP _0xCD
; 0000 026D 
; 0000 026E 
; 0000 026F    case 6:
_0xD2:
	CPI  R30,LOW(0x6)
	LDI  R26,HIGH(0x6)
	CPC  R31,R26
	BRNE _0xD3
; 0000 0270   lcd_puts("Waite for Tag...");
	__POINTW1MN _0xCF,77
	CALL SUBOPT_0xA
; 0000 0271   tag_read_counter=0;
	CLR  R8
	CLR  R9
; 0000 0272   st=0;
	CLR  R7
; 0000 0273   TIMSK|=0x01;
	IN   R30,0x39
	ORI  R30,1
	OUT  0x39,R30
; 0000 0274   TCCR0=0x05;
	LDI  R30,LOW(5)
	OUT  0x33,R30
; 0000 0275   break;
	RJMP _0xCD
; 0000 0276 
; 0000 0277    case 7:
_0xD3:
	CPI  R30,LOW(0x7)
	LDI  R26,HIGH(0x7)
	CPC  R31,R26
	BRNE _0xD4
; 0000 0278   lcd_puts("     LOCK!");
	__POINTW1MN _0xCF,94
	CALL SUBOPT_0xA
; 0000 0279 
; 0000 027A   dor_lock();
	CALL SUBOPT_0xC
; 0000 027B   delay_ms(10);
; 0000 027C   GIFR=0xE0;
	CALL SUBOPT_0xD
; 0000 027D   lock=1;
; 0000 027E   int0_on();
; 0000 027F   int1_on();
; 0000 0280         lcd_clear();
; 0000 0281          lcd_puts("Unlock tag Code:");
	__POINTW1MN _0xCF,105
	CALL SUBOPT_0xA
; 0000 0282          lcd_gotoxy(0,1);
	CALL SUBOPT_0xE
; 0000 0283          itoa(tag_code[0],s);
	CALL SUBOPT_0xF
	CALL SUBOPT_0x1B
; 0000 0284          lcd_puts(s);
; 0000 0285          lcd_gotoxy(4,1);
	CALL SUBOPT_0x11
; 0000 0286          itoa(tag_code[1],s);
	CALL SUBOPT_0x12
	CALL SUBOPT_0x1B
; 0000 0287          lcd_puts(s);
; 0000 0288          lcd_gotoxy(8,1);
	CALL SUBOPT_0x13
; 0000 0289          itoa(tag_code[2],s);
	CALL SUBOPT_0x14
	CALL SUBOPT_0x1B
; 0000 028A          lcd_puts(s);
; 0000 028B          lcd_gotoxy(12,1);
	CALL SUBOPT_0x15
; 0000 028C          itoa(tag_code[3],s);
	CALL SUBOPT_0x16
	CALL SUBOPT_0x1B
; 0000 028D          lcd_puts(s);
; 0000 028E 
; 0000 028F   break;
	RJMP _0xCD
; 0000 0290 
; 0000 0291   case 1:
_0xD4:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0xCD
; 0000 0292   siren_off();
	RCALL _siren_off
; 0000 0293   lcd_puts("    UNLOCK !");
	__POINTW1MN _0xCF,122
	CALL SUBOPT_0xA
; 0000 0294   ledr=0;
	CALL SUBOPT_0x17
; 0000 0295   lock=0;
; 0000 0296   GIFR=0xE0;
; 0000 0297   int0_off();
; 0000 0298   int1_off();
; 0000 0299   dor_unlock();
; 0000 029A   menu();
	RCALL _menu
; 0000 029B   break;
; 0000 029C    }
_0xCD:
; 0000 029D 
; 0000 029E }
	ADIW R28,4
	RET

	.DSEG
_0xCF:
	.BYTE 0x87
;
;void siren_on(){
; 0000 02A0 void siren_on(){

	.CSEG
_siren_on:
; 0000 02A1 TCCR1A=0x40;
	CALL SUBOPT_0x22
; 0000 02A2 TCCR1B=0x0B;
; 0000 02A3 OCR1A=0xa0;
	LDI  R30,LOW(160)
	LDI  R31,HIGH(160)
	OUT  0x2A+1,R31
	OUT  0x2A,R30
; 0000 02A4 
; 0000 02A5 TIMSK|=0x11;
	IN   R30,0x39
	ORI  R30,LOW(0x11)
	RJMP _0x20E0005
; 0000 02A6 }
;
;void siren_off(){
; 0000 02A8 void siren_off(){
_siren_off:
; 0000 02A9 TCCR1A=0x00;
	CALL SUBOPT_0x23
; 0000 02AA TCCR1B=0x00;
; 0000 02AB OCR1A=0x00;
; 0000 02AC 
; 0000 02AD TIMSK&=0xEE;
	IN   R30,0x39
	ANDI R30,LOW(0xEE)
_0x20E0005:
	OUT  0x39,R30
; 0000 02AE }
	RET
;
;void beep(){
; 0000 02B0 void beep(){
_beep:
; 0000 02B1 ledg=1;
	SBI  0x12,6
; 0000 02B2 TCNT1=0x00;
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	OUT  0x2C+1,R31
	OUT  0x2C,R30
; 0000 02B3 TCCR1A=0x40;
	CALL SUBOPT_0x22
; 0000 02B4 TCCR1B=0x0B;
; 0000 02B5 OCR1A=0x50;
	LDI  R30,LOW(80)
	LDI  R31,HIGH(80)
	OUT  0x2A+1,R31
	OUT  0x2A,R30
; 0000 02B6 
; 0000 02B7 TIMSK&=0xEE;
	IN   R30,0x39
	ANDI R30,LOW(0xEE)
	OUT  0x39,R30
; 0000 02B8 delay_ms(300);
	LDI  R30,LOW(300)
	LDI  R31,HIGH(300)
	CALL SUBOPT_0xB
; 0000 02B9 ledg=0;
	CBI  0x12,6
; 0000 02BA TCCR1A=0x00;
	CALL SUBOPT_0x23
; 0000 02BB TCCR1B=0x00;
; 0000 02BC OCR1A=0x00;
; 0000 02BD ledg=1;
	SBI  0x12,6
; 0000 02BE delay_ms(100);
	CALL SUBOPT_0x1F
; 0000 02BF TCCR1A=0x40;
	CALL SUBOPT_0x22
; 0000 02C0 TCCR1B=0x0B;
; 0000 02C1 OCR1A=0x50;
	LDI  R30,LOW(80)
	LDI  R31,HIGH(80)
	OUT  0x2A+1,R31
	OUT  0x2A,R30
; 0000 02C2 delay_ms(300);
	LDI  R30,LOW(300)
	LDI  R31,HIGH(300)
	CALL SUBOPT_0xB
; 0000 02C3 ledg=0;
	CBI  0x12,6
; 0000 02C4 TCCR1A=0x00;
	CALL SUBOPT_0x23
; 0000 02C5 TCCR1B=0x00;
; 0000 02C6 OCR1A=0x00;
; 0000 02C7 
; 0000 02C8 }
	RET
;
;void dor_lock(){
; 0000 02CA void dor_lock(){
_dor_lock:
; 0000 02CB      en=0;
	CBI  0x1B,7
; 0000 02CC      in1=1;
	SBI  0x18,0
; 0000 02CD      delay_ms(1);
	CALL SUBOPT_0x19
; 0000 02CE      in2=0;
	CBI  0x18,1
; 0000 02CF      en=1;
	SBI  0x1B,7
; 0000 02D0 
; 0000 02D1       delay_ms(30);
	LDI  R30,LOW(30)
	LDI  R31,HIGH(30)
	RJMP _0x20E0004
; 0000 02D2       en=0;
; 0000 02D3       }
;
;void dor_unlock(){
; 0000 02D5 void dor_unlock(){
_dor_unlock:
; 0000 02D6      en=0;
	CBI  0x1B,7
; 0000 02D7      in1=0;
	CBI  0x18,0
; 0000 02D8      delay_ms(1);
	CALL SUBOPT_0x19
; 0000 02D9      in2=1;
	SBI  0x18,1
; 0000 02DA      en=1;
	SBI  0x1B,7
; 0000 02DB 
; 0000 02DC       delay_ms(70);
	LDI  R30,LOW(70)
	LDI  R31,HIGH(70)
_0x20E0004:
	ST   -Y,R31
	ST   -Y,R30
	CALL _delay_ms
; 0000 02DD       en=0;
	CBI  0x1B,7
; 0000 02DE       }
	RET
;
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif

	.DSEG

	.CSEG
__lcd_write_nibble_G100:
	LD   R30,Y
	ANDI R30,LOW(0x10)
	BREQ _0x2000004
	SBI  0x15,4
	RJMP _0x2000005
_0x2000004:
	CBI  0x15,4
_0x2000005:
	LD   R30,Y
	ANDI R30,LOW(0x20)
	BREQ _0x2000006
	SBI  0x15,5
	RJMP _0x2000007
_0x2000006:
	CBI  0x15,5
_0x2000007:
	LD   R30,Y
	ANDI R30,LOW(0x40)
	BREQ _0x2000008
	SBI  0x15,6
	RJMP _0x2000009
_0x2000008:
	CBI  0x15,6
_0x2000009:
	LD   R30,Y
	ANDI R30,LOW(0x80)
	BREQ _0x200000A
	SBI  0x15,7
	RJMP _0x200000B
_0x200000A:
	CBI  0x15,7
_0x200000B:
	__DELAY_USB 11
	SBI  0x15,2
	__DELAY_USB 27
	CBI  0x15,2
	__DELAY_USB 27
	JMP  _0x20E0001
__lcd_write_data:
	LD   R30,Y
	ST   -Y,R30
	RCALL __lcd_write_nibble_G100
    ld    r30,y
    swap  r30
    st    y,r30
	LD   R30,Y
	ST   -Y,R30
	RCALL __lcd_write_nibble_G100
	__DELAY_USW 200
	JMP  _0x20E0001
_lcd_gotoxy:
	LD   R30,Y
	LDI  R31,0
	SUBI R30,LOW(-__base_y_G100)
	SBCI R31,HIGH(-__base_y_G100)
	LD   R30,Z
	LDD  R26,Y+1
	ADD  R30,R26
	ST   -Y,R30
	RCALL __lcd_write_data
	LDD  R12,Y+1
	LD   R30,Y
	STS  __lcd_y,R30
_0x20E0003:
	ADIW R28,2
	RET
_lcd_clear:
	LDI  R30,LOW(2)
	CALL SUBOPT_0x24
	LDI  R30,LOW(12)
	ST   -Y,R30
	RCALL __lcd_write_data
	LDI  R30,LOW(1)
	CALL SUBOPT_0x24
	LDI  R30,LOW(0)
	STS  __lcd_y,R30
	MOV  R12,R30
	RET
_lcd_putchar:
	LD   R26,Y
	CPI  R26,LOW(0xA)
	BREQ _0x2000011
	LDS  R30,__lcd_maxx
	CP   R12,R30
	BRLO _0x2000010
_0x2000011:
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDS  R30,__lcd_y
	SUBI R30,-LOW(1)
	STS  __lcd_y,R30
	ST   -Y,R30
	RCALL _lcd_gotoxy
	LD   R26,Y
	CPI  R26,LOW(0xA)
	BRNE _0x2000013
	JMP  _0x20E0001
_0x2000013:
_0x2000010:
	INC  R12
	SBI  0x15,0
	LD   R30,Y
	ST   -Y,R30
	RCALL __lcd_write_data
	CBI  0x15,0
	JMP  _0x20E0001
_lcd_puts:
	ST   -Y,R17
_0x2000014:
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	LD   R30,X+
	STD  Y+1,R26
	STD  Y+1+1,R27
	MOV  R17,R30
	CPI  R30,0
	BREQ _0x2000016
	ST   -Y,R17
	RCALL _lcd_putchar
	RJMP _0x2000014
_0x2000016:
_0x20E0002:
	LDD  R17,Y+0
	ADIW R28,3
	RET
_lcd_init:
	SBI  0x14,4
	SBI  0x14,5
	SBI  0x14,6
	SBI  0x14,7
	SBI  0x14,2
	SBI  0x14,0
	SBI  0x14,1
	CBI  0x15,2
	CBI  0x15,0
	CBI  0x15,1
	LD   R30,Y
	STS  __lcd_maxx,R30
	SUBI R30,-LOW(128)
	__PUTB1MN __base_y_G100,2
	LD   R30,Y
	SUBI R30,-LOW(192)
	__PUTB1MN __base_y_G100,3
	LDI  R30,LOW(20)
	LDI  R31,HIGH(20)
	CALL SUBOPT_0xB
	CALL SUBOPT_0x25
	CALL SUBOPT_0x25
	CALL SUBOPT_0x25
	LDI  R30,LOW(32)
	ST   -Y,R30
	RCALL __lcd_write_nibble_G100
	__DELAY_USW 400
	LDI  R30,LOW(40)
	ST   -Y,R30
	RCALL __lcd_write_data
	LDI  R30,LOW(4)
	ST   -Y,R30
	RCALL __lcd_write_data
	LDI  R30,LOW(133)
	ST   -Y,R30
	RCALL __lcd_write_data
	LDI  R30,LOW(6)
	ST   -Y,R30
	RCALL __lcd_write_data
	RCALL _lcd_clear
	JMP  _0x20E0001

	.CSEG
_itoa:
    ld   r26,y+
    ld   r27,y+
    ld   r30,y+
    ld   r31,y+
    adiw r30,0
    brpl __itoa0
    com  r30
    com  r31
    adiw r30,1
    ldi  r22,'-'
    st   x+,r22
__itoa0:
    clt
    ldi  r24,low(10000)
    ldi  r25,high(10000)
    rcall __itoa1
    ldi  r24,low(1000)
    ldi  r25,high(1000)
    rcall __itoa1
    ldi  r24,100
    clr  r25
    rcall __itoa1
    ldi  r24,10
    rcall __itoa1
    mov  r22,r30
    rcall __itoa5
    clr  r22
    st   x,r22
    ret

__itoa1:
    clr	 r22
__itoa2:
    cp   r30,r24
    cpc  r31,r25
    brlo __itoa3
    inc  r22
    sub  r30,r24
    sbc  r31,r25
    brne __itoa2
__itoa3:
    tst  r22
    brne __itoa4
    brts __itoa5
    ret
__itoa4:
    set
__itoa5:
    subi r22,-0x30
    st   x+,r22
    ret

	.DSEG

	.CSEG
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif

	.CSEG
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif

	.CSEG
_spi:
	LD   R30,Y
	OUT  0xF,R30
_0x2060003:
	SBIS 0xE,7
	RJMP _0x2060003
	IN   R30,0xF
_0x20E0001:
	ADIW R28,1
	RET

	.CSEG

	.CSEG

	.CSEG

	.DSEG
_g_ucTempbuf:
	.BYTE 0x14

	.ESEG
_tag_code:
	.BYTE 0x4

	.DSEG
_rx_buffer:
	.BYTE 0x8
__base_y_G100:
	.BYTE 0x4
__lcd_y:
	.BYTE 0x1
__lcd_maxx:
	.BYTE 0x1
__seed_G101:
	.BYTE 0x4

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x0:
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	JMP  _WriteRawRC

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1:
	ST   -Y,R30
	CALL _ReadRawRC
	MOV  R17,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2:
	LDI  R30,LOW(20)
	ST   -Y,R30
	LDI  R30,LOW(3)
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x3:
	LDI  R30,LOW(8)
	ST   -Y,R30
	ST   -Y,R30
	CALL _ClearBitMask
	LDI  R30,LOW(13)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x4:
	ST   -Y,R30
	LDI  R30,LOW(128)
	ST   -Y,R30
	JMP  _ClearBitMask

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x5:
	MOV  R30,R16
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x6:
	MOVW R26,R28
	ADIW R26,6
	ADD  R26,R30
	ADC  R27,R31
	LD   R30,X
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x7:
	ST   -Y,R30
	LDI  R30,LOW(128)
	ST   -Y,R30
	JMP  _SetBitMask

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x8:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R31,0
	CP   R26,R30
	CPC  R27,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x9:
	ST   -Y,R0
	ST   -Y,R1
	ST   -Y,R15
	ST   -Y,R22
	ST   -Y,R23
	ST   -Y,R24
	ST   -Y,R25
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
	SBIW R28,4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 38 TIMES, CODE SIZE REDUCTION:71 WORDS
SUBOPT_0xA:
	ST   -Y,R31
	ST   -Y,R30
	JMP  _lcd_puts

;OPTIMIZER ADDED SUBROUTINE, CALLED 33 TIMES, CODE SIZE REDUCTION:61 WORDS
SUBOPT_0xB:
	ST   -Y,R31
	ST   -Y,R30
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xC:
	CALL _dor_lock
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RJMP SUBOPT_0xB

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xD:
	LDI  R30,LOW(224)
	OUT  0x3A,R30
	SET
	BLD  R2,0
	CALL _int0_on
	CALL _int1_on
	JMP  _lcd_clear

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0xE:
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xF:
	LDI  R26,LOW(_tag_code)
	LDI  R27,HIGH(_tag_code)
	CALL __EEPROMRDB
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:36 WORDS
SUBOPT_0x10:
	LDI  R31,0
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R28
	ADIW R30,4
	ST   -Y,R31
	ST   -Y,R30
	CALL _itoa
	MOVW R30,R28
	ADIW R30,2
	RJMP SUBOPT_0xA

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x11:
	LDI  R30,LOW(4)
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x12:
	__POINTW2MN _tag_code,1
	CALL __EEPROMRDB
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x13:
	LDI  R30,LOW(8)
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x14:
	__POINTW2MN _tag_code,2
	CALL __EEPROMRDB
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x15:
	LDI  R30,LOW(12)
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x16:
	__POINTW2MN _tag_code,3
	CALL __EEPROMRDB
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x17:
	CBI  0x12,7
	CLT
	BLD  R2,0
	LDI  R30,LOW(224)
	OUT  0x3A,R30
	CALL _int0_off
	CALL _int1_off
	JMP  _dor_unlock

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x18:
	LDI  R30,LOW(82)
	ST   -Y,R30
	LDI  R30,LOW(_g_ucTempbuf)
	LDI  R31,HIGH(_g_ucTempbuf)
	ST   -Y,R31
	ST   -Y,R30
	CALL _PcdRequest
	MOV  R5,R30
	TST  R5
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x19:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	RJMP SUBOPT_0xB

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1A:
	LDI  R30,LOW(_g_ucTempbuf)
	LDI  R31,HIGH(_g_ucTempbuf)
	ST   -Y,R31
	ST   -Y,R30
	CALL _PcdAnticoll
	MOV  R5,R30
	TST  R5
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:88 WORDS
SUBOPT_0x1B:
	LDI  R31,0
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R28
	ADIW R30,2
	ST   -Y,R31
	ST   -Y,R30
	CALL _itoa
	MOVW R30,R28
	RJMP SUBOPT_0xA

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1C:
	LDI  R30,LOW(2000)
	LDI  R31,HIGH(2000)
	RJMP SUBOPT_0xB

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:25 WORDS
SUBOPT_0x1D:
	CALL __EEPROMWRB
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RJMP SUBOPT_0xB

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x1E:
	LDI  R30,LOW(0)
	OUT  0x33,R30
	OUT  0x32,R30
	OUT  0x3C,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x1F:
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	RJMP SUBOPT_0xB

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x20:
	CALL _lcd_clear
	MOV  R30,R6
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x21:
	MOV  R7,R30
	IN   R30,0x39
	ORI  R30,1
	OUT  0x39,R30
	LDI  R30,LOW(5)
	OUT  0x33,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x22:
	LDI  R30,LOW(64)
	OUT  0x2F,R30
	LDI  R30,LOW(11)
	OUT  0x2E,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x23:
	LDI  R30,LOW(0)
	OUT  0x2F,R30
	OUT  0x2E,R30
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	OUT  0x2A+1,R31
	OUT  0x2A,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x24:
	ST   -Y,R30
	CALL __lcd_write_data
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	RJMP SUBOPT_0xB

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x25:
	LDI  R30,LOW(48)
	ST   -Y,R30
	CALL __lcd_write_nibble_G100
	__DELAY_USW 400
	RET


	.CSEG
_delay_ms:
	ld   r30,y+
	ld   r31,y+
	adiw r30,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0xFA0
	wdr
	sbiw r30,1
	brne __delay_ms0
__delay_ms1:
	ret

__LSLW3:
	LSL  R30
	ROL  R31
__LSLW2:
	LSL  R30
	ROL  R31
	LSL  R30
	ROL  R31
	RET

__EEPROMRDB:
	SBIC EECR,EEWE
	RJMP __EEPROMRDB
	PUSH R31
	IN   R31,SREG
	CLI
	OUT  EEARL,R26
	OUT  EEARH,R27
	SBI  EECR,EERE
	IN   R30,EEDR
	OUT  SREG,R31
	POP  R31
	RET

__EEPROMWRB:
	SBIS EECR,EEWE
	RJMP __EEPROMWRB1
	WDR
	RJMP __EEPROMWRB
__EEPROMWRB1:
	IN   R25,SREG
	CLI
	OUT  EEARL,R26
	OUT  EEARH,R27
	SBI  EECR,EERE
	IN   R24,EEDR
	CP   R30,R24
	BREQ __EEPROMWRB0
	OUT  EEDR,R30
	SBI  EECR,EEMWE
	SBI  EECR,EEWE
__EEPROMWRB0:
	OUT  SREG,R25
	RET

__SAVELOCR6:
	ST   -Y,R21
__SAVELOCR5:
	ST   -Y,R20
__SAVELOCR4:
	ST   -Y,R19
__SAVELOCR3:
	ST   -Y,R18
__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

__LOADLOCR6:
	LDD  R21,Y+5
__LOADLOCR5:
	LDD  R20,Y+4
__LOADLOCR4:
	LDD  R19,Y+3
__LOADLOCR3:
	LDD  R18,Y+2
__LOADLOCR2:
	LDD  R17,Y+1
	LD   R16,Y
	RET

;END OF CODE MARKER
__END_OF_CODE:
