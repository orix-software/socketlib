.include "ch395.inc"
.include "socket.inc"
.include "../dependencies/orix-sdk/macros/SDK_print.mac"
.include "../dependencies/orix-sdk/macros/SDK_conio.mac"
.include "telestrat.inc"



.export socket

.import ch395_set_ipraw_pro_sn
.import ch395_set_proto_type_sn

.export socket_state, socket_protocol
.export socket_sour_port

.proc socket
    ;;@brief Open a socket
    ;;@inputA protocol
    ;;@inputX domain
    ;;@inputY type
    ;;@modifyMEM_RES
    ;;@returnsX The socket id
    ;;@returnsA if != -1 then it returns socket id. -1 is return if all socket are used

    ; sock = socket(AF_INET, SOCK_STREAM, 0);
    ;;@```ca65
    ;;@` ; or use Macro (socket.mac) SOCKET domain, type, protocol
    ;;@` SOCKET AF_INET, SOCK_STREAM, 0
    ;;@`
    ;;@```

    ;;@```ca65
    ;;@` lda     #$00
    ;;@` ldx     #AF_INET ; domain
    ;;@` ldy     #SOCK_STREAM ; type
    ;;@` jsr     socket
    ;;@```

    ; socket_state contains 0 if socket is not used, or contains type if used

    ; Looking for available socket

    stx     RES

    ldx     #$00

@L1:
    lda     socket_state,x
    beq     socketfound
    inx
    cpx     #NETWORK_MAX_SOCKET
    bne     @L1
    ; Error, return INVALID

    lda     #INVALID_SOCKET
    rts

socketfound:
    ; X contains the id of the socket
    ;
    lda     RES                ; Store Socket type
    sta     socket_state,x     ;
    ; X contains the id of the socket here
    stx     RES               ; Save socket_id
    pha
    tya
    sta     socket_domain,x             ; Save
    pla

    cpy     #SOCK_RAW
    beq     @not_ip_raw

@not_ip_raw:
    tax     ; Contains TCP/UDP type
    lda     RES ; Get socket id
    jsr     ch395_set_proto_type_sn
    jmp     @exit_socket

    ; At this step A=id_socket
    ldx     #CH395_PROTO_TYPE_IP_RAW
    jsr     ch395_set_ipraw_pro_sn

@exit_socket:
    lda     RES ; return the id of the socket
    rts

.endproc

socket_state:
    .byt 0,0,0,0,0,0,0,0

socket_protocol:
    .res NETWORK_MAX_SOCKET

socket_domain:
    .res NETWORK_MAX_SOCKET

; Read only
; Define source port to use to connect to dest port
; The first byte define the source port for socket 0
socket_sour_port:
    .byt 170,171,172,173,174,175,176,177
