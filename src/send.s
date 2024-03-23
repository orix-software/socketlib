.include "telestrat.inc"

.include "ch395.inc"
.include "socket.inc"

.include "../dependencies/orix-sdk/macros/SDK_print.mac"
.include "../dependencies/orix-sdk/macros/SDK_conio.mac"

.import ch395_write_send_buf_sn
.import ch395_get_int_status_sn

.importzp ptr1

.export send

.proc send
    ;;@brief Send data into socket
    ;;@inputX Socket id
    ;;@inputA Low ptr of the buffer
    ;;@inputY High ptr of the buffer
    ;;inputMEM_RES Size of the bufer to send

    ;;@returnsA Low byte of the length
    ;;@returnsX High byte of the length
    ;;@returnsY Error type

    ;;@```ca65
    ;;@`; Use SENDTO macro
    ;;@`  SENDTO current_socket, str_password, 11
    ;;@`  rts

    sta     RESB
    sty     RESB+1
    stx     save_socket_id

    ldy     RES
    ldx     RES+1
    lda     save_socket_id ; socket 0
    jsr     ch395_write_send_buf_sn

    ldx     #$00

@waiting_for_output:
    stx     save_x

    lda     save_socket_id ; socket 0
    jsr     ch395_get_int_status_sn

    and     #CH395_SINT_STAT_SENBUF_FREE
    cmp     #CH395_SINT_STAT_SENBUF_FREE
    beq     @success

.ifdef SOCKET_SEND_DEBUG
    print   str_debug_socket_send
    print   str_debug_socket_send_waiting_send_buffer
    crlf
.endif

    ldx     save_x
    inx
    cpx     #$FF
    bne     @waiting_for_output

    lda     #$01        ; Error
    rts

@success:
    lda     #$00  ; success
    rts

save_x:
    .res 1

save_socket_id:
    .res 1

str_debug_socket_send:
    .asciiz "[libsocket/socket_send.s] "

str_debug_socket_send_waiting_send_buffer:
    .asciiz "Waiting to have buffer send empty ..."
.endproc
