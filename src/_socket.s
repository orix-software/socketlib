.include "ch395.inc"
.include "include/socket.inc"
.include "../dependencies/orix-sdk/macros/SDK_print.mac"
.include "../dependencies/orix-sdk/macros/SDK_conio.mac"
.include "telestrat.inc"

.import socket_state
.import socket_protocol

.export _socket
.import socket

.import ch395_set_ipraw_pro_sn
.import ch395_set_proto_type_sn

.import popa

.proc _socket
    ;;@brief Open a socket
    ;;@proto unsigned char socket (unsigned char  domain, unsigned char  __type, unsigned char protocol);
    ;; sock = socket(AF_INET, SOCK_STREAM, 0);

    ;;@` lda     #$00
    ;;@` ldx     #AF_INET      ; domain
    ;;@` ldy     #SOCK_STREAM  ; type
    ;;@` jsr     socket

    ; Skip protocol
    jsr     popa
    sta     RES+1 ; type

    jsr     popa ; domain

    tax

    lda     #$00
    ldy     RES+1

    jmp     socket
.endproc
