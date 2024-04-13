.include "telestrat.inc"

.include "ch395.inc"
.include "socket.inc"

.include "../dependencies/orix-sdk/macros/SDK_print.mac"
.include "../dependencies/orix-sdk/macros/SDK_conio.mac"

.import ch395_write_send_buf_sn
.import ch395_get_int_status_sn

.export send

.proc send
    ;;@brief Send data into socket
    ;;@inputA Socket id
    ;;@inputY Low length
    ;;@inputX High length
    ;;@inputMEM_RES ptr
    ;;@returnsA Error type

    ; A contains socket id
    jsr     ch395_write_send_buf_sn

    ldx     #$00

@waiting_for_output:
    stx     save_x

    lda     save_socket_id ; socket 0
    jsr     ch395_get_int_status_sn

    and     #CH395_SINT_STAT_SENBUF_FREE
    cmp     #CH395_SINT_STAT_SENBUF_FREE
    beq     @success

    ldx     save_x
    inx
    cpx     #$FF
    bne     @waiting_for_output

    lda     #$FF        ; Error
    rts

@success:
    lda     #$00  ; success
    rts

save_x:
    .res 1

save_socket_id:
    .res 1
.endproc
