.include "telestrat.inc"

.include "../dependencies/orix-sdk/macros/SDK_print.mac"

.include "../libs/usr/include/asm/ch395.inc"

.export bind

.import ch395_set_sour_port_sn
.import ch395_open_socket_sn
.import ch395_get_cmd_status
.import ch395_tcp_listen_sn

.proc bind
    ;;@inputX Socket id
    ;;@inputA Low byte of port
    ;;@inputY High byte of port

    ;;@returnsA XX
    ;;@returnsX XX
    ;;@returnsY XX

    sta     current_socket
    jsr     ch395_set_sour_port_sn

    ; Open socket
    lda     current_socket
    jsr     ch395_open_socket_sn

    ; Waiting status
@waiting_for_socket:
    jsr     ch395_get_cmd_status
    cmp     #CH395_ERR_SUCCESS
    bne     @waiting_for_socket

    lda     current_socket ; socket 0
    jsr     ch395_tcp_listen_sn

@waiting_for_listen:
    jsr     ch395_get_cmd_status
    cmp     #CH395_ERR_SUCCESS
    bne     @waiting_for_listen


    rts

current_socket:
    .byte $FF

.endproc
