.include "telestrat.inc"
.include "socket.mac"

.export _socket_close

.importzp tmp1

.proc _socket_close
   socket := tmp1

   sta      socket
   CLOSE_SOCKET socket
   rts
.endproc
