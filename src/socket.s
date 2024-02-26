; SOCKET sock = socket(AF_INET, SOCK_STREAM, 0);

; ipraw icmp/ping
; socket(AF_INET,SOCK_RAW,0)


; A = 0
; Y SOCK_STREAM/SOCK_DGRAM/CH395_PROTO_TYPE_IP_RAW
; X : AF_INET (erased and not used)
    ; lda     #$00
    ; ldx     #AF_INET
    ; ldy     #SOCK_DGRAM
    ; jsr     socket
.include "../libs/usr/include/asm/ch395.inc"
.include "include/socket.inc"
.include "../dependencies/orix-sdk/macros/SDK_print.mac"
.include "../dependencies/orix-sdk/macros/SDK_conio.mac"
.include "telestrat.inc"

.export socket_state,socket_protocol

SOCKET_DEBUG=1

.export socket
.import ch395_set_ipraw_pro_sn
.import ch395_set_proto_type_sn


.proc socket
    ;;@brief Open a socket
    ;;@returnsX The socket id
    ;;@returnsA if != -1
    ; Looking for available socket

.ifdef SOCKET_DEBUG
    sta     debug_save_A
    sty     debug_save_Y
    stx     debug_save_X
    print str_opening_socket
    lda     debug_save_A
    ldy     debug_save_Y
    ldx     debug_save_X
.endif

    ldx     #$00

@L1:
    lda     socket_state,x
    beq     socketfound
    inx
    cpx     #NETWORK_MAX_SOCKET
    bne     @L1
    ; Error, return INVALID

.ifdef SOCKET_DEBUG
    print   str_socket_overflow
.endif

    lda     #INVALID_SOCKET
    rts

socketfound:
.ifdef SOCKET_DEBUG
    txa     ; Get socket id
    pha     ; Save
    print   str_allocating_socket_id

    pla     ; restore for XDECIM

    pha     ; save for next code

    ldy     #$00
    ldx     #$01
    BRK_TELEMON XDECIM
    crlf
    pla
    tax ; Restore socket id for the next code
    ldy     debug_save_Y
.endif

    lda     #AF_INET                ; Store Socket type
    sta     socket_state,x          ;
    ; X contains the id of the socket here
    txa     ; Get the id socket
    sta     tmp_socket               ; Save socket_id
    sty     tmp_protocol             ; Save

    cpy     #SOCK_RAW
    beq     @not_ip_raw


@not_ip_raw:
    ldx     tmp_protocol
    jsr     ch395_set_proto_type_sn
    jmp     @exit_socket

    ; At this step A=id_socket
    ldx     #CH395_PROTO_TYPE_IP_RAW
    jsr     ch395_set_ipraw_pro_sn

@exit_socket:
    ldx     tmp_socket
    lda     tmp_protocol
    sta     socket_protocol,x


    lda     tmp_socket ; return the id of the socket
    rts

tmp_socket:
    .res 1

tmp_protocol:
    .res 1
.endproc

socket_state:
    .res NETWORK_MAX_SOCKET

socket_protocol:
    .res NETWORK_MAX_SOCKET

.ifdef SOCKET_DEBUG

str_opening_socket:
    .byte "[libsocket/socket.s] Opening socket  ",$0A,$0D,$00

str_socket_overflow:
    .byte "[libsocket/socket.s] id Socket overflow",$0A,$0D,$00

str_allocating_socket_id:
    .byte "[libsocket/socket.s] Allocating socket id : ",$00

debug_save_A:
    .res 1

debug_save_X:
    .res 1

debug_save_Y:
    .res 1
.endif
