.export _recv

.import recv

.import popax
.import popa

.proc _recv
    ;;@proto ssize_t recv(unsigned char s, void *buf, unsigned char len, unsigned char flags);

    ; Drop flag
    jsr     popax ; Get length
    jsr     popax ; Get ptr
    jsr     popa  ; Get socket id


    jmp     recv
.endproc
