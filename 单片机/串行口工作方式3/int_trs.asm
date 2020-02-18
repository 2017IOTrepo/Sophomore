	ORG  0000H            	;主程序入口
     	LJMP  MAIN
        ORG  0023H            	;串行中断入口
     	LJMP SERVE1
        ORG  0100H
MAIN:	MOV SP,#60h
	MOV R0,#40H
	MOV A,#00
	MOV R4,#10H
LP:   	MOV @R0,A
	INC R0
	INC A
	DJNZ R4,LP  
	MOV  TMOD, #20H         ;将T1设为工作方式2
        MOV  TH1, #0F3H         ;fosc=6MHz时，BD=2400
        MOV  TL1, #0F3H
        SETB  TR1               ;启动T1
        MOV  PCON, #80H         ;Smod=1
        MOV  SCON, #0D0H        ;串行口设为工作方式3， 允许接收
        MOV  R0, #40H           ;数据块首地址
	MOV R4,#10H		;发送字节数
        SETB ES                 ;允许串行口中断
        SETB EA                 ;开中断
        MOV A, @R0              ;取发送数据
        MOV  C, P
        MOV TB8,C		;奇偶标志送TB8
	MOV P1,A
	LCALL DELAY
	MOV SBUF,A		;发送数据
	DEC R4	
        SJMP $			;等待中断

;发送方单片机的中断服务程序：
SERVE1: PUSH ACC
	PUSH PSW
	JBC  RI, LOOP           ;是接收中断，清零RI，转入接收应答信息
        CLR  TI                 ;是发送中断，清零TI
        SJMP ENDT
LOOP:   MOV  A, SBUF            ;取应答信息
        CLR  C
        SUBB A,#01H             ;判断应答信息是#00H吗？
        JC   LOOP1              ;是#00H，发送正确
        MOV A, @R0              ;否则重发原来数据
        MOV  C, P
        MOV  TB8, C
        MOV  SBUF, A
	MOV P1,A
	LCALL DELAY
        SJMP ENDT
LOOP1:  INC  R0                 ;修改地址指针，准备发送下一个数据
        MOV A, @R0
        MOV  C, P
        MOV  TB8, C
        MOV  SBUF, A            ;发送数据
	MOV P1,A
	LCALL DELAY
        DJNZ R4, ENDT           ;数据未发送完，继续
        CLR  ES                 ;数据全部发送完毕，禁止串行口中断
ENDT:   POP PSW
	POP ACC
	RETI                    ;中断返回

DELAY:  MOV R7,#3
DD1:	MOV R6,#0FFH
DD2:	MOV R5,#0FFH
	DJNZ R5,$
	DJNZ R6,DD2
	DJNZ R7,DD1
	RET
  	END