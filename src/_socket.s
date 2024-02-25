; sock = socket(AF_UNIX, SOCK_STREAM, 0);

.include "socket.inc"

.export _socket
.import popa


.proc _socket
  jsr popa ; get type (SOCK_STREAM etc)
  jsr popa ; get domain
  cmp #AF_UNIX
  bne @error
  ; T ; 0
  ; X SOCK_STREAM
  ; A Type
  ; BRK_ORIX(XSOCKET)
  ; return id socket
  rts
@error:
  lda #SOCKET_ERROR
  rts
.endproc

