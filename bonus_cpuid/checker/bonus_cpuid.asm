section .text
	global cpu_manufact_id
	global features
	global l2_cache_info

;; void cpu_manufact_id(char *id_string);
;
;  reads the manufacturer id string from cpuid and stores it in id_string
cpu_manufact_id:
	enter 	0, 0
	mov eax, [ebp + 8]

	; in cdecl convention, only eax, ecx and edx are caller saved;
	; so I have to save ebx on the stack in order to avoid a sefault
	push ebx
	
	push eax
	mov eax, 0x0
	cpuid
	pop eax

	mov [eax], ebx
	mov [eax + 4], edx
	mov [eax + 8], ecx
	mov byte [eax + 12], 0

	pop ebx

	leave
	ret

;; void features(char *vmx, char *rdrand, char *avx)
;
;  checks whether vmx, rdrand and avx are supported by the cpu
;  if a feature is supported, 1 is written in the corresponding variable
;  0 is written otherwise
features:
	enter 	0, 0
	
	leave
	ret

;; void l2_cache_info(int *line_size, int *cache_size)
;
;  reads from cpuid the cache line size, and total cache size for the current
;  cpu, and stores them in the corresponding parameters
l2_cache_info:
	enter 	0, 0
	
	leave
	ret
