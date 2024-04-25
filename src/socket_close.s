; X contains the id of the socket
.include "../dependencies/orix-sdk/macros/SDK_print.mac"
.include "../dependencies/orix-sdk/macros/SDK_conio.mac"
.include "telestrat.inc"
.include "ch395.inc"
.include "socket.inc"

.export socket_close

.import ch395_close_socket_sn
.import ch395_get_cmd_status
.import ch395_get_socket_status_sn
.import socket_state
.import ch395_clear_recv_buf_sn
.import ch395_tcp_disconnect_sn

.proc socket_close
    ;;@brief Close socket
    ;;@inputX The socket id

    ;CMD_CLOSE_SOCKET_SN
    ;This command is used to close Socket. It is necessary to input a 1 byte of Socket index value. After Socket is
    ;closed, the receive buffer and transmit buffer of Socket are emptied, but the configuration information is still
    ;reserved, and you just need to open the Socket again when using the Socket the next time.
    ;In TCP mode, CH395 will automatically disconnect TCP before turning off Socket

    lda     #$00
    sta     socket_state,x

    txa
    ; Flush buffers

    jsr     ch395_close_socket_sn

    rts
.endproc

