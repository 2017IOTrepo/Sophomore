	ORG  0000H            	;���������
     	LJMP  MAIN
        ORG  0023H            	;�����ж����
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
	MOV  TMOD, #20H         ;��T1��Ϊ������ʽ2
        MOV  TH1, #0F3H         ;fosc=6MHzʱ��BD=2400
        MOV  TL1, #0F3H
        SETB  TR1               ;����T1
        MOV  PCON, #80H         ;Smod=1
        MOV  SCON, #0D0H        ;���п���Ϊ������ʽ3�� �������
        MOV  R0, #40H           ;���ݿ��׵�ַ
	MOV R4,#10H		;�����ֽ���
        SETB ES                 ;�����п��ж�
        SETB EA                 ;���ж�
        MOV A, @R0              ;ȡ��������
        MOV  C, P
        MOV TB8,C		;��ż��־��TB8
	MOV P1,A
	LCALL DELAY
	MOV SBUF,A		;��������
	DEC R4	
        SJMP $			;�ȴ��ж�

;���ͷ���Ƭ�����жϷ������
SERVE1: PUSH ACC
	PUSH PSW
	JBC  RI, LOOP           ;�ǽ����жϣ�����RI��ת�����Ӧ����Ϣ
        CLR  TI                 ;�Ƿ����жϣ�����TI
        SJMP ENDT
LOOP:   MOV  A, SBUF            ;ȡӦ����Ϣ
        CLR  C
        SUBB A,#01H             ;�ж�Ӧ����Ϣ��#00H��
        JC   LOOP1              ;��#00H��������ȷ
        MOV A, @R0              ;�����ط�ԭ������
        MOV  C, P
        MOV  TB8, C
        MOV  SBUF, A
	MOV P1,A
	LCALL DELAY
        SJMP ENDT
LOOP1:  INC  R0                 ;�޸ĵ�ַָ�룬׼��������һ������
        MOV A, @R0
        MOV  C, P
        MOV  TB8, C
        MOV  SBUF, A            ;��������
	MOV P1,A
	LCALL DELAY
        DJNZ R4, ENDT           ;����δ�����꣬����
        CLR  ES                 ;����ȫ��������ϣ���ֹ���п��ж�
ENDT:   POP PSW
	POP ACC
	RETI                    ;�жϷ���

DELAY:  MOV R7,#3
DD1:	MOV R6,#0FFH
DD2:	MOV R5,#0FFH
	DJNZ R5,$
	DJNZ R6,DD2
	DJNZ R7,DD1
	RET
  	END