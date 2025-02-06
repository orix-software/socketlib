.include "ch395.inc"
.include "sys/socket.inc"
.include "sys/socket.mac"
.include "telestrat.inc"

.export _recvfrom

.importzp ptr1, ptr2, ptr3, tmp1, tmp2, tmp3

.import popa, popax

.proc _recvfrom
    ; int recvfrom(unsigned char sockfd, void *buf, size_t len, unsigned char flags, struct sockaddr *src_addr, socklen_t *addrlen);
    addrlen   := tmp1
    dest_addr := ptr1
    flags     := tmp2
    len       := ptr2
    buf       := ptr3
    sockfd    := tmp3

    sta     addrlen

    ; Get dest addr
    jsr     popax
    sta     ptr1
    stx     ptr1 + 1

    jsr     popa
    sta     flags

    jsr     popax
    sta     len
    stx     len + 1

    jsr     popax
    sta     buf
    stx     buf + 1

    jsr     popa
    sta     sockfd

    ldy     buf
    ldx     buf + 1

    RECV sockfd, buf, length
    tya
    stx     buf + 1
    ldy     buf + 1

    rts
.endproc
