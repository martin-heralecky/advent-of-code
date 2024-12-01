section .text
	global sortQ

_run:
	mov rdx, rsi

_next:
	dec rdx
	jz _ret

	; get a pair (r8, r9)
	mov r8, [rdi + rdx * 8 - 8]
	mov r9, [rdi + rdx * 8]

	; check order
	cmp r8, r9
	jle _next

	; swap
	mov [rdi + rdx * 8 - 8], r9
	mov [rdi + rdx * 8], r8
	mov rcx, 1

	jmp _next

_ret:
	ret

; sortQ(array, length): void
sortQ:
	mov rcx, 0 ; whether there was at least one swap
	call _run
	cmp rcx, 0
	jne sortQ

	ret
