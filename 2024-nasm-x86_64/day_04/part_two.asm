section .text
	global _start

	extern printlnInt

loadInput:
	mov rax, 2 ; open
	mov rdi, inputFilename
	mov rsi, 0 ; O_RDONLY
	syscall

	mov rdi, rax ; fd
	mov rax, 0 ; read
	mov rsi, inputBuf ; buf
	mov rdx, inputBufSize ; count
	syscall

	mov rdi, inputBuf ; rdi = file cursor
	mov rdx, inputBuf
	add rdx, rax ; rdx = eof
	mov rsi, 0 ; rsi = array offset

_loadInput_process:
	cmp rdi, rdx ; check eof
	jge _loadInput_ret

	mov r10b, [rdi] ; load byte
	inc rdi

	cmp r10b, 10 ; skip newline
	je _loadInput_process

	mov [array + rsi], r10b ; store byte
	inc rsi

	jmp _loadInput_process

_loadInput_ret:
	ret

; checkCoord(row, col): count
checkCoord:
	mov rax, 0

	cmp rdi, 1
	jl _checkCoord_notFound
	cmp rdi, 138
	jg _checkCoord_notFound
	cmp rsi, 1
	jl _checkCoord_notFound
	cmp rsi, 138
	jg _checkCoord_notFound

	mov rdx, 0
	mov rax, rdi
	mov r10, 140
	mul r10
	add rax, rsi
	mov rdx, rax ; rdx = offset

	cmp byte [array + rdx], 'A'
	jne _checkCoord_notFound
	
_checkCoord_tl2br:
	cmp byte [array + rdx - 141], 'M'
	je _checkCoord_tl2br_brMustBeS
	cmp byte [array + rdx - 141], 'S'
	je _checkCoord_tl2br_brMustBeM
	jmp _checkCoord_notFound

_checkCoord_tl2br_brMustBeS:
	cmp byte [array + rdx + 141], 'S'
	jne _checkCoord_notFound
	jmp _checkCoord_bl2tr

_checkCoord_tl2br_brMustBeM:
	cmp byte [array + rdx + 141], 'M'
	jne _checkCoord_notFound
	jmp _checkCoord_bl2tr

_checkCoord_bl2tr:
	cmp byte [array + rdx + 139], 'M'
	je _checkCoord_bl2tr_trMustBeS
	cmp byte [array + rdx + 139], 'S'
	je _checkCoord_bl2tr_trMustBeM
	jmp _checkCoord_notFound

_checkCoord_bl2tr_trMustBeS:
	cmp byte [array + rdx - 139], 'S'
	jne _checkCoord_notFound
	jmp _checkCoord_found

_checkCoord_bl2tr_trMustBeM:
	cmp byte [array + rdx - 139], 'M'
	jne _checkCoord_notFound
	jmp _checkCoord_found

_checkCoord_notFound:
	mov rax, 0
	ret

_checkCoord_found:
	mov rax, 1
	ret

exit:
	mov rax, 60 ; exit
	mov rdi, 0
	syscall

_start:
	call loadInput

	mov r12, 0 ; r12 = match count
	mov rbx, 0 ; rbx = row
	mov rbp, 0 ; rbp = col

_start_next:
	mov rdi, rbx
	mov rsi, rbp
	call checkCoord
	add r12, rax

	inc rbp

	cmp rbp, 140
	jl _start_next

	mov rbp, 0
	inc rbx

	cmp rbx, 140
	jl _start_next

	mov rdi, r12
	call printlnInt

	jmp exit

section .bss
	inputBuf: resb 65536
	inputBufSize: equ $-inputBuf

	array: resq 140*140

section .data
	inputFilename: db "input.txt", 0
