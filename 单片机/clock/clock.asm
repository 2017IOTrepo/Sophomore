	
	DULA BIT P2.6
	WELA BIT P2.7

	SEC  EQU 30H
	MIN  EQU 31H
	HOUR EQU 32H
	COUNT EQU 33H
	
	org	0000h
	ljmp main
	org 000bh
	ljmp t0serv
	org 0030h
main:

	mov tmod,#01h

	mov th0,#0d8h
	mov tl0,#0f0h

	mov p2,#3fh
	mov p0,#00h

	setb ea
	setb et0
	
	mov a,#00h
	mov SEC,a
	mov MIN,a
	mov HOUR,a

	mov COUNT,#100

	SETB TR0
LP:
	LCALL DISP
	SJMP LP
t0serv:

	push acc
	push psw

	mov th0,#0d8h
	mov tl0,#0f0h

	djnz COUNT,return
	mov COUNT,#100

	mov a,#01h
	add a,SEC
	da a
	mov SEC,a

	cjne a,#60h,return

	mov SEC,#00H
	mov a,#01h
	add a,MIN
	da a
	mov MIN,a

	cjne a,#60h,return

	mov MIN,#00H
	mov a,#01h
	add a,HOUR
	da a
	mov HOUR,a
	cjne a,#24h,return

	mov HOUR,#00H
return:
	pop psw
	pop acc
	reti
DISP:
	;显示秒
	mov dptr,#tab	
	mov a,SEC
	anl a,#0fh
	;段选
	setb DULA
	movc a,@a+dptr
	mov p0,a
	clr DULA
	 ;	位选
	setb WELA
	mov p0,#0xdf
	clr wela


	lcall delay

	mov a,SEC
	anl a,#0f0h
	swap a
	lcall delay

	setb DULA
	movc a,@a+dptr
	mov p0,a
	clr DULA

	setb WELA
	mov p0,#0xef
	clr wela

	lcall delay

		;显示分
	
	mov a,MIN
	anl a,#0fh
	;段选
	setb DULA
	movc a,@a+dptr
	mov p0,a
	clr DULA
	 ;	位选
	setb WELA
	mov p0,#0f7h
	clr wela


	lcall delay

	mov a,MIN
	anl a,#0f0h
	swap a
	lcall delay

	setb DULA
	movc a,@a+dptr
	mov p0,a
	clr DULA

	setb WELA
	mov p0,#0fbh
	clr wela

	lcall delay

		;显示 时
	
	mov a,HOUR
	anl a,#0fh
	;段选
	setb DULA
	movc a,@a+dptr
	mov p0,a
	clr DULA
	 ;	位选
	setb WELA
	mov p0,#0fdh
	clr wela


	lcall delay

	mov a,HOUR
	anl a,#0f0h
	swap a
	lcall delay

	setb DULA
	movc a,@a+dptr
	mov p0,a
	clr DULA

	setb WELA
	mov p0,#0feh
	clr wela

	lcall delay

	ret
	delay:
	mov r1,#2h
d0:	mov r2,#0ffh
d1: 
	djnz r2,d1
	djnz r1,d0
	ret

delay1:
	mov r1,#10h
d3:	mov r2,#0ffh
d4: 
	djnz r2,d4
	djnz r1,d3
	ret	
tab: db 3fh,6h,5bh,4fh,66h,6dh,7dh,27h,7fh,6fh
	end
