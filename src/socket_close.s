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
.import ch395_clear_recv_buf_sn

.proc socket_close
    ;;@brief Close socket
    ;;@inputX The socket id

    lda     socket_state,x
    cmp     #SOCK_DGRAM
    bne     @is_not_tcp_connexion

    txa
    jsr     ch395_tcp_disconnect_sn ; Modify Y and A in v2024.2 ch395 lib

@is_not_tcp_connexion:
    lda     #$00
    sta     socket_state,x


    txa
    ; Flush buffers
    pha
    lda     curl_current_socket
    jsr     ch395_clear_recv_buf_sn
    ; Close socket
    pla
    jsr     ch395_close_socket_sn

    rts
.endproc

