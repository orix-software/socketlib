# Macros

---

## SOCKET

### Syntax

SOCKET domain, type, protocol

### Description

Open a socket


### Input

| param      | Description                          |
| ----------- | ------------------------------------ |
| domain | The communication domain (e.g., AF_INET) (adress ex $abcd) |
| type | The type of socket (e.g., SOCK_STREAM) (address ex $abcd) |
| protocol | The protocol to be used (e.g., IPPROTO_TCP) (address ex $abcd) |


### Returns

* Accumulator : The socket file descriptor (sockfd) or -1 on error

---

## CONNECT

### Syntax

CONNECT socket, ip, dest_port

### Description

Connect a socket to a remote address


### Input

| param      | Description                          |
| ----------- | ------------------------------------ |
| socket | The socket file descriptor |
| ip | The IP address to connect to (address ex $abcd) |
| dest_port | The destination port to connect to (address ex $abcd) |

---

## SEND

### Syntax

SEND socket, buffer, length

### Description

Send data through a socket


### Input

| param      | Description                          |
| ----------- | ------------------------------------ |
| socket | The socket file descriptor |
| buffer | The buffer containing the data to send (address ex $abcd) |
| length | The length of the data to send (address ex $abcd) |

---

## RECV

### Syntax

RECV socket, buffer, length

### Description

Receive data from a socket


### Input

| param      | Description                          |
| ----------- | ------------------------------------ |
| socket | The socket file descriptor |
| buffer | The buffer to store the received data (address ex $abcd) |
| length | The length of the buffer (address ex $abcd) |

### Description

Get socket data RES contains the buffer but it's modifyed. Keep ptr

* Y Register : Low ptr to store the buffer
* X Register : High ptr to store the buffer


### Modify

* RES
* RESB
* TR1
* TR2


### Returns

* Accumulator : Error type. If A = EOK then something had been received
* X Register : Low length
* Y Register : High length

---

## CLOSE_SOCKET

### Syntax

CLOSE_SOCKET socket

### Description

Close a socket


### Input

| param      | Description                          |
| ----------- | ------------------------------------ |
| socket | The socket file descriptor |

