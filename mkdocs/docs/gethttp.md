# gethttp


```c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include "../src/include/sys/socket.h"
#include "arpa/inet.h"
#include "inetextend.h"

#define BUFFER_SIZE 1024

char buffer[BUFFER_SIZE];

int main() {
    unsigned char sock;
    struct sockaddr_in server;
    int bytes_received;
    const char *request;
    int port;
    unsigned char *byte;

    port = 80;

    printf("Create socket in order to get HTTP response from google.com\n");

    // Création du socket
    sock = socket(AF_INET, SOCK_STREAM, 0);
    if (sock == -1) {
        printf("socket error\n");
        return 1;
    }

    if (sock == 255) {
        printf("Socket error, start network\n");
        return 1;
    }

    printf("Socket created %d\n", sock);

    // 142.251.156.119 is the IP address for google.com
    if (inet_aton("142.251.156.119", &server.sin_addr.s_addr) == 0) {
        printf("invalid ip\n");
    } else {
        printf("valid ip\n");
    }

    server.sin_family = AF_INET;
    server.sin_port = htons(80);


    // Connexion au serveur
    if (connect(sock, (struct sockaddr *)&server, sizeof(server)) != 0) {
        printf("Connection failed!\n");
        return 1;
    }
    printf("Connected\n");

    request = "GET / HTTP/1.1\r\nHost: google.com\r\nConnection: close\r\n\r\n";
    if (send(sock, request, strlen(request), 0) == -1) {
        perror("Send failed");
        return 1;
    }

    // Recevoir la réponse HTTP

    while ((bytes_received = recv(sock, buffer, BUFFER_SIZE - 1, 0)) > 0) {
        buffer[bytes_received] = '\0';
        printf("%s", buffer);
    }
    if (bytes_received == -1) {
        perror("Error receiving data");
        return 1;
    }

    // Closing socket
    socket_close(sock);
    return 0;

}
```