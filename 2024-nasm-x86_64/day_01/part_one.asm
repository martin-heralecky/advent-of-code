section .text
	global _start

	extern parseInt
	extern sortQ
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

	mov r10, inputBuf
	mov [inputBufCursor], r10

	mov rbp, inputBuf
	add rbp, rax ; rbp = eof

	mov r12, 0 ; array index

_loadInput_processRow:
	cmp [inputBufCursor], rbp
	jge _loadInput_ret

	mov rdi, inputBufCursor
	call parseInt
	mov [leftArray + r12], rax

	add qword [inputBufCursor], 3 ; skip separator

	mov rdi, inputBufCursor
	call parseInt
	mov [rightArray + r12], rax

	add qword [inputBufCursor], 1 ; skip newline

	add r12, 8

	jmp _loadInput_processRow

_loadInput_ret:
	ret

computeDistance:
	mov rax, 0
	mov rdx, 1000 ; rows remaining

_computeDistance_processItem:
	; diff into rdi
	mov rdi, [leftArray + rdx * 8 - 8]
	sub rdi, [rightArray + rdx * 8 - 8]

	; rdi = abs(rdi)
	mov rsi, rdi
	neg rdi
	cmovl rdi, rsi

	add rax, rdi

	dec rdx
	jnz _computeDistance_processItem

	ret

exit:
	mov rax, 60 ; exit
	mov rdi, 0
	syscall

_start:
	call loadInput

	mov rdi, leftArray
	mov rsi, 1000
	call sortQ

	mov rdi, rightArray
	mov rsi, 1000
	call sortQ

	call computeDistance

	mov rdi, rax
	call printlnInt

	jmp exit

section .bss
	inputBuf: resb 65536
	inputBufSize: equ $-inputBuf
	inputBufCursor: resq 1

	leftArray: resq 1000
	rightArray: resq 1000

section .data
	inputFilename: db "input.txt", 0
