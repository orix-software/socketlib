; X contains the id of the socket
.include "../dependencies/orix-sdk/macros/SDK_print.mac"
.include "../dependencies/orix-sdk/macros/SDK_conio.mac"
.include "telestrat.inc"

SOCKET_CLOSE_DEBUG=0

.export socket_close

.import ch395_close_socket_sn
.import ch395_get_cmd_status
.import ch395_get_socket_status_sn
.import socket_state

.proc socket_close
    ;;@brief Close socket
    ;;@inputX The socket id

    lda     #$00
    sta     socket_state,x

.ifdef SOCKET_CLOSE_DEBUG
    ; save socket id
    txa
    pha
    print str_closing_socket
    pla
    pha
    txa
    ldy     #$00
    ldx     #$20 ;
    stx     DEFAFF
    ldx     #$00
    BRK_TELEMON XDECIM
    crlf
    pla
    tax
.endif

    ; Close socket
    txa
    jsr     ch395_close_socket_sn

.ifdef SOCKET_CLOSE_DEBUG
    print str_closing_socket_cmd
    jsr     ch395_get_cmd_status
    print_int , 2, 2
    crlf
    print   str_closing_socket_status
    jsr     ch395_get_socket_status_sn
    print_int , 2, 2
    crlf
.endif

    rts
.endproc

.ifdef SOCKET_CLOSE_DEBUG

str_closing_socket:
    .byte "[libsocket/socket_close.s] Closing socket ... ",$00

str_closing_socket_cmd:
    .byte "[libsocket/socket_close.s] Command status : ",$00

str_closing_socket_status:
    .byte "[libsocket/socket_close.s] Socket status : ",$00

.endif

