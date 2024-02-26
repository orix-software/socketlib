.export _bind
; unsigned char bind(int socket, const struct sockaddr* addr, socklen_t addrlen);

.proc _bind

  ; jsr popa ; struct sockaddr
  ; jsr popa ; socket id
  ; BRK_ORIX(XBIND)
  rts
.endproc
