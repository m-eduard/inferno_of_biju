section .text
	global cmmmc

;; int cmmmc(int a, int b)
;
;; calculate least common multiple fow 2 numbers, a and b
cmmmc:

;; Create the frame
	push ebp			; old ebp
	push esp
	pop ebp				; new ebp

	push dword[ebp + 8]
	pop eax				; a
	push dword[ebp + 12]
	pop ebx				; b

;; If a or b have a negative value, switch them.
	cmp eax, 0
	jge ignore1
	neg eax
ignore1:
	cmp ebx, 0
	jge ignore2
	neg ebx
ignore2:

	push eax
	pop ecx				; ecx will be a multiple of eax (used in loop)

;; Go through all the multiples of a, until either it's found a multiple of b,
;; either a * b is reached
check_multiples:
	;; prepare these registers for division
	push eax
	push edx

	push ecx
	pop eax
	shl eax, 16
	shr eax, 16

	push ecx
	pop edx
	shr edx, 16				; put the high part in dx
							; low is already in the ax
	
	div bx

	test edx, edx				; check if k * a % b == 0
							; (where k * a is the current
							; multiple of a, stored in ecx)
	jz set_return_val

	pop edx			; stack restoration
	pop eax

	add ecx, eax
	jmp check_multiples


set_return_val:
	push ecx
	pop eax

	;; take care of the stack
	; pop edx
	; pop eax

;; Leave
	push ebp			; move the stack pointer
	pop esp				; to the current base pointer

	pop ebp				; get the old base pointer
	
	ret
