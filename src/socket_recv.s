; X socket
; AY ptr


; Output :
; Y error
; Timemout  => (#ETIMEDOUT)
; OK  => (#EOK) - A and X contains the length
.include "include/socket.inc"
.include "../libs/usr/include/asm/ch395.inc"

.import ch395_get_glob_int_status
.import ch395_get_int_status_sn
.import ch395_get_recv_len_sn
.import ch395_read_recv_buf_sn

.importzp ptr1

.include "errno.inc"

.proc socket_recv
    ;;@brief Get socket data
    ;;@inputX Socket id
    ;;@inputA Low ptr to store the buffer
    ;;@inputY Low ptr to store the buffer
    ;socket_test
    stx     save_socket_id
    sta     ptr1
    sty     ptr1+1

    lda     CH395_GINT_STAT_SOCKX,x
    sta     socket_test
    ;CH395_GINT_STAT_SOCK0


;SINT_STAT_RECV
@restart_read_interrupt_socket:
    ldx     #$00

@read_bytes_test:
    stx     save_x

    jsr     ch395_get_glob_int_status

    and     socket_test
    cmp     socket_test
    beq     @read_buffer

    ldy      #$00

@wait:
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    dey
    bne     @wait

    ldx     save_x

    inx
    cpx     #255            ; Ne pas faire moins car l'interruption peut mettre du temps
    bne     @read_bytes_test
    jmp     @exit_get

    rts

@read_buffer:
    lda     save_socket_id                  ; Set socket
    jsr     ch395_get_int_status_sn        ; Get global IRQ

    and     #CH395_SINT_STAT_RECV           ; Do we received something ?
    cmp     #CH395_SINT_STAT_RECV
    beq     @read_buffer_here

.ifdef SOCKET_DEBUG
    print   str_debug_socket_recv
    print   str_debug_socket_recv_waiting_buffer
    crlf
.endif

    jmp     @restart_read_interrupt_socket

@read_buffer_here:
    lda     save_socket_id ; socket 0
    jsr     ch395_get_recv_len_sn

@store:
    cmp     #$00
    bne     @continue_reading
    cpx     #$00
    bne     @continue_reading
    jmp     @exit_get

@continue_reading:
    sta     length_receveived
    stx     length_receveived+1

.ifdef SOCKET_DEBUG
    print   str_debug_socket_recv
    print   str_debug_socket_recv_received_buffer

    lda     length_receveived
    ldy     length_receveived+1
    print_int ,2,2
    crlf
.endif

    ; Read buffer

    ldx     length_receveived+1
    ldy     length_receveived

    lda     save_socket_id ; socket 0
    jsr     ch395_read_recv_buf_sn

    lda     length_receveived
    ldx     length_receveived+1

    ldy     #EOK
    rts

@exit_get:
    ldy     #ETIMEDOUT
    lda     #$00

    rts

length_receveived:
    .res 2

socket_test:
    .res 1

save_x:
    .res 1

save_socket_id:
    .res 1

str_debug_socket_recv:
    .asciiz "[libsocket/socket_recv.s] "

str_debug_socket_recv_waiting_buffer:
    .asciiz "Waiting recv buffer ... "

str_debug_socket_recv_received_buffer:
    .asciiz "Received recv buffer bytes : "
.endproc

CH395_GINT_STAT_SOCKX:
    .byte   CH395_GINT_STAT_SOCK0
    .byte   CH395_GINT_STAT_SOCK1
    .byte   CH395_GINT_STAT_SOCK2
    .byte   CH395_GINT_STAT_SOCK3
    ; .byte   CH395_GINT_STAT_SOCK4
    ; .byte   CH395_GINT_STAT_SOCK5
    ; .byte   CH395_GINT_STAT_SOCK6
    ; .byte   CH395_GINT_STAT_SOCK7
