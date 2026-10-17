.include "telestrat.inc"
.include "sys/socket.mac"

.export _socket_close

.importzp tmp1

.proc _socket_close
   ;;@proto int socket_close(unsigned char sockfd);
   ;;@brief Close a socket
   ;;@param sockfd The socket file descriptor
   socket := tmp1

   sta      socket
   CLOSE_SOCKET socket
   rts
.endproc
