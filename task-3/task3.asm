global get_words
global compare_func
global sort

extern strtok
extern strcpy
extern strlen
extern strcmp
extern qsort

section .data
    delims db ' ,.', 10, 0

section .text

;; int cmp(const void*, const void*)
;  Function used by qsort
cmp_custom:
    enter   0, 0

    mov     ebx, dword[ebp + 8]     ; pointer to the first string
    mov     edx, dword[ebp + 12]    ; pointer to the second string

    mov     ebx, dword[ebx]         ; first string
    mov     edx, dword[edx]         ; second string

;; Firstly, check if the words have the same length
    push    edx                     ; save the edx register
    push    ebx                     ; argument for strlen
    call    strlen
    pop     ebx
    pop     edx

    mov     ecx, eax                ; the length of the first word

    push    ecx                     ; save the ecx value, to not
                                    ; be modified by strlen() call
                                    ; (ebx is callee saved, in cdecl)
    push    edx
    call    strlen
    pop     edx
    pop     ecx

    ;; ecx has the length of the first string, eax has the second length
    cmp     ecx, eax
    jg      longer
    jl      smaller

equal:
    ;; Use strcmp to compare the words lexicographically
    ;; (the result returned in eax will be the one generated
    ;;  by the strcmp call).
    push    edx
    push    ebx
    call    strcmp
    add     esp, 8
    jmp     out

longer:
    mov     eax, 1                  ; the first string is longer
    jmp     out
smaller:
    mov     eax, -1                 ; the second string is longer
    jmp     out

out:
    leave
    ret


;; sort(char **words, int number_of_words, int size)
;  functia va trebui sa apeleze qsort pentru soratrea cuvintelor 
;  dupa lungime si apoi lexicografix
sort:
    enter   0, 0

    push    cmp_custom              ; pointer to compare function
    push    dword[ebp + 16]         ; size of an array's element
    push    dword[ebp + 12]         ; words array size
    push    dword[ebp + 8]          ; words array
    call    qsort
    add     esp, 16

    leave
    ret


;; get_words(char *s, char **words, int number_of_words)
;  separa stringul s in cuvinte si salveaza cuvintele in words
;  number_of_words reprezinta numarul de cuvinte
get_words:
    enter   0, 0

    mov     ebx, dword[ebp + 8]     ; original string
    mov     edx, dword[ebp + 12]    ; the words string, which will be completed
    mov     ecx, dword[ebp + 16]    ; number of words that has to be extracted

;; Put the tokens in the given array, in reverse
;; order than they appear in the text
extract_all_words:
    ;; Use strtok to get all the words
    push    ecx                     ; these registers will be used immediately
    push    edx                     ; after the strtok() call, to store the   
                                    ; string in memory

    ;; eax will be NULL/pointer to the start of the original string
    ;; (in order to be used as parameter for strtok())
    cmp     ecx, dword[ebp + 16]
    jne     make_it_null
    mov     eax, ebx
    jmp     continue

make_it_null:
    mov     eax, 0

continue:
    push    delims
    push    eax                     ; NULL/pointer to start of the big string
    call    strtok
    add     esp, 8

    pop     edx
    pop     ecx

    ;; Because there is already enough space allocated to store
    ;; the token, strcpy() is used to move into memory the extracted
    ;; token (other possibility would've been to store directly
    ;; the pointer in the tokens array, without copying it (shallow copy))
    push    ecx                     ; push the used registers,
    push    edx                     ; accordingly to cdecl (ebx is callee saved)
    
    push    eax                             ; source string
    push    dword[edx + (ecx - 1) * 4]      ; destination string
    call    strcpy
    add     esp, 8
    
    pop     edx                     ; restore the registers
    pop     ecx

    loop    extract_all_words

    leave
    ret
