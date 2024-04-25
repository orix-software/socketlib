.export _socket_close
.import socket_close

.proc _socket_close
   jmp      socket_close
.endproc
