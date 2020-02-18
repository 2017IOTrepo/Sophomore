	ORG  0000H            	;主程序入口
     	LJMP  MAIN
        ORG  0023H            	;串行中断入口
     	LJMP SERVE2
        ORG  0100H
MAIN:   MOV  TMOD, #20H         ;将T1设为工作方式2
        MOV  TH1, #0F3H         ;fosc=6MHz时，BD=2400
        MOV  TL1, #0F3H
        SETB  TR1               ;启动T1
        MOV  PCON, #80H         ;Smod=1
        MOV  SCON, #0D0H        ;串行口设为工作方式3， 允许接收
        MOV  R0, #40H        	;数据块首地址
	MOV R7, #10H		;接收字节数
        SETB ES                 ;允许串行口中断
        SETB EA                 ;开中断
        SJMP $                  ;等待中断

;接收方单片机的中断服务程序：
SERVE2: JBC  RI, LOOP           ;是接收中断，清零RI，转入接收
        CLR  TI                 ;是发送中断，清零TI
        SJMP ENDT
LOOP:   MOV  A, SBUF            ;接收数据
        MOV  C, P               ;奇偶标志送C
        JC   LOOP1              ;为奇数，转入LOOP1
        ORL  C, RB8             ;为偶数，检测RB8
        JC   LOOP2              ;奇偶校验出错
        SJMP LOOP3              
LOOP1:  ANL  C, RB8             ;检测RB8
        JC   LOOP3              ;奇偶校验正确
LOOP2:  MOV  A, #0FFH
        MOV  SBUF, A            ;发送“不正确”应答信号
        SJMP ENDT
LOOP3:  MOV @R0, A              ;存放接收数据
	SWAP A
	MOV P1,A
        MOV  A, #00H
        MOV  SBUF, A            ;发送“正确”应答信号
        INC  R0                 ;修改数据指针
        DJNZ R7, ENDT           ;未接收完数据
        CLR  ES                 ;全部数据接收完毕， 禁止串行口中断
ENDT:   RETI                    ;中断返回
	
	END
