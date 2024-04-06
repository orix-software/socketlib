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



## connect

***Description***

Perform connect to socket. Returns socket error if something is wrong

***Input***

* Accumulator : Socket id
* Y Register : Low ip dest
* X Register : High ip dest
* RESB : dest port value (16 bits)

***Modify***

* TR0Used to save socket
* REStmp

***Example***

```ca65
 lda #$00 ; Socket id
 jsr connect
```



## recv

***Description***

Get socket data

***Input***

* Accumulator : Socket id
* X Register : Low ptr to store the buffer
* Y Register : High ptr to store the buffer

***Modify***

* RES

***Returns***

* Accumulator : Error type

* X Register : Low length

* Y Register : High length



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
endproc
## send

***Description***

Send data into socket

***Input***

* Accumulator : Socket id
* Y Register : Low ptr of the buffer
* X Register : High ptr of the buffer
* RES : Size of the bufer to send

***Returns***

* Accumulator : Error type


***Example***

```ca65
; Use SENDTO macro
 SENDTO current_socket, str_password, 11
```



## socket_close

***Description***

Close socket

***Input***

* X Register : The socket id


   ;;@` lda     #$00
   ;;@` ldx     #AF_INET      ; domain
   ;;@` ldy     #SOCK_STREAM  ; type
   ;;@` jsr     socket
   ; Skip protocol
   jsr     popa
   sta     RES+1 ; type
   jsr     popa ; domain
   tax
   lda     #$00
   ldy     RES+1
   jsr     socket
   ldx     #$00
   rts
endproc
## socket

***Description***

Open a socket

***Input***

* Accumulator : protocol 
* X Register : domain 
* Y Register : type 

***Modify***

* RES

***Returns***

* X Register : The socket id

* Accumulator : if != -1 then it returns socket id. -1 is return if all socket are used


***Example***

```ca65
 ; or use Macro (socket.mac) SOCKET domain, type, protocol
 SOCKET AF_INET, SOCK_STREAM, 0
```


***Example***

```ca65
 lda #$00
 ldx #AF_INET ; domain
 ldy #SOCK_STREAM ; type
 jsr socket
```



