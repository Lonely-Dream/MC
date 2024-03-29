pa8255	equ	0FF28h
pb8255	equ	0FF29h
pc8255	equ	0FF2Ah
con8255	equ	0FF2Bh
setclk	equ	01h
clrclk	equ	00h
setpw	equ	03h
clrpw 	equ	02h
add_w	equ	0a0h        	;写卡地址
add_r	equ	0a1h        	;读卡地址
assume	cs:code
code 	  segment public
org 		1000h
start:               	JMP		start0
			DAT		DB 22H
			ADDR		DB 7FH
			flag1		DB 00H
			flag2		DB 00H ;0 write 1 read		
start0:			mov      	dx, con8255      	;8255控制字,PB输入,PA.PC输出
                   	mov      	al, 82h
                   	out        	dx, al
                   	mov      	al, clrpw
                   	out        	dx, al
start1:           	mov      	dx, pb8255
                   	in          	al, dx
                   	test       	al, 01h
                   	jnz        	start1
                   	mov      	dx, con8255
                   	mov      	al, setpw
                   	out        	dx, al
			
			mov		cl,flag2
			cmp		cl,00h
			jne		nx2_w
			mov      	bh, ADDR                 ;写入地址FH
                   	mov      	ah, DAT                ;写入数据ABH
                   	call       	write_byte
                   	call       	delay10
			MOV		CL,flag1
			CMP		CL,00H
			jne		nx2_w
			MOV		ADDR,7EH
			MOV		DAT,33H
			mov		flag1,01h
			jmp		start0
nx2_w:			mov		flag2,01h
			MOV		ADDR,7fH	; read
			MOV		flag1,00H
			mov      	bh, ADDR
                   	call       	read_byte
			MOV		CL,flag1
			CMP		CL,00H
			jne		nx2_r
			MOV		DI,ax
			mov 		flag1,01h
			jmp		start0
nx2_r:			mov		si,ax
			jmp		start0
write_byte:        	call       	begin0                  ;开始信号
                   	mov      	bl, add_w              	;写入器件地址
                   	call       	wr_byte
                   	mov      	bl, bh                  ;写入字节地址
                   	call       	wr_byte
                   	mov      	bl, ah                  ;写入数据
                   	call       	wr_byte
                   	call       	stop0
                   	ret
read_byte:        	call       	begin0
                  	mov     	bl, add_w               ;执行空字节写序列
                    call      	wr_byte
                  mov     	bl, bh
                  call      	wr_byte
                  call      	begin0
                  mov     	bl, add_r               ;立即地址读取
                  call      	wr_byte
                  mov     	dx, con8255
                  mov     	al, 92h
                  out       	dx, al
                  mov      	al, setpw
                  out        	dx, al
                  call      	rd_byte
                  call      	stop0
                  ret
begin0:           mov      	dx, con8255
                 mov      	al, clrclk
                 out        	dx, al
                 mov      	dx, pa8255
                 mov      	al, 01h
                 out        	dx, al
                 mov      	dx, con8255
                 mov      	al, setclk
                 out        	dx, al
                 mov      	dx, pa8255
                 mov      	al, 00h
                 out        	dx, al
                 mov      	dx, con8255
                 mov      	al, clrclk
                 out        	dx, al
                 ret
stop0:            mov      	dx, con8255
                 mov      	al, clrclk
                 out        	dx, al
                 mov      	dx, pa8255
                 mov      	al, 00h
                 out        	dx, al
                 mov      	dx, con8255
                 mov      	al, setclk
                 out        	dx, al
                 mov      	dx, pa8255
                 mov      	al, 01h
                 out        	dx, al
                 mov      	dx, con8255
                 mov      	al, clrclk
                 out        	dx, al
                 mov      	dx, pa8255
                 mov      	al, 00h
                 out        	dx, al
                 ret  
wr_byte:         mov      	cx, 0008h
                mov      	dx, con8255
                mov      	al, clrclk
                out        	dx, al
wbyte1:          rcl         	bl, 1
                 mov      	al, 00h
                 rcl         	al, 1
                 mov      	dx, pa8255
                 out        	dx, al
                 mov      	dx, con8255
                 mov      	al, setclk
                 out        	dx, al
                 mov      	dx, con8255
                 mov      	al, clrclk
                 out        	dx, al
                 loop      	wbyte1
                 mov      	dx, con8255
                 mov      	al, setclk
                 out        	dx, al
                 mov      	cx, 0005h
 wait0:           nop
                 loop      	wait0            
                 mov      	dx, con8255
                 mov      	al, clrclk
                 out        	dx, al
                 ret
rd_byte:          mov      	ah, 00h
                 mov      	cx, 0008h
rbyte1:           mov      	dx, pa8255
                 in          	al, dx
                 rcr         	al, 1
                 mov      	dx, con8255
                 mov      	al, setclk
                 out        	dx, al
                 rcl         	ah, 1
                 mov      	dx, con8255
                 mov      	al, clrclk
                 out        	dx, al
                 loop      	rbyte1
                 ret
delay10:          mov     	cx, 1388h
delay1:           nop 
                 loop     	delay1 
                 ret               
                 code ends
                 end start
