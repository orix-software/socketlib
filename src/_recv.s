.export _recv

.import recv

.import popax
.import popa

.importzp ptr1

.proc _recv
    ;;@proto int recv(unsigned char s, void *buf, unsigned char len, unsigned char flags);

    ; Drop flag
    jsr     popax ; Get length
    ; Drop length pour l'instant, car il n'est pas possible de lire qu'un bout 

    jsr     popax ; Get ptr
    sta     ptr1
    stx     ptr1+1
    jsr     popa  ; Get socket id

    ;;@inputA Socket id
    ;;@inputX Low ptr to store the buffer
    ;;@inputY High ptr to store the buffer
    ;;@modifyMEM_RES

    ldy    ptr1
    ldx    ptr1+1

    jsr     recv

    tya
    stx     ptr1+1
    ldy     ptr1+1

    rts
.endproc
