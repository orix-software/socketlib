#define AF_UNSPEC	0
#define AF_UNIX		1	/* Unix domain sockets		*/

/* Create a new socket of type TYPE in domain DOMAIN, using
   protocol PROTOCOL.  If PROTOCOL is zero, one is chosen automatically.
      Returns a file descriptor for the new socket, or -1 for errors.  */

unsigned char socket (unsigned char  domain, unsigned char  __type, unsigned char protocol);

unsigned char bind(int socket, const struct sockaddr* addr, socklen_t addrlen);


unsigned char listen(unsigned char socket, unsigned char backlog);


unsigned char accept(int socket, struct sockaddr* addr, socklen_t* addrlen);


