	ORG  0000H            	;���������
     	LJMP  MAIN
        ORG  0023H            	;�����ж����
     	LJMP SERVE2
        ORG  0100H
MAIN:   MOV  TMOD, #20H         ;��T1��Ϊ������ʽ2
        MOV  TH1, #0F3H         ;fosc=6MHzʱ��BD=2400
        MOV  TL1, #0F3H
        SETB  TR1               ;����T1
        MOV  PCON, #80H         ;Smod=1
        MOV  SCON, #0D0H        ;���п���Ϊ������ʽ3�� �������
        MOV  R0, #40H        	;���ݿ��׵�ַ
	MOV R7, #10H		;�����ֽ���
        SETB ES                 ;�����п��ж�
        SETB EA                 ;���ж�
        SJMP $                  ;�ȴ��ж�

;���շ���Ƭ�����жϷ������
SERVE2: JBC  RI, LOOP           ;�ǽ����жϣ�����RI��ת�����
        CLR  TI                 ;�Ƿ����жϣ�����TI
        SJMP ENDT
LOOP:   MOV  A, SBUF            ;��������
        MOV  C, P               ;��ż��־��C
        JC   LOOP1              ;Ϊ������ת��LOOP1
        ORL  C, RB8             ;Ϊż�������RB8
        JC   LOOP2              ;��żУ�����
        SJMP LOOP3              
LOOP1:  ANL  C, RB8             ;���RB8
        JC   LOOP3              ;��żУ����ȷ
LOOP2:  MOV  A, #0FFH
        MOV  SBUF, A            ;���͡�����ȷ��Ӧ���ź�
        SJMP ENDT
LOOP3:  MOV @R0, A              ;��Ž�������
	SWAP A
	MOV P1,A
        MOV  A, #00H
        MOV  SBUF, A            ;���͡���ȷ��Ӧ���ź�
        INC  R0                 ;�޸�����ָ��
        DJNZ R7, ENDT           ;δ����������
        CLR  ES                 ;ȫ�����ݽ�����ϣ� ��ֹ���п��ж�
ENDT:   RETI                    ;�жϷ���
	
	END
