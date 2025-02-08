# Assembly

## bind

***Description***

Bind sockets

***Input***

* X Register : Socket id
* Accumulator : Low byte of port
* Y Register : High byte of port

***Returns***

* Accumulator : XX 

* X Register : XX 

* Y Register : XX 



   socket := tmp1
   buffer := ptr1
   length := RESB
   flags  := tmp2
   ; Don't use flags
   sta     flags ; Stored but not managed
   ; Get length
   jsr     popax
   sta     length
   stx     length + 1
   ; get buf ptr
   jsr     popax
   sta     ptr1
   stx     ptr1 + 1
   jsr     popa ; Get socket id
   sta     socket
   SEND socket, buffer, length
   rts
endproc
   protocol := tmp1
   type     := tmp2
   domain   := tmp3
   ; Skip protocol
   sta     protocol
   jsr     popa
   sta     RES+1 ; type
   sta     type
   jsr     popa ; domain
   sta     domain
   SOCKET domain, type, protocol
   rts
endproc
