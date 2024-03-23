.export _send
.import send

.proc _send
    ;;@proto unsigned int recv(int s, void *buf, unsigned int len, unsigned char flags);
    jmp     send
.endproc
