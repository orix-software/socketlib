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

    ; Close socket
    txa
    jsr     ch395_close_socket_sn


    rts
.endproc

