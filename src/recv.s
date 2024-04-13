.include "socket.inc"
.include "ch395.inc"
.include "telestrat.inc"

.export recv

.import ch395_get_glob_int_status
.import ch395_get_int_status_sn
.import ch395_get_recv_len_sn
.import ch395_read_recv_buf_sn

.include "errno.inc"

.proc recv
    ;;@brief Get socket data
    ;;@inputA Socket id
    ;;@inputY Low ptr to store the buffer
    ;;@inputX High ptr to store the buffer
    ;;@modifyMEM_RES
    ;;@returnsA Error type
    ;;@returnsX Low length
    ;;@returnsY High length
    sta     save_socket_id
    sty     RES
    stx     RES+1

    tax
    lda     CH395_GINT_STAT_SOCKX,x
    sta     socket_test

@restart_read_interrupt_socket:
    ldx     #$00

@read_bytes_test:
    stx     save_x

    jsr     ch395_get_glob_int_status

    and     socket_test
    cmp     socket_test
    beq     @read_buffer

    ldy      #$00
    ; Use DELAY_100US command (fixme)from ch376
; This command is used to delay for 100uS and does not support serial port mode. The output data is 0 during 
; delay, and is non-0 (usually the chip version number) at the end of the delay. MCU determines whether the 
; delay is ended according to the read data.

;     lda     #CH376_DELAY_100US
;     sta     CH376_COMMAND

; @loop_wait:
;     lda     CH376_DATA
;     beq     @loop_wait

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
    cpx     #255                            ; Ne pas faire moins car l'interruption peut mettre du temps
    bne     @read_bytes_test
    jmp     @exit_get

@read_buffer:
    lda     save_socket_id                  ; Set socket
    jsr     ch395_get_int_status_sn         ; Get global IRQ

    and     #CH395_SINT_STAT_RECV           ; Do we received something ?
    cmp     #CH395_SINT_STAT_RECV
    beq     @read_buffer_here

    jmp     @restart_read_interrupt_socket

@read_buffer_here:
    lda     save_socket_id ; socket 0
    jsr     ch395_get_recv_len_sn
    sta     $7000
    stx     $7001

@store:
    cmp     #$00
    bne     @continue_reading
    cpx     #$00
    bne     @continue_reading
    jmp     @exit_get

@continue_reading:
    sta     length_receveived
    stx     length_receveived+1


    ; Read buffer
    lda     save_socket_id ; socket 0
    ldy     length_receveived
    ldx     length_receveived+1


    jsr     ch395_read_recv_buf_sn

    ldy     length_receveived
    ldx     length_receveived+1

    lda     #EOK
    rts

@exit_get:
    ; Timeout
    lda     #$FF
    ldx     #$00

    rts

length_receveived:
    .res 2

socket_test:
    .res 1

save_x:
    .res 1

save_socket_id:
    .res 1

.ifdef SOCKET_DEBUG
str_debug_socket_recv:
    .asciiz "[libsocket/socket_recv.s] "

str_debug_socket_recv_waiting_buffer:
    .asciiz "Waiting recv buffer ... "

str_debug_socket_recv_received_buffer:
    .asciiz "Received recv buffer bytes : "
.endif

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
