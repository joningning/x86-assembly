org 100h              

mov ax, 0B800h         
mov ds, ax             
mov es, ax             

; Constants
mov bx, 160    
mov dx, 80         

; Outer Loop
mov cx, 80             
rotate_loop:
    ; Rotate row to right
    mov si, 0          ; first row
    mov di, si
    call rotate_right  ; rotate to right

    ; second line
    mov si, 160        ; second line 
    mov di, si
    call rotate_left   ; rotate left

    ; delay lol
    call delay

    dec dx	     ; 
    jne rotate_loop  ; Repeat for the number of rotations

int 20h                ; EEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEENNNNNNDDDDDDDDDD

;SUBROUTINE

rotate_right:
    push cx            ; para sa outer loop counter

    ; Save character and the color
    mov al, [ds:si+158]
    mov ah, [ds:si+159]

    ; Shift to right
    mov cx, 79         ; Process 79 columns ONLY 
    lea di, [si+158]   ; Start from last character pair
shift_right:
    mov bl, [ds:di-2]
    mov bh, [ds:di-1]
    mov [ds:di], bl
    mov [ds:di+1], bh
    sub di, 2
    loop shift_right

    ; Restore the saved character to the first column
    mov [ds:si], al
    mov [ds:si+1], ah

    pop cx             ; Restore outer loop counter
    ret

;mga subroutines
rotate_left:
    push cx            ; Preserve outer loop counter

    ; Save the first character and attribute
    mov al, [ds:si]
    mov ah, [ds:si+1]

    ; Shift all characters to the left
    mov cx, 79         ; Process 79 columns (excluding the first)
    lea di, [si]       ; Start from the first character pair
shift_left:
    mov bl, [ds:di+2]
    mov bh, [ds:di+3]
    mov [ds:di], bl
    mov [ds:di+1], bh
    add di, 2
    loop shift_left

    ; Restore the saved character to the last column
    mov [ds:si+158], al
    mov [ds:si+159], ah

    pop cx             ; Restore outer loop counter
    ret

; DELAY SUBROUTINEEEEE
delay:
    mov cx, 0FFFFh     ; Outer delay loop
delay_loop:
    dec cx
    jnz delay_loop
    ret