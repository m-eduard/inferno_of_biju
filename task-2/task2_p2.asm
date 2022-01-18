section .text
	global par

;; int par(int str_length, char* str)
;
; check for balanced brackets in an expression
par:

;; Create the frame for the function
	push 	ebp
	push 	esp
	pop 	ebp

	push 	1
	pop 	eax						; used to return the result (will
									; be switched to 0 if the sequence is invalid)

	push 	dword[ebp + 12]
	pop 	ebx						; the beginning of the string

	push 	dword[ebp + 8]
	pop 	edx						; the length of the string

	xor 	ecx, ecx				; counter for the loop

;; Go through the string and if it's an opening paranthesis,
;; push it into the stack; else pop the top of the stack
through_parantheses:
	cmp 	byte[ebx + ecx * 1], '('
	jne 	pop_from_stack
	push 	'('
	jmp 	continue

pop_from_stack:
	cmp 	esp, ebp				; check if the pop can be done without
									; exceeding the current function's frame
	je 		fail
	add 	esp, 4					; "pop" the top of the stack

continue:
	inc 	ecx
	cmp 	ecx, edx
	jl 		through_parantheses
	jmp 	check_empty_stack

;; Check if all the parantheses pushed into
;; the stack were popped
check_empty_stack:
	cmp 	esp, ebp
	jne 	fail
	jmp 	out

fail:
	xor 	eax, eax

out:
	push 	ebp
	pop 	esp
	pop 	ebp						; leave this function's frame
	ret
