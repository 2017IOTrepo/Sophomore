	endchar equ '$'
	org 0000h
	ljmp main
	org 0023h
	ljmp serial_ser
	org 0030h
main:

	mov p1,#0fh
	mov tmod,#20h
	mov th1,#0fdh
	mov tl1,#0fdh
	setb tr1

	mov scon,#50h


	mov dptr,#str
	mov r6,#00h
	mov a,r6
	movc a,@a+dptr
	mov sbuf,a

	setb es
	setb ea

	sjmp $
serial_ser:
	jnb ri,send
	clr ri
	mov a,sbuf
	
	cjne a,#31h,rets
	mov p1,#0f0h
	sjmp rets

send:
	clr ti
	inc r6
	mov a,r6
	movc a,@a+dptr
	cjne a,#endchar,sendnext
	
	sjmp rets
sendnext:
	mov sbuf,a
rets:
	reti
str: db 'hello world!','$'
	end
