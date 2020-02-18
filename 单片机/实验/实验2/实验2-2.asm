		ORG 0000H
		
		AJMP START
		
		ORG 30H

START:

		MOV SP,#50H
		
		MOV TMOD,#01000000B ;定时/计数器1作计数用,0不用全置0
	
		MOV TL1,#00H
					
		SETB TR1 ;启动计数器1开始运行.

LOOP: 	
		MOV A,TL1
		
		CPL A


		MOV P1,A

		AJMP LOOP

END