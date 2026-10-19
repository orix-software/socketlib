# Macros

---

## SOCKET

### Syntax

SOCKET domain, type, protocol

### Description

Open a socket (protocol is not handled yet) (see kernel routine for more information: https://orix-software.github.io/developer_manual/kernel/primitives/xsocket/)


### Input

| param      | Description                          |
| ----------- | ------------------------------------ |
| domain | The communication domain (e.g., AF_INET) (adress ex $abcd) |
| type | The type of socket (e.g., SOCK_STREAM) (address ex $abcd) |
| protocol | The protocol to be used (e.g., IPPROTO_TCP) (address ex $abcd) |


### Returns

* Accumulator : The socket file descriptor (sockfd) or -1 on error

***Example***

```asm
 .include "sys/socket.inc" to get 'INVALID_SOCKET' definition
 SOCKET domain, type, protocol
 ; A contains the socket file descriptor (sockfd) or -1 on error
 cmp #INVALID_SOCKET
 beq @error
 ; No error
 sta socket_fd
 rts
 @error:
 ; Error
 rts
domain:
 .byt #AF_INET
type:
 .byt #SOCK_STREAM
protocol:
 .byt $00 ; Not handled yet
socket_fd:
 .byt $00
```

---

## CONNECT

### Syntax

CONNECT socket, ip, dest_port

### Description

Connect a socket to a remote address (see kernel routine for more information: https://orix-software.github.io/developer_manual/kernel/primitives/xconnect/)


### Input

| param      | Description                          |
| ----------- | ------------------------------------ |
| socket | The socket file descriptor |
| ip | The IP address to connect to (address ex $abcd) 32 bits big endian |
| dest_port | The destination port to connect to (address ex $abcd) |

***Example***

```asm
 .include "sys/socket.inc" to get 'INVALID_SOCKET' definition
 CONNECT socket_fd, ip, dest_port
 rts
ip:
 .word $C0A80001 ; 192.168.0.1
dest_port:
 .word $0050 ; 80
socket_fd:
 .byt $00
```

---

## SEND

### Syntax

SEND socket, buffer, length

### Description

Send data through a socket (see kernel routine for more information: https://orix-software.github.io/developer_manual/kernel/primitives/xsend/)


### Input

| param      | Description                          |
| ----------- | ------------------------------------ |
| socket | The socket file descriptor |
| buffer | The buffer containing the data to send (address ex $abcd) |
| length | The length of the data to send (address ex $abcd) |

***Example***

```asm
 .include "sys/socket.inc" to get 'INVALID_SOCKET' definition
 SEND socket_fd, buffer, length
 rts
buffer:
 .dsb 1000 ; Buffer address
length:
 .word 1000 ; Buffer length
socket_fd:
 .byt $00
```

---

## RECV

### Syntax

RECV socket, buffer, length

### Description

Receive data from a socket, uses TR0 (see kernel routine for more information: https://orix-software.github.io/developer_manual/kernel/primitives/xrecv/)


### Input

| param      | Description                          |
| ----------- | ------------------------------------ |
| socket | The socket file descriptor |
| buffer | The buffer to store the received data (address ex $abcd) |
| length | The length of the buffer (address ex $abcd) |

***Example***

```asm
 RECV mysocket, mybuffer, length
 rts
mysocket:
 .byt $00
buffer:
 .dsb 1000
length:
 .word 1000
```

---

## CLOSE_SOCKET

### Syntax

CLOSE_SOCKET socket

### Description

Close a socket (see kernel routine for more information: https://orix-software.github.io/developer_manual/kernel/primitives/xsocketclose/)


### Input

| param      | Description                          |
| ----------- | ------------------------------------ |
| socket | The socket file descriptor |

***Example***

```asm
 CLOSE_SOCKET mysocket
 rts
mysocket:
 .byt $00
```

