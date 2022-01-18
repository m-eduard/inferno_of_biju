section .text
	global sort

;; This is a clone for the structure defined in C,
;; used to extract the offsets for the variables
;; and the total size reserved for a node. (created
;; to avoid sizes' hardcoding, when accessing
;; structure's members and array's elements)
struc demo_node
	.val: resd 1
	.next: resd 1
endstruc

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
	enter 	0, 0

	mov 	ecx, dword[ebp + 8]			; length of the array
	xor 	eax, eax					; head node (which will be returned)
	xor 	ebx, ebx					; current node
	xor 	edx, edx					; previous node

;; Links the previous node (whose address is stored in edx)
;; to the current available minimum node, by repeatedly
;; searching for the minimum value in the nodes array.
link_nodes:
	xor ebx, ebx 					; ebx will be used to store the node with
									; minimum value from the current iteration
									; (currently NULL, ebx will be initialized
									; with the first unvisited node's address)

;; Get the minimum value, scanning only the unused nodes (a node is marked as
;; used/visited by changing its next value to something ~NULL (this random
;; value assigned will eventually be overwritten for all the nodes, except the
;; last one, whose next value will be "manually" switched to 0 in the end)).
	push 	ecx
	mov 	ecx, dword[ebp + 8]		; ecx will be a counter for the second loop

	push 	edx						; edx will be changed during min_loop
get_min:
	push 	eax						; eax will temporarily store the beginning
									; of the nodes' array
	mov 	eax, dword[ebp + 12]

	;; Find what is stored in current.next
	;; (!= NULL <=> current node was not used)
	mov 	edx, dword[eax + (ecx - 1) * demo_node_size + demo_node.next]
	pop 	eax

	test 	edx, edx				; check if the node was used (next != NULL)
	jnz 	continue_min_loop

	push eax						; eax will temporarily store the beginning
									; of the nodes' array
	mov eax, dword[ebp + 12]
	
	;; Get the value of the current node
	mov 	edx, dword[eax + (ecx - 1) * demo_node_size + demo_node.val]
	pop 	eax

	test	ebx, ebx				; if the current min wasn't initialised,
									; here it will be changed from NULL to
									; an actual node's pointer
	jz 		switch_min

	cmp 	edx, dword[ebx]			; compare the current node's value to the
									; previous minimum value, and update the
									; old value if it's necessary
	jl 		switch_min
	jmp 	continue_min_loop
switch_min:
	push 	eax
	mov 	eax, dword[ebp + 12]
	;; Update the ebx with the newly found minimum node's address
	lea 	ebx, [eax + (ecx - 1) * demo_node_size]
	pop 	eax
continue_min_loop:
	loop 	get_min
	pop 	edx						; restore edx into previous node's address
	pop 	ecx						; restore ecx to its counter value used
									; for the first for loop

;; Mark the current min node as visited, by changing the NULL
;; value froms node.next (the last node will have its next value
;; assigned to NULL in the end).
	mov 	dword[ebx + demo_node.next], 0xb00b1e5

;; Check if it's the first iteration.
	cmp 	ecx, dword[ebp + 8]
	je 		initialize_head			; if this is the first min extraction, put
									; the node in the head of the list
	jmp 	add_next

continue_loop:
	loop 	link_nodes
	jmp 	out

;; Add the newly extracted minimum node to the list.
add_next:
	mov 	dword[edx + demo_node.next], ebx
	mov 	edx, ebx				; prev_node = current_node
	jmp 	continue_loop

;; Add the minimum node as the head of the list.
initialize_head:
	mov 	eax, ebx
	mov 	edx, ebx				; prev_node = current_node
	jmp 	continue_loop

out:
	;; Set last node's next to NULL
	mov 	dword[edx + demo_node.next], 0

	leave
	ret
