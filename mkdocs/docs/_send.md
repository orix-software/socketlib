## Syntax

unsigned int send(unsigned char sockfd, const void buf[], unsigned int len, unsigned char flags);


## Description

Does not handle flags


## Input

| param      | Description                          |
| ----------- | ------------------------------------ |
| sockfd | The socket file descriptor |
| buf | The buffer containing the data to send |
| len | The length of the data to send |
| flags | The flags for the send operation (not handled) |

