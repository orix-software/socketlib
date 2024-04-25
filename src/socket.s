.include "ch395.inc"
.include "socket.inc"
.include "../dependencies/orix-sdk/macros/SDK_print.mac"
.include "../dependencies/orix-sdk/macros/SDK_conio.mac"
.include "telestrat.inc"



.export socket

.import ch395_set_ipraw_pro_sn
.import ch395_set_proto_type_sn
.import ch395_get_socket_status_sn
.import ch395_close_socket_sn

.export socket_state
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

    stx     RES ; Save domain

    ldx     #$00

@search_another_socket:
@L1:
    lda     socket_state,x
    beq     @socketfound
    inx
    cpx     #NETWORK_MAX_SOCKET
    bne     @L1
    ; Error, return INVALID

    lda     #INVALID_SOCKET
    rts

@socketfound:
    ; X contains the id of the socket
    ;
    ; We are looking if the state of the socket is still established (Because when it's closed,
    ; there is some delay if delay ti close tcp socket

;     txa
;     tay ; Save in Y

; @waiting_for_closing:
;     tya
;     jsr     ch395_get_socket_status_sn
;     cmp     #CH395_SOCKET_CLOSED
;     beq     @continue

;     tya
;     tax
;     jsr     ch395_close_socket_sn
;     tay
;     jmp     @waiting_for_closing

; @continue:
;     ; Restore
;     tya
;     tax


    lda     RES                ; Get Domain
    sta     socket_domain,x    ; Save domain
    ; X contains the id of the socket here

    tya     ; Y contains SOCK_STREAM etc
    sta     socket_state,x             ; Contains SOCK_STREAM etc

    stx     RES ; Save socket id

    cpy     #SOCK_RAW
    beq     @is_ip_raw

    ; FIXME here fix ipraw

@not_ip_raw:
    txa     ; contains socket id (X) Transfer to A

    sty     RES+1 ; save SOCK_STREAM etc
    ldx     RES+1
    jsr     ch395_set_proto_type_sn
    jmp     @exit_socket

@is_ip_raw:
    txa
    ldx     #CH395_PROTO_TYPE_IP_RAW
    jsr     ch395_set_ipraw_pro_sn

@exit_socket:
    lda     RES ; return the id of the socket
    rts

.endproc

socket_state:
    .byt 0,0,0,0,0,0,0,0

; Store pid of the program
socket_pid:
    .byt 0,0,0,0,0,0,0,0

socket_domain:
    .res NETWORK_MAX_SOCKET

; Read only
; Define source port to use to connect to dest port
; The first byte define the source port for socket 0
socket_sour_port:
    .byt 170,171,172,173,174,175,176,177
