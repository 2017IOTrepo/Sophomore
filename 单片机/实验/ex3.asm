						miaoL equ 77h
						miaoH equ 76h
						timercount equ 40h
						keyvalue equ 50h

						
						org 0000h
						ljmp main
						org 000bh
						ljmp timer0_ser
						org 0030h
					main:

						mov r0,#70h
						mov a,#0
						mov r7,#08h
					lp:
						mov @r0,a
						inc r0
						djnz r7,lp

						
						lcall inittimer
						lcall openint
						lcall starttimer0

						mov timercount,#0ah

				main1:
						lcall disp

						lcall keycan
						sjmp main1
					disp:
						
						push 07h
						push 06h
						push 00h
						push acc
						mov r7,#08h
						mov r6,#0feh
						mov r0,#70h

					 lp2:
					 	mov a,r6
						setb p2.7
						mov p0,a
						clr p2.7

						mov dptr,#tab
						mov a,@r0
						movc a,@a+dptr
						setb p2.6
						mov p0,a
						clr p2.6

						lcall delay


						inc r0
						mov a,r6
						rl a
						mov r6,a
						djnz r7,lp2

						pop acc
						pop 00h
						pop 06h
						pop 07h

					

						ret
					delay:
						push 03h
						push 04h
											   
						mov r3,#04h
					d2:	mov r4,#04fh
					d1:	djnz r4,d1
						djnz r3,d2

						pop 04h
						pop 03h
						ret
					inittimer:
						mov tmod,#01h
						mov th0,#3ch
						mov tl0,#0b0h
						ret
					openint:
						setb et0
						setb ea
						ret
					starttimer0:
						setb tr0
						ret
					stoptimer:
						clr tr0
						ret
					timer0_ser:
						push acc
						mov th0,#3ch
						mov tl0,#0b0h

						djnz timercount,rtn

						mov timercount,#0ah
						inc miaoL
						mov a,miaoL
						cjne a,#0ah,rtn
						mov miaoL,#0
						inc miaoH
						mov a,miaoH
						cjne a,#06h,rtn
						mov miaoH,#0
					rtn:
						pop acc
						reti
				keycan:

						mov r3,#00h	;col
						mov r4,#00h	;row
						
						mov p3,#0fh
						nop 
						nop
						mov a,p3
						
						cjne a,#0fh,k1
						sjmp keyrtn
					;puanduan hang
					k1:
						cpl a
						anl a,#0fh
						jb acc.0,row1
						jb acc.1,row2
						jb acc.2,row3
						jb acc.3,row4
					row1:
						mov r4,#00h
						sjmp next
					row2:
						mov r4,#01h
						sjmp next
					row3:
						mov r4,#02h
						sjmp next
					row4:
						mov r4,#03h
				
					next:

						mov p3,#0f0h
						nop 
						nop
						mov a,p3
						
						cjne a,#0fh,k2
						sjmp keyrtn
					k2:
						cpl a
						anl a,#0f0h
						swap a
						jb acc.0,col1
						jb acc.1,col2
						jb acc.2,col3
						jb acc.3,col4

					col1:
						mov r3,#00h
						sjmp keyhandle
					col2:
						mov r3,#01h
						sjmp keyhandle	
					col3:
						mov r3,#02h
						sjmp keyhandle
					col4:
						mov r3,#03h
			 keyhandle:
			 			mov a,r4
						mov b,#04h
						mul ab
						add a,r3
						mov keyvalue,a
		keywait:	mov p3,#0fh
					mov a,p3
					cjne a,#0fh,keywait
					lcall handlekey
				keyrtn:
					ret
		handlekey:
			
				mov a,keyvalue	
				cjne a,#00h,kk1
				inc miaoL
				mov a,miaoL
				cjne a,#0ah,kkrtn
				mov miaoL,#00h
				sjmp kkrtn
			kk1:
				  	inc miaoH
					mov a,miaoH
					cjne a,#06h,kkrtn
					mov miaoH,#00h

		  kkrtn:
				ret					
					
				  
					
				tab: db  3Fh,06h,5bh,4fh,66h,6dh,7dh,07h,7fh,6fh,77h,7ch  
						end
