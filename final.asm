global final

extern printf
extern scanf

segment .data

	welcome db "Welcome to the Hypotenuse calculator",10,0
	inputprompt db "Please enter the number of sums to calculate: ",10,0
	showsum db "The harmonic sum of %ld terms is %5.7lf",10,0
	closing db "Have a Nice Day. The sum will be returned to the driver",10,0

	stringformat db "%s",0
	integerformat db "%ld",0
	floatformat db "%lf", 0

segment .bss

segment .text

final:

	push 	rbp
	mov	rbp, rsp

;===== print welcome statement =====

	mov	rax, 0
	mov	rdi, stringformat
	mov	rsi, welcome
	call	printf

;===== prompt user to input a value =====

	mov	rax, 0
	mov	rdi, stringformat
	mov	rsi, inputprompt
	call	printf

;===== recieve user input =====

	push	qword, 0
	mov	rax, 0
	mov	rdi, integerformat
	mov	rsi, rsp
	call scanf

	pop r15		;store loop condition in r15

;===== harmonic sum calculation =====

	mov	r14, 1		;counter for loop (n)
	movsd	xmm15, 0x3FF0000000000000 ;numerator
	movsd	xmm13, 0x0000000000000000 ;store the sum

harmonic_sum:

	cvtsi2sd xmm14, r14	;convert n into a float


	divsd	xmm15, xmm14
	addsd	xmm13, xmm15

	inc	r14
	cmp	r14, r15
	jle	harmonic_sum

;===== print out the sum of the terms =====

	mov	rax, 1
	mov	rdi, showsum
	mov	rsi, r15
	movsd	xmm0, xmm13
	call	printf

;===== print out closing statement =====

	mov	rax, 0
	mov	rdi, stringformat
	mov	rsi, closing
	call	printf

;===== return the sum to the driver =====

	movsd	xmm0, xmm13
	pop	rbp
	ret
