.include "socket.inc"
.include "telestrat.inc"
.include "ch395.inc"

.export _connect
.import connect

.import popax
.import popa

.importzp ptr1,ptr2

.proc _connect
    ; connect(sock, (struct sockaddr *)&server_addr, sizeof(server_addr)) == -1
    ; A and X contains the size

    jsr     popax ; Get ptr server addr
    sta     ptr1
    sta     ptr2

    stx     ptr1+1
    stx     ptr2+1 ; For next compute below

; .struct sockaddr_in
;    sin_family .byte ; e.g. AF_INET
;    sin_port   .word   ; e.g. htons(3490)
;    sin_addr   .res 4  ;long sin_addr
; .endstruct

    ldy     #sockaddr_in::sin_port
    lda     (ptr1),y
    sta     RESB
    iny
    lda     (ptr1),y
    sta     RESB+1

    ; Compute ip addr ptr
    lda     #sockaddr_in::sin_addr
    clc
    adc     ptr2
    bcc     @S1
    inc     ptr2+1

@S1:
    sta     ptr2

    ; Get sockfd
    jsr     popa

    ;;@inputA Socket id
    ;;@inputY Low ip dest
    ;;@inputX High ip dest
    ;;@inputMEM_RESB Low/high dest port

    ldy     ptr2
    ldx     ptr2+1

    jmp     connect

.endproc
