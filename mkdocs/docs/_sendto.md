## Syntax

int sendto(unsigned char sockfd, const void *buf, size_t len, unsigned char flags, const struct sockaddr *dest_addr, socklen_t addrlen);


## Description

Send a message to a socket

## Input

| param      | Description                          |
| ----------- | ------------------------------------ |
| sockfd | The socket file descriptor |
| buf | The buffer containing the data to send |
| len | The length of the data to send |
| flags | The flags for the send operation |
| dest_addr | The address of the destination |
| addrlen | The length of the destination address structure |

