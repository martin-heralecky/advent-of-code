section .text
	global parseInt

; parseInt(*buf): int
;   moves *buf by the amount of bytes read
parseInt:
	mov rax, 0
	mov rcx, 10 ; multiplier

	mov r10, [rdi] ; dereference *buf

_parseDigit:
	mov r11, 0
	mov r11b, [r10]

	cmp r11, '0'
	jl _ret
	cmp r11, '9'
	jg _ret

	sub r11, '0'
	mul rcx ; rdx:rax = rax * rcx
	add rax, r11

	inc r10

	jmp _parseDigit

_ret:
	mov [rdi], r10
	ret
