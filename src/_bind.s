.include "ch395.inc"
.include "sys/socket.inc"
.include "sys/socket.mac"
.include "telestrat.inc"

.export _bind

.import bind

.import popax
.import popa

.importzp ptr1, ptr2, ptr3, tmp1

.proc _bind
    ;;@proto unsigned char bind(unsigned char socket, const struct sockaddr_in* addr, unsigned int addrlen);
    ;;@brief Bind a socket to an address  (does not work : WIP)
    ;;@param socket The socket file descriptor
    ;;@param addr The address to bind to
    ;;@param addrlen The length of the address structure
    addrlen := ptr2
    addr    := ptr1

    sta     addrlen
    stx     addrlen + 1
    jsr     popax
    sta     addr
    stx     addr + 1
    jsr     popa
    ; A contains the socket id, X contains the low byte of the port, Y contains the high byte of the port

    jmp    bind
.endproc