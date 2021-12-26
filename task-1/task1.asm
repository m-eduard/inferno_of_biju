section .text
	global sort

extern puts

; struct node {
;     	int val;
;    	struct node* next;
; };

;; struct node* sort(int n, struct node* node);
; 	The function will link the nodes in the array
;	in ascending order and will return the address
;	of the new found head of the list
; @params:
;	n -> the number of nodes in the array
;	node -> a pointer to the beginning in the array
; @returns:
;	the address of the head of the sorted list
sort:
	enter 0, 0

	;mov ebx, dword[ebp + 8]				; array's first element's address
	mov ecx, dword[ebp + 8]				; length of the array
	xor eax, eax							; head node (which will be returned)
	xor edx, edx							; previous node


;; repeatedly, find the minimum val
link_nodes:
	mov ebx, dword[ebp + 12]					; ebx will be used to store the node with minimum value
											; from the current iteration

;; get the minimum value, scanning only the unused nodes
;; (which has the next == NULL)
	push ecx
	mov ecx, dword[ebp + 8]
	mov eax, ebx
get_min:
	push edx								; use edx to temporarily store the current node's value
	push eax
	mov eax, dword[ebp + 12]
	mov edx, [eax + (ecx - 1) * 8 + 4]		; check if the node wasn't used
											; the size of the structure is 8
	pop eax
	test edx, edx
	jnz ignore_current_value

	push eax
	mov eax, dword[ebp + 12]
	mov edx, [eax + (ecx - 1) * 8]		; get the value of the node
	pop eax

	cmp edx, [ebx]
	pop edx
	jge ignore_current_value
switch_global_min:
	push eax
	mov eax, dword[ebp + 12]
	lea ebx, [eax + (ecx - 1) * 8]
	pop eax
ignore_current_value:
	loop get_min
	pop ecx

	;; use the newly extracted minimum node
	cmp ecx, dword[ebp + 8]				; check if it's the first operation performed, to put the node in the head of the list
	mov dword[ebx + 4], 0xb00b1e5		; mark the current min node as visited (by changing the NULL value in node.next (the
										; last node will have its next value changed into NULL in the end))
	je initialize_head
	jmp add_next

continue_loop:
	loop link_nodes
	jmp out

add_next:
	mov dword[edx + 4], ebx				; 4 is the offset for the next value in structure (bcs sizeof(int) on this 32 bits architecture is 4 bytes)
	jmp continue_loop

initialize_head:
	mov eax, ebx
	mov edx, ebx
	jmp continue_loop

out:
	mov dword[ebx + 4], 0

	leave
	ret
