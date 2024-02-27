# Assembly

## bind

***Input***

* X Register : Socket id
* Accumulator : Low byte of port
* Y Register : High byte of port

***Returns***

* Accumulator : XX 

* X Register : XX 

* Y Register : XX 



## socket_close

***Description***

Close socket

***Input***

* X Register : The socket id


## socket_open_test



## socket_recv

***Description***

Get socket data

***Input***

* X Register : Socket id
* Accumulator : Low ptr to store the buffer
* Y Register : High ptr to store the buffer


## socket

***Description***

Open a socket


***Returns***

* X Register : The socket id

* Accumulator : if != -1 socket id


***Example***

```ca65
 ; or use Macro (socket.mac) SOCKET domain, type, protocol
 lda #$00
 ldx #AF_INET
 ldy #SOCK_STREAM
 jsr socket
```



## socket_send

***Input***

* X Register : Socket id
* Accumulator : Low ptr of the buffer
* Y Register : High ptr of the buffer

***Returns***

* Accumulator : Low byte of the length

* X Register : High byte of the length

* Y Register : Error type



