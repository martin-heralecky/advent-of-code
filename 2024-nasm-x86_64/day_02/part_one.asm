section .text
	global _start

	extern parseInt
	extern printlnInt

run:
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

	mov r13, inputBuf
	add r13, rax ; r13 = eof

	mov r12, 0 ; safe reports count

_nextReport:
	cmp [inputBufCursor], r13
	jge _ret

	mov r15, 1 ; is report safe?

	mov rdi, inputBufCursor
	call parseInt
	mov rbx, rax ; rbx = level

	inc qword [inputBufCursor] ; skip separator

	mov rdi, inputBufCursor
	call parseInt
	mov rbp, rax ; rbp = next level

	mov r14, 0 ; 0=desc, 1=asc
	cmp rbx, rbp
	je _unsafe
	cmp rbx, rbp
	jg _nextLevel
	mov r14, 1
	jmp _nextLevel

_unsafe:
	mov r15, 0
	jmp _nextLevel

_nextLevel:
	mov r10, rbx
	sub r10, rbp ; diff into r10

	; r10 = abs(r10)
	mov r11, r10
	neg r10
	cmovl r10, r11

	cmp r10, 3
	jle __safe
	mov r15, 0

__safe:
	; are we at end of report?
	mov r10, [inputBufCursor]
	cmp byte [r10], 10 ; newline
	je _reportProcessed

	inc qword [inputBufCursor] ; skip separator

	mov rbx, rbp
	mov rdi, inputBufCursor
	call parseInt
	mov rbp, rax

	; check order
	cmp rbx, rbp
	je _unsafe
	cmp r14, 0
	je _shouldBeDesc
	jmp _shouldBeAsc

_shouldBeDesc:
	cmp rbx, rbp
	jg _nextLevel
	mov r15, 0
	jmp _nextLevel

_shouldBeAsc:
	cmp rbx, rbp
	jl _nextLevel
	mov r15, 0
	jmp _nextLevel

_reportProcessed:
	inc qword [inputBufCursor] ; skip newline
	cmp r15, 1
	jne _nextReport
	inc r12
	jmp _nextReport

_ret:
	mov rax, r12
	ret

exit:
	mov rax, 60 ; exit
	mov rdi, 0
	syscall

_start:
	call run

	mov rdi, rax
	call printlnInt

	jmp exit

section .bss
	inputBuf: resb 65536
	inputBufSize: equ $-inputBuf
	inputBufCursor: resq 1

section .data
	inputFilename: db "input.txt", 0
