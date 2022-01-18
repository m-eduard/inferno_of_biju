section .text
	global cpu_manufact_id
	global features
	global l2_cache_info

;; void cpu_manufact_id(char *id_string);
;
;  reads the manufacturer id string from cpuid and stores it in id_string
cpu_manufact_id:
	enter 	0, 0

	; In cdecl convention, only eax, ecx and edx are caller saved;
	; Since ebx is modified by cpuid, I have to save ebx on the stack,
	; in order to avoid a sefault.
	push 	ebx
	
	mov 	eax, 0
	cpuid

	mov 	eax, dword[ebp + 8]

	mov 	[eax], ebx				; the first 4 bits of the name
	mov 	[eax + 4], edx			; the second 4 bits sequence
	mov 	[eax + 8], ecx			; the last 4 bits sequence from the name

	pop 	ebx
	leave
	ret

;; void features(int *vmx, int *rdrand, int *avx)
;
;  checks whether vmx, rdrand and avx are supported by the cpu
;  if a feature is supported, 1 is written in the corresponding variable
;  0 is written otherwise
features:
	enter 	0, 0
	push	ebx

	mov 	eax, 1					; when EAX = 1, cpuid returns cpu features
	cpuid

;; vmx availability is on the 6th least significant bit from ecx
;; (the bit on index 5, if indexing starts from 0)
	mov 	eax, dword[ebp + 8]
	push 	ecx						; store the value returned from cpuid call
	shl		ecx, 27					; 31 - 5
	shr		ecx, 31
	test	ecx, ecx				; check if the bit was 1 or 0
	jz		no_vmx
	mov		dword[eax], 1
continue_vmx:
	pop		ecx

;; rdrand availability is on the 31th bit
	mov 	eax, dword[ebp + 12]
	push 	ecx					; store the value returned from cpuid call
	shl 	ecx, 1				; 31 - 30
	shr		ecx, 31
	test 	ecx, ecx
	jz 		no_rdrand
	mov 	dword[eax], 1
continue_rdrand:
	pop		ecx

;; avx availability is on the 29th bit
	mov		eax, dword[ebp + 16]
	push 	ecx					; store the value returned from cpuid call
	shl 	ecx, 3				; 31 - 29
	shr		ecx, 31
	test 	ecx, ecx
	jz 		no_avx
	mov 	dword[eax], 1
continue_avx:
	pop		ecx
	jmp		out

no_vmx:
	mov		dword[eax], 0
	jmp 	continue_vmx
no_rdrand:
	mov		dword[eax], 0
	jmp 	continue_rdrand
no_avx:
	mov 	dword[eax], 0
	jmp		continue_avx

out:
	pop 	ebx
	leave
	ret

;; void l2_cache_info(int *line_size, int *cache_size)
;
;  reads from cpuid the cache line size, and total cache size for the current
;  cpu, and stores them in the corresponding parameters
l2_cache_info:
	enter 	0, 0
	push 	ebx

	mov		eax, 80000006h			; to get the L2 features
	cpuid

	; L2 cache line size: [7-0]bits
	push	ecx						; save the ecx value after cpuid call
	shl		ecx, 24					; 31 - 7
	shr		ecx, 24					; 31 - 7

	mov 	eax, dword[ebp + 8]		; use the given pointer to save the value
	mov 	dword[eax], ecx
	pop		ecx

	; L2 cache size: [31-16]bits
	shr		ecx, 16					; 31 - 15

	mov 	eax, dword[ebp + 12]
	mov 	dword[eax], ecx
	
	pop		ebx
	leave
	ret
