.include "include/sys/socket.mac"
.include "telestrat.inc"

.export _socket

.import popa
.importzp tmp1, tmp2, tmp3

.proc _socket

    ;;@brief Open a socket
    ;;@proto unsigned char socket (unsigned char  domain, unsigned char  __type, unsigned char protocol);
    ;;@param domain The communication domain (e.g., AF_INET)
    ;;@param __type The type of socket (e.g., SOCK_STREAM)
    ;;@param protocol The protocol to be used (e.g., IPPROTO_TCP)
    ;; sock = socket(AF_INET, SOCK_STREAM, 0);

    protocol := tmp1
    type     := tmp2
    domain   := tmp3

    ; Skip protocol
    sta     protocol

    jsr     popa
    sta     RES + 1 ; type
    sta     type

    jsr     popa ; domain
    sta     domain

    SOCKET domain, type, protocol

    rts

.endproc
