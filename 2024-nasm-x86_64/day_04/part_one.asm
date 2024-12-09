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
	mov rdx, 0
	mov rax, rdi
	mov r10, 140
	mul r10
	add rax, rsi
	mov rdx, rax ; rdx = offset

	mov rax, 0

	call _checkCoord_n
	call _checkCoord_ne
	call _checkCoord_e
	call _checkCoord_se
	call _checkCoord_s
	call _checkCoord_sw
	call _checkCoord_w
	call _checkCoord_nw

	ret

_checkCoord_n:
	cmp rdi, 3
	jl _checkCoord_ret

	cmp byte [array + rdx - 140*0], 'X'
	jne _checkCoord_ret
	cmp byte [array + rdx - 140*1], 'M'
	jne _checkCoord_ret
	cmp byte [array + rdx - 140*2], 'A'
	jne _checkCoord_ret
	cmp byte [array + rdx - 140*3], 'S'
	jne _checkCoord_ret

	inc rax
	ret
	
_checkCoord_ne:
	cmp rdi, 3
	jl _checkCoord_ret
	cmp rsi, 136
	jg _checkCoord_ret

	cmp byte [array + rdx - 140*0 + 0], 'X'
	jne _checkCoord_ret
	cmp byte [array + rdx - 140*1 + 1], 'M'
	jne _checkCoord_ret
	cmp byte [array + rdx - 140*2 + 2], 'A'
	jne _checkCoord_ret
	cmp byte [array + rdx - 140*3 + 3], 'S'
	jne _checkCoord_ret

	inc rax
	ret
	
_checkCoord_e:
	cmp rsi, 136
	jg _checkCoord_ret

	cmp byte [array + rdx + 0], 'X'
	jne _checkCoord_ret
	cmp byte [array + rdx + 1], 'M'
	jne _checkCoord_ret
	cmp byte [array + rdx + 2], 'A'
	jne _checkCoord_ret
	cmp byte [array + rdx + 3], 'S'
	jne _checkCoord_ret

	inc rax
	ret
	
_checkCoord_se:
	cmp rdi, 136
	jg _checkCoord_ret
	cmp rsi, 136
	jg _checkCoord_ret

	cmp byte [array + rdx + 140*0 + 0], 'X'
	jne _checkCoord_ret
	cmp byte [array + rdx + 140*1 + 1], 'M'
	jne _checkCoord_ret
	cmp byte [array + rdx + 140*2 + 2], 'A'
	jne _checkCoord_ret
	cmp byte [array + rdx + 140*3 + 3], 'S'
	jne _checkCoord_ret

	inc rax
	ret
	
_checkCoord_s:
	cmp rdi, 136
	jg _checkCoord_ret

	cmp byte [array + rdx + 140*0], 'X'
	jne _checkCoord_ret
	cmp byte [array + rdx + 140*1], 'M'
	jne _checkCoord_ret
	cmp byte [array + rdx + 140*2], 'A'
	jne _checkCoord_ret
	cmp byte [array + rdx + 140*3], 'S'
	jne _checkCoord_ret

	inc rax
	ret
	
_checkCoord_sw:
	cmp rdi, 136
	jg _checkCoord_ret
	cmp rsi, 3
	jl _checkCoord_ret

	cmp byte [array + rdx + 140*0 - 0], 'X'
	jne _checkCoord_ret
	cmp byte [array + rdx + 140*1 - 1], 'M'
	jne _checkCoord_ret
	cmp byte [array + rdx + 140*2 - 2], 'A'
	jne _checkCoord_ret
	cmp byte [array + rdx + 140*3 - 3], 'S'
	jne _checkCoord_ret

	inc rax
	ret
	
_checkCoord_w:
	cmp rsi, 3
	jl _checkCoord_ret

	cmp byte [array + rdx - 0], 'X'
	jne _checkCoord_ret
	cmp byte [array + rdx - 1], 'M'
	jne _checkCoord_ret
	cmp byte [array + rdx - 2], 'A'
	jne _checkCoord_ret
	cmp byte [array + rdx - 3], 'S'
	jne _checkCoord_ret

	inc rax
	ret

_checkCoord_nw:
	cmp rdi, 3
	jl _checkCoord_ret
	cmp rsi, 3
	jl _checkCoord_ret

	cmp byte [array + rdx - 140*0 - 0], 'X'
	jne _checkCoord_ret
	cmp byte [array + rdx - 140*1 - 1], 'M'
	jne _checkCoord_ret
	cmp byte [array + rdx - 140*2 - 2], 'A'
	jne _checkCoord_ret
	cmp byte [array + rdx - 140*3 - 3], 'S'
	jne _checkCoord_ret

	inc rax
	ret

_checkCoord_ret:
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
