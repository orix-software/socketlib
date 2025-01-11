.include "telestrat.inc"
.include "socket.mac"

.export _send

.import popax
.import popa

.importzp ptr1, tmp1, tmp2

.proc _send
    ;;@proto unsigned int send(unsigned char sockfd, const void buf[], unsigned int len, unsigned char flags);
    ;;@brief Does not handle flags
    ;; send(sock, request, strlen(request), 0) == -1)
    socket := tmp1
    buffer := ptr1
    length := RESB
    flags  := tmp2

    ; Don't use flags
    sta     flags ; Stored but not managed

    ; Get length
    jsr     popax
    sta     length
    stx     length + 1

    ; get buf ptr
    jsr     popax
    sta     ptr1
    stx     ptr1 + 1

    jsr     popa ; Get socket id
    sta     socket

    SEND socket, buffer, length
    rts
.endproc
