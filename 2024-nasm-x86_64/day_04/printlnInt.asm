section .text
	global printlnInt

; printlnInt(n): void
printlnInt:
	mov r9, rsp ; write buffer cursor starting at end
	sub rsp, 21 ; 21 bytes on stack as a write buffer
	mov r10, 10 ; base

	; last char is \n
	dec r9
	mov byte [r9], 10

	; we will divide rax by 10 until it's 0 and save the digits in reverse order
	mov rax, rdi

_getDigit:
	mov rdx, 0
	div r10 ; rdx:rax / r10 -> rax (quotient), rdx (remainder)
	add rdx, '0'
	dec r9
	mov [r9], dl

	cmp rax, 0
	jne _getDigit

	; compute length into rdx
	mov rdx, rsp
	add rdx, 21
	sub rdx, r9

	; print
	mov rax, 1 ; write
	mov rdi, 1 ; fd
	mov rsi, r9 ; buf
	; rdx count
	syscall

	add rsp, 21 ; free buffer

	ret
