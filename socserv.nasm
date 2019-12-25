	global _start

	section .text
_start: 
	mov	rax,	41	; socket
	mov	rdi,	2	; PF_INET
	mov	rsi,	1	; SOCK_STREAM
	mov	rdx,	0	; default protocol
	syscall
	cmp	rax,	0
	mov	rdi,	41
	jl	panic
	push	rax		; socket file descriptor
	
	mov	rax,	49	; bind
	mov	rdi,	[rsp]	; socket file descriptor
	mov	rsi,	sockaddr
	mov	rdx,	16	; sockaddr length
	syscall
	cmp	rax,	0
	mov	rdi,	49
	jl	panic
	
	mov	rax,	50	; listen
	mov	rdi,	[rsp]	; socket file descriptor
	mov	rsi,	5	; allow up to 5 connections waiting on socket
	syscall
	cmp	rax,	0
	mov	rdi,	50
	jl	panic
	
	mov	rax,	43	; accept
	mov	rdi,	[rsp]	; socket file descriptor
	mov	rsi,	cliaddr
	mov	rdx,	cliaddrLen
	syscall
	cmp	rax,	0
	mov	rdi,	43
	jl	panic
	
	mov	rax,	1	; write
	mov	rdi,	1	; stdout
	mov	rsi,	msg1
	mov	rdx,	11	; msg1 length
	syscall
	
	mov	rax,	60	; exit
	mov	rdi,	0	; 0 status code
	syscall

; rdi:	syscall vector panicking
panic:
	mov	rax,	60	; exit
	mov	rdi,	rdi	; non-zero status code
	syscall

	section .rodata
sockaddr:
	db	2,	0	; AF_INET
	db	0x9,	0xc4	; port 2500
	db	127,0,0,1	; INADDR_LOOPBACK
	times 8 db 0
msg1:
	db "Connection",10

	section	.bss
message:
	resb	256
cliaddr:
	resb	16
cliaddrLen:
	resb	8
