## Syntax

int recvfrom(unsigned char sockfd, void *buf, size_t len, unsigned char flags, struct sockaddr *src_addr, socklen_t *addrlen);


## Description

Receive a message from a socket

## Input

| param      | Description                          |
| ----------- | ------------------------------------ |
| sockfd | The socket file descriptor|
| buf | The buffer to store the received data|
| len | The length of the buffer|
| flags | The flags for the receive operation|
| src_addr | The address of the sender|
| addrlen | The length of the sender's address|

---
hide:
  - toc
---
