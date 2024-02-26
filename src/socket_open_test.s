;debug_socket = 1
.include "errno.inc"
.include "../libs/usr/include/asm/ch395.inc"
.include "include/socket.inc"
.include "../dependencies/orix-sdk/macros/SDK_print.mac"
.include "../dependencies/orix-sdk/macros/SDK_conio.mac"
.include "telestrat.inc"

.export socket_open_test
.import ch395_get_socket_status_sn
.import ch395_get_int_status_sn
.import ch395_open_socket_sn
.import ch395_tcp_connect_sn
.import socket_protocol

.proc socket_open_test
    ; save socket id
    sta     save_socket_id

    ; Waiting status
    ldx     #$00

@waiting_for_socket:
    stx     save_x
    lda     save_socket_id
    jsr     ch395_get_socket_status_sn

    cmp     #CH395_SOCKET_OPEN
    beq     @continue

    cmp     #CH395_ERR_BUSY
    beq     @exit_busy

    ; open socket
    lda     save_socket_id
    jsr     ch395_open_socket_sn

@waiting:
    ldx     save_x
    inx
    cpx     #100
    beq     @exit_near
    jmp     @waiting_for_socket

@exit_near:
    lda     #ENOTCONN ; return error
    rts

@socket_used:
    jmp     @exit_near

@exit_busy:
    lda     #EBUSY
    rts

@exit:
    rts

@continue:

.ifdef  SOCKET_OPEN_DEBUG
    print   str_socket_opened
.endif

    ldx     save_socket_id
    lda     socket_protocol,x
    cmp     #SOCK_DGRAM   ; Udp ? yes
    beq     @connected
    cmp     #SOCK_RAW
    beq     @init_waiting_connection

   ; cmp     #IP

    lda     save_socket_id
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
    lda     save_socket_id ; socket 0
    jsr     ch395_get_int_status_sn
    and     #CH395_SINT_STAT_CONNECT
    cmp     #CH395_SINT_STAT_CONNECT
    beq     @connected_tcp
    ldx     save_x
    inx
    cpx     #2
    bne     @waiting_for_connection
    dey
    bne     @waiting_for_connection
    lda     #ECONNREFUSED
    rts

@connected_tcp:
    print   str_socket_opened_tcp
    lda     #$00
    rts

@connected:
    print   str_socket_opened_udp
    lda     #$00
    rts

save_x:
    .res 1

save_y:
    .res 1

save_socket_id:
    .res 1

str_socket_opened_tcp:
    .byte "[libsocket/socket_open_test.s][TCP] Socket opened",$0A,$0D,$00

str_socket_opened_udp:
    .byte "[libsocket/socket_open_test.s][UDP] Socket opened",$0A,$0D,$00

str_socket_opened:
    .byte"[libsocket/socket_open_test.s] Socket opened",$0A,$0D,$00

str_socket_opening:
    .byte"[libsocket/socket_open_test.s] Opening socket ...",$0A,$0D,$00
.endproc
