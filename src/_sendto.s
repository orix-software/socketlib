.include "ch395.inc"
.include "sys/socket.inc"
.include "sys/socket.mac"
.include "telestrat.inc"

.export _sendto

.importzp ptr1, ptr2, ptr3, tmp1, tmp2, tmp3

.import popa, popax

.proc _sendto
    ;;@proto int sendto(unsigned char sockfd, const void *buf, size_t len, unsigned char flags, const struct sockaddr *dest_addr, socklen_t addrlen);
    addrlen   := tmp1
    dest_addr := ptr1
    flags     := tmp2
    len       := ptr2
    buf       := ptr3
    sockfd    := tmp3
    sin_port  := RESB
    sin_addr  := RES

    sta     addrlen

    ; Get dest addr
    jsr     popax
    sta     dest_addr
    stx     dest_addr + 1

    ; For compute below
    sta     sin_addr
    stx     sin_addr + 1

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



    ldy     #sockaddr_in::sin_port
    lda     (dest_addr),y
    sta     sin_port
    iny
    lda     (dest_addr),y
    sta     sin_port + 1


    ; Compute ip addr ptr
    lda     #sockaddr_in::sin_addr
    clc
    adc     sin_addr
    bcc     @S1
    inc     sin_addr + 1

@S1:
    sta     sin_addr

    CONNECT sockfd, sin_addr, sin_port
    SEND sockfd, buf, len
    rts
.endproc
