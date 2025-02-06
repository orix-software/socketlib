.include "ch395.inc"
.include "sys/socket.inc"
.include "sys/socket.mac"
.include "telestrat.inc"

.export _bind

.import popax
.import popa

.importzp ptr1, ptr2, ptr3, tmp1


;;@proto unsigned char bind(int socket, const struct sockaddr_in* addr, unsigned int addrlen);
.proc _bind
    rts
.endproc