.include "ch395.inc"
.include "include/socket.inc"
.include "../dependencies/orix-sdk/macros/SDK_print.mac"
.include "../dependencies/orix-sdk/macros/SDK_conio.mac"
.include "telestrat.inc"

.import socket_state
.import socket_protocol

SOCKET_DEBUG = 1

.import socket
.export _socket

.import ch395_set_ipraw_pro_sn
.import ch395_set_proto_type_sn

.import popa

.proc _socket
    ;;@brief Open a socket
    ;;@proto unsigned char socket (unsigned char  domain, unsigned char  __type, unsigned char protocol);
    ; Protocol
    ;sta     RES
    jsr     popa
    sta     RES+1 ; type
    jsr     popa ; domain

    tax

    lda     #$00
    ldy     RES+1

.endproc




.ifdef SOCKET_DEBUG

str_opening_socket:
    .byte "[libsocket/socket.s] Opening socket  ",$0A,$0D,$00

str_socket_overflow:
    .byte "[libsocket/socket.s] id Socket overflow",$0A,$0D,$00

str_allocating_socket_id:
    .byte "[libsocket/socket.s] Allocating socket id : ",$00

debug_save_A:
    .res 1

debug_save_X:
    .res 1

debug_save_Y:
    .res 1
.endif
