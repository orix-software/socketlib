.include "telestrat.inc"
.include "socket.mac"

.export _recv


.import popax
.import popa

.importzp ptr1, ptr2, tmp1, tmp2

.proc _recv
    ;;@proto int recv(unsigned char s, void *buf, unsigned int len, unsigned char flags);
    ;;@brief Does not handle flags
    length := ptr2
    buffer := ptr1
    socket := tmp1
    flags := tmp2
    ; Drop flag

    sta     flags ; Flags stored but not managed

    jsr     popax ; Get length
    sta     length
    stx     length + 1

    ; Get buffer
    jsr     popax ; Get ptr
    sta     buffer
    stx     buffer + 1

    jsr     popa  ; Get socket id
    sta     socket

    ;;@inputA Socket id
    ;;@inputX Low ptr to store the buffer
    ;;@inputY High ptr to store the buffer
    ;;@modifyMEM_RES

    ldy    ptr1
    ldx    ptr1 + 1

    RECV socket, buffer, length
    tya
    stx     ptr1 + 1
    ldy     ptr1 + 1

    rts
.endproc
