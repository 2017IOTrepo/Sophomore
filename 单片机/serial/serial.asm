	org 0000h
	ljmp main
	org 0023h
	ljmp serialSer
	org 0030h
main:
	;����������
	mov tmod,#20h
	mov tl1,#0f4h
	mov th1,#0f4h
	setb tr1

	;��ʽ�趨
	mov scon,#50h
	;���ж�
	setb ea
	setb es
	
	mov a,#00h
	mov r0,a
	mov sbuf,a
	
	sjmp $
serialSer:
	jb ri,recive

	clr ti
	inc r0
	mov a,r0
	cjne a,#0ffh,tt
	
	sjmp exit
tt:
	mov sbuf,r0
	sjmp exit
recive:
	clr ri
	mov a,sbuf

	setb p2.5
	mov p1,a
	clr p2.5

exit:
	reti
	end

	