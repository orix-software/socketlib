## Syntax

int recv(unsigned char s, void *buf, unsigned int len, unsigned char flags);


## Description

Does not handle flags

## Input

| param      | Description                          |
| ----------- | ------------------------------------ |
| s | The socket file descriptor |
| buf | The buffer to store the received data |
| len | The length of the buffer |
| flags | The flags for the receive operation (not handled) |

