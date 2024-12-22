.include "include/socket.mac"
.include "telestrat.inc"

.export _socket

.import popa
.importzp tmp0, tmp1, tmp2

.proc _socket
    ;;@brief Open a socket
    ;;@proto unsigned char socket (unsigned char  domain, unsigned char  __type, unsigned char protocol);
    ;; sock = socket(AF_INET, SOCK_STREAM, 0);

    protocol := tmp0
    type     := tmp1
    domain   := tmp2

    ; Skip protocol
    sta     protocol

    jsr     popa
    sta     RES+1 ; type
    sta     type

    jsr     popa ; domain
    sta     domain

    SOCKET domain, type, protocol
    rts

.endproc
