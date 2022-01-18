section .text
	global intertwine

;; void intertwine(int *v1, int n1, int *v2, int n2, int *v);
;
;  Take the 2 arrays, v1 and v2 with varying lengths, n1 and n2,
;  and intertwine them
;  The resulting array is stored in v
intertwine:
	enter 	0, 0

	;; rdi - 1st argument
	;; rsi - 2nd argument
	;; rdx - 3rd argument
	;; rcx - 4th argument
	;; r8  - 5th argument

	;; Put the minimum length in the r9 register
	cmp 	rsi, rcx
	jl		first_is_min
	jmp		second_is_min
first_is_min:
	mov 	r9, rsi
	jmp 	continue
second_is_min:
	mov 	r9, rcx
	jmp 	continue

;; Intertwine the first k elements of the given arrays,
;; where k is the min(length1, length2)
continue:
	mov 	rax, 0			; used as counter
through_arrays:
	mov 	r10d, dword[rdi + rax * 4]
	mov		dword[r8 + (rax * 2) * 4], r10d
	mov 	r10d, dword[rdx + rax * 4]
	mov 	dword[r8 + (rax * 2 + 1) * 4], r10d

	inc 	rax
	cmp 	rax, r9
	jl 		through_arrays

;; Add the remaining elements of the first/second array
	lea 	r11, [rax * 2]			; the current position in the result array
through_first_array:
	cmp 	rax, rsi				; check if the last index was not exceeded
	jge		through_second_array

	mov 	r10d, dword[rdi + rax * 4]
	mov 	dword[r8 + r11 * 4], r10d

	inc 	r11
	inc 	rax
	jmp		through_first_array

;; If the remaining elements was from the first array,
;; then the original rax was equal to the length
;; of the second array => after increasing in the
;; first for, rax is greater than the 2nd array length,
;; so this for won't be executed;
;; Else, the current index from the result array was not
;; modified, since the first for was not executed and
;; the remaining elements from 2nd array are copied
through_second_array:
	cmp 	rax, rcx				; check if the last index was not exceeded
	jge		out

	mov 	r10d, dword[rdx + rax * 4]
	mov 	dword[r8 + r11 * 4], r10d

	inc 	r11
	inc 	rax
	jmp 	through_second_array

out:
	leave
	ret
