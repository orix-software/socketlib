.include "ch395.inc"
.include "sys/socket.inc"
.include "sys/socket.mac"
.include "telestrat.inc"

.export _connect

.import popax
.import popa

.importzp ptr1, ptr2, ptr3, tmp1

.proc _connect
    ; connect(sock, (struct sockaddr *)&server_addr, sizeof(server_addr)) == -1
    ; A and X contains the size
    dest_port := RESB
    ip        := ptr2
    socket    := tmp1

    ; store struct size but, it's not used
    sta     ptr3
    stx     ptr3 + 1

    jsr     popax ; Get ptr server addr


    sta     ptr1
    stx     ptr1 + 1

    sta     ptr2
    stx     ptr2 + 1 ; For next compute below

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
    sta     RESB + 1



    ; Compute ip addr ptr
    lda     #sockaddr_in::sin_addr
    clc
    adc     ptr2
    bcc     @S1
    inc     ptr2 + 1

@S1:
    sta     ptr2

    ; Get sockfd
    jsr     popa
    sta     socket

    CONNECT socket, ip, dest_port

    rts
.endproc
