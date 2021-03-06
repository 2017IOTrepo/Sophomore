SLAVE		EQU	30H
		ORG	00H
		AJMP	MAIN
		ORG	23H
		LJMP	SSIO

		ORG	30H
MAIN:		MOV	SP,#60H
		MOV	TMOD,#20H
		MOV	TH1,#0FDH
		MOV	TL1,#0FDH	
		SETB	EA		;串行口开中断
		SETB	ES
		MOV	SCON,#0D8H
		MOV	PCON,#0
		SETB	TR1
		SETB	SM2
	
		MOV	A,#0FFH
		MOV	P1,A
		MOV	A,P1
		MOV	SLAVE,A
		MOV	R5,#00H
DISPLAY:	MOV	P2,R5
		SETB	P3.7
		JB	P3.7,$
		JNB	P3.7,$
		INC	R5
		AJMP	DISPLAY

SSIO:		CLR	RI
		CLR	ES
		
		PUSH	ACC
		PUSH	PSW
		SETB	RS1
		CLR	RS0
		
		MOV	A,SBUF
		XRL	A,SLAVE
		JZ	SSIO1

RETURN:		POP	PSW
		POP	ACC
		SETB	ES
		SETB	SM2
		RETI

SSIO1:		CLR	SM2		
		JNB	RI,$
		CLR	RI		
	
SSIO2:		MOV	A,SBUF
		CJNE	A,#00H,STX
SRX:		JNB	RI,$		;接收数据
		CLR	RI
		MOV	A,SBUF
		MOV	R5,A		
		AJMP	RETURN	
STX:		MOV	A,R5
		MOV	SBUF,A
		JNB	TI,$
		CLR	TI		
		AJMP	RETURN

		END


