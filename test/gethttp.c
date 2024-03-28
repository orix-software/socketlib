#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include "socket.h"
#include <arpa/inet.h>

#define BUFFER_SIZE 1024

char buffer[BUFFER_SIZE];

int main(int argc, char *argv[]) {
    int sock;
    struct sockaddr_in server_addr;
    int bytes_received;
    const char *request;
    unsigned int port;

    port = 80;

    // if (argc != 3) {
    //     printf("Usage: %s <server_ip> <port>\n", argv[0]);
    //     return 1;
    // }

    // Création du socket
    sock = socket(AF_INET, SOCK_STREAM, 0);
    if (sock == -1) {
        printf("Erreur lors de la création du socket\n");
        return 1;
    }
    printf("Socket créee %d\n", sock);

    // Configuration de l'adresse du serveur

    server_addr.sin_family = AF_INET;
    // printf("port = %d\n",port);
    // printf("port = %d\n",htons(port));
    server_addr.sin_port = port;
    printf("port = %u\n",server_addr.sin_port);

    //server_addr.sin_addr[3] = 192;

    // if (inet_aton("192.168.1.77", &server_addr.sin_addr) <= 0) {
    //      perror("Adresse invalide");
    //      return 1;
    // }

    // Connexion au serveur
    if (connect(sock, (struct sockaddr *)&server_addr, sizeof(server_addr)) == -1) {
        perror("Erreur lors de la connexion");
        return 1;
    }
    printf("Socket connectée\n");

    // Envoyer la requête HTTP
    request = "GET / HTTP/1.1\r\nHost: example.com\r\nConnection: close\r\n\r\n";
    if (send(sock, request, strlen(request), 0) == -1) {
        perror("Erreur lors de l'envoi de la requête");
        return 1;
    }

    exit(1);

    // Recevoir la réponse HTTP

    while ((bytes_received = recv(sock, buffer, BUFFER_SIZE - 1, 0)) > 0) {
        buffer[bytes_received] = '\0';
        printf("%s", buffer);
    }
    if (bytes_received == -1) {
        perror("Erreur lors de la réception de la réponse");
        return 1;
    }

    // Fermeture du socket
    socket_close(sock);

    return 0;
}