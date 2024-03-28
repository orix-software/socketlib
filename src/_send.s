.include "telestrat.inc"

.export _send
.import send

.import popax
.import popa

.importzp ptr1

.proc _send
    ;;@proto unsigned int recv(unsigned char s, void *buf, unsigned int len, unsigned char flags);
    ;; send(sock, request, strlen(request), 0) == -1)

    ; Don't use flags

    ; Get length
    jsr     popax
    sta     RES
    stx     RES+1

    ; get buf ptr
    jsr     popax
    sta     ptr1
    stx     ptr1

    jsr     popa ; Get socket id


    ldy     ptr1
    ldx     ptr1
    ;;@brief Send data into socket
    ;;@inputA Socket id
    ;;@inputY Low ptr of the buffer
    ;;@inputX High ptr of the buffer
    ;;inputMEM_RES Size of the bufer to send


    jmp     send
.endproc
