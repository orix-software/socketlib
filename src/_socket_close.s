.include "telestrat.inc"
.include "socket.mac"

.export _socket_close

.importzp tmp0

.proc _socket_close
   socket := tmp0

   sta      socket
   CLOSE_SOCKET socket
   rts
.endproc
