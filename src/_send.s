.include "telestrat.inc"
.include "socket.mac"

.export _send

.import popax
.import popa

.importzp ptr1, tmp0

.proc _send
    ;;@proto unsigned int recv(unsigned char s, void *buf, unsigned int len, unsigned char flags);
    ;; send(sock, request, strlen(request), 0) == -1)
    socket := tmp0
    buffer := ptr1
    length := RES
    ; Don't use flags

    ; Get length
    jsr     popax
    sta     RES
    stx     RES+1

    ; get buf ptr
    jsr     popax
    sta     ptr1
    stx     ptr1+1

    jsr     popa ; Get socket id
    sta     socket


    SEND socket, buffer, length
.endproc
