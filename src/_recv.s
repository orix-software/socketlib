.include "telestrat.inc"
.include "socket.mac"


.export _recv


.import popax
.import popa

.importzp ptr1, ptr2, tmp0

.proc _recv
    ;;@proto int recv(unsigned char s, void *buf, unsigned char len, unsigned char flags);
    length := ptr2
    buffer := ptr1
    socket := tmp0
    ; Drop flag
    jsr     popax ; Get length
    sta     ptr2
    stx     ptr2 + 1

    jsr     popax ; Get ptr
    sta     ptr1
    stx     ptr1 + 1

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
