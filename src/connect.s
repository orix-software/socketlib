;debug_socket = 1
.include "errno.inc"
.include "ch395.inc"
.include "socket.inc"
.include "../dependencies/orix-sdk/macros/SDK_print.mac"
.include "../dependencies/orix-sdk/macros/SDK_conio.mac"
.include "telestrat.inc"

.export connect

.import ch395_get_socket_status_sn
.import ch395_get_int_status_sn
.import ch395_open_socket_sn
.import ch395_tcp_connect_sn
.import ch395_set_sour_port_sn
.import ch395_set_des_port_sn
.import ch395_set_ip_addr_sn
.import ch395_close_socket_sn

.import socket_state
.import socket_sour_port

.proc connect
    ;;@brief Perform connect to socket. Returns socket error if something is wrong
    ;;@inputA Socket id
    ;;@inputY Low ip dest
    ;;@inputX High ip dest
    ;;@inputMEM_RESB  dest port value (16 bits)
    ;;@modifyMEM_TR0  Used to save socket
    ;;@modifyMEM_RES tmp

    ;;@```ca65
    ;;@` lda     #00  ; Port 80
    ;;@` sta     RESB
    ;;@` lda     #80  ; Port
    ;;@` sta     RESB+1
    ;;@` lda     #$00 ; Socket id
    ;;@` ldy     #<ip
    ;;@` ldx     #>ip
    ;;@` jsr     connect
    ;;@`ip:
    ;;@`   .byte 192,168,1,77
    ;;@```

    sta     TR0
    jsr     ch395_set_ip_addr_sn ; Warn Use RES

    lda     TR0
    ldx     RESB
    ldy     RESB+1
    jsr     ch395_set_des_port_sn



    ; Rotate source port

    ldy     $309 ; Get source port mapping
    ;tay
    ldx     #$00
    lda     TR0
    jsr     ch395_set_sour_port_sn ; Use RES
    inc     socket_sour_port


    lda     TR0
    jsr     ch395_get_socket_status_sn

    cmp     #CH395_SOCKET_OPEN
    bne     @open_socket

    lda     TR0
    jsr     ch395_close_socket_sn


@open_socket:
    ; Waiting status
    ldx     #$00

@waiting_for_socket:
    stx     save_x
    lda     TR0
    jsr     ch395_get_socket_status_sn

    cmp     #CH395_SOCKET_OPEN
    beq     @continue


    ; open socket
    lda     TR0
    jsr     ch395_open_socket_sn

@waiting:
    ldx     save_x
    inx
    cpx     #100
    beq     @exit_near
    jmp     @waiting_for_socket

@exit_near:
    ; Not connected
    lda     #SOCKET_ERROR ; return error
    rts

@socket_used:
    jmp     @exit_near



@exit:
    rts

@continue:
    ldx     TR0
    lda     socket_state,x
    cmp     #SOCK_DGRAM   ; Udp ? yes
    beq     @connected
    cmp     #SOCK_RAW
    beq     @init_waiting_connection

   ; cmp     #IP

    lda     TR0
    jsr     ch395_tcp_connect_sn

@init_waiting_connection:
; Waiting for connection
    ldy     #$00
    ldx     #$00

@waiting_for_connection:
    stx     save_x
    sty     save_y

    ;print   str_socket_opening

    ldy     save_y
    ldx     save_x
    lda     TR0 ; socket 0
    jsr     ch395_get_int_status_sn
    and     #CH395_SINT_STAT_CONNECT
    cmp     #CH395_SINT_STAT_CONNECT
    beq     @connected_tcp
    ldx     save_x
    inx
    cpx     #$02
    bne     @waiting_for_connection
    dey
    bne     @waiting_for_connection
    ; Connection refused
    lda     #SOCKET_ERROR
    rts

@connected_tcp:
    lda     #$00 ; OK
    rts

@connected:
    lda     #$00 ; OK
    rts

save_x:
    .res 1

save_y:
    .res 1
.endproc
