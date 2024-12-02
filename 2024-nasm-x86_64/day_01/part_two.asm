section .text
	global _start

	extern parseInt
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

computeScore:
	mov rax, 0

	mov rdi, 1000 ; left cursor

_computeScore_nextLeft:
	mov rsi, 1000 ; right cursor

	mov rdx, [leftArray + rdi * 8 - 8]

_computeScore_nextRight:
	cmp rdx, [rightArray + rsi * 8 - 8]
	jne _computeScore_continue

	add rax, rdx

_computeScore_continue:
	dec rsi
	jnz _computeScore_nextRight

	dec rdi
	jnz _computeScore_nextLeft

	ret

exit:
	mov rax, 60 ; exit
	mov rdi, 0
	syscall

_start:
	call loadInput

	call computeScore

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
