# Socket Library for Orix OS (Oric 6502)

A socket API implementation for Orix OS on Oric computers (6502 processor), providing TCP/IP networking capabilities through the CH395 Ethernet controller.

---

## Documentation

### Overview

This library provides a BSD-style socket API for Orix OS, enabling network communication on Oric computers equipped with a CH395 Ethernet controller. It implements standard socket operations for creating, connecting, sending, and receiving data over TCP and UDP protocols.

**Key Features:**
- TCP (SOCK_STREAM) and UDP (SOCK_DGRAM) socket support
- IPv4 protocol (AF_INET)
- Standard BSD socket API compatibility
- Automatic source port allocation to prevent connection conflicts
- Support for up to 8 simultaneous sockets (CH395 hardware limitation)

### Hardware Requirements

- Oric computer (Atmos, Stratos, Telestrat, or compatible)
- Orix OS installed
- CH395 Ethernet controller properly configured
- Network infrastructure (router, DHCP server recommended)

---

## Repository

**Source:** https://github.com/orix-software/socketlib

**Version:** 2026.4 (see [VERSION](VERSION) file)

**Build Status:** [![Build](https://github.com/orix-software/socketlib/actions/workflows/build.yml/badge.svg)](https://github.com/orix-software/socketlib/actions)

---

## Dependencies

### Required Dependencies

1. **Orix OS** (with network support enabled)
   - Provides kernel network primitives (BRK_TELEMON interface)
   - Required version: Latest develop branch recommended

2. **CH395 Ethernet Controller**
   - Hardware: CH395 chip connected via I/O ports $380-$381
   - Driver: Integrated in Orix kernel
   - Features: 10/100M Ethernet, TCP/IP stack, 8 socket support

3. **Build Tools**
   - Orix SDK (ORIX kernel macro)
   - ca65 assembler (for low-level modules)
   - cc65

### Header Files

```c
#include <sys/socket.h>      // Main socket API definitions
#include <asm/ch395.inc>     // CH395 register definitions
#include <telestrat.inc>      // Telemon/BRK_TELEMON interface
```

---

## API Reference

### Data Types

#### Socket Descriptor
```c
typedef unsigned char sockfd;  // Range: 0-7 (CH395 supports max 8 sockets)
```

#### Address Families
```c
#define AF_UNSPEC  0   // Unspecified
#define AF_UNIX    1   // Unix domain (not fully implemented)
#define AF_INET    2   // Internet IP Protocol
```

#### Socket Types
```c
#define SOCK_STREAM    3  // TCP - stream socket
#define SOCK_DGRAM     2  // UDP - datagram socket
#define SOCK_RAW       1  // Raw IP socket
```

#### Special Values
```c
#define INVALID_SOCKET 255  // Returned on socket creation error
#define SOCKET_ERROR   255  // Returned on operation errors
```

#### Address Structures

```c
struct in_addr {
    long s_addr;  // IPv4 address in network byte order (big-endian)
};

typedef unsigned char socklen_t;

struct sockaddr_in {
    unsigned char sin_family;    // Address family (AF_INET)
    struct in_addr sin_addr;     // IPv4 address
    unsigned int  sin_port;      // Port number in network byte order
};

struct sockaddr {
    unsigned char sa_family;    // Address family
    char          sa_data[14];  // Socket address
};
```

---

### Function Reference

#### socket()
Create a new socket endpoint for communication.

**Prototype:**
```c
unsigned char socket(unsigned char domain, unsigned char type, unsigned char protocol);
```

**Parameters:**
- `domain`: Address family (AF_INET for IPv4)
- `type`: Socket type (SOCK_STREAM for TCP, SOCK_DGRAM for UDP)
- `protocol`: Protocol (0 for default, or IPPROTO_TCP/IPPROTO_UDP)

**Returns:**
- Socket descriptor (0-7) on success
- INVALID_SOCKET (255) on error

**Example:**
```c
unsigned char sock = socket(AF_INET, SOCK_STREAM, 0);
if (sock == INVALID_SOCKET) {
    // Error handling
}
```

**Notes:**
- Protocol parameter is currently not fully handled
- Maximum of 8 sockets can be created (CH395 limitation)

---

#### bind()
Bind a socket to a local address and port.

**Prototype:**
```c
unsigned char bind(unsigned char socket, const struct sockaddr_in* addr, unsigned int addrlen);
```

**Parameters:**
- `socket`: Socket descriptor
- `addr`: Pointer to sockaddr_in structure with local address and port
- `addrlen`: Length of the address structure

**Returns:**
- 0 on success
- Error code on failure

**Status:** Work in Progress (WIP) - Not fully functional

**Example:**
```c
struct sockaddr_in local_addr;
local_addr.sin_family = AF_INET;
local_addr.sin_addr.s_addr = INADDR_ANY;
local_addr.sin_port = htons(8080);

if (bind(sock, &local_addr, sizeof(local_addr)) != 0) {
    // Error handling
}
```

---

#### connect()
Establish a connection to a remote socket.

**Prototype:**
```c
unsigned char connect(unsigned char sockfd, const struct sockaddr *addr, unsigned int addrlen);
```

**Parameters:**
- `sockfd`: Socket descriptor
- `addr`: Pointer to sockaddr structure with remote address
- `addrlen`: Length of the address structure

**Returns:**
- 0 on success
- Error code on failure

**Example:**
```c
struct sockaddr_in server;
server.sin_family = AF_INET;
server.sin_addr.s_addr = inet_addr("192.168.1.100");
server.sin_port = htons(80);

if (connect(sock, (struct sockaddr*)&server, sizeof(server)) != 0) {
    // Connection failed
}
```

**Important Behavior:**
> Each call to `connect()` automatically allocates a source port from the range **170 to 425** (170 + $FF). The source port is incremented after each connection to prevent conflicts. This is necessary because when connecting to the same host repeatedly, the remote computer may still be closing the previous connection from the same source port, which would cause the new connection to be rejected.

---

#### send()
Send data on a connected socket.

**Prototype:**
```c
unsigned int send(unsigned char sockfd, const void *buf, unsigned int len, unsigned char flags);
```

**Parameters:**
- `sockfd`: Socket descriptor
- `buf`: Pointer to data buffer
- `len`: Number of bytes to send
- `flags`: Send flags (currently not implemented, use 0)

**Returns:**
- Number of bytes sent on success
- SOCKET_ERROR (255) on error

**Example:**
```c
char request[] = "GET / HTTP/1.1\r\nHost: example.com\r\n\r\n";
int bytes_sent = send(sock, request, strlen(request), 0);
if (bytes_sent == SOCKET_ERROR) {
    // Error handling
}
```

**Notes:**
- Flags parameter is not currently handled
- Blocking operation - waits for data to be sent

---

#### recv()
Receive data from a connected socket.

**Prototype:**
```c
unsigned int recv(unsigned char s, void *buf, unsigned int len, unsigned char flags);
```

**Parameters:**
- `s`: Socket descriptor
- `buf`: Pointer to buffer to store received data
- `len`: Maximum number of bytes to receive
- `flags`: Receive flags (currently not implemented, use 0)

**Returns:**
- Number of bytes received (can be 0 if connection closed)
- SOCKET_ERROR (255) on error
- ETIMEDOUT if operation timed out

**Example:**
```c
char buffer[1024];
int bytes_received = recv(sock, buffer, sizeof(buffer) - 1, 0);
if (bytes_received > 0) {
    buffer[bytes_received] = '\0';
    printf("Received: %s", buffer);
} else if (bytes_received == 0) {
    // Connection closed by peer
} else {
    // Error
}
```

---

#### sendto()
Send data to a specific destination on a datagram socket.

**Prototype:**
```c
int sendto(unsigned char sockfd, const void *buf, size_t len, unsigned char flags,
           const struct sockaddr *dest_addr, socklen_t addrlen);
```

**Parameters:**
- `sockfd`: Socket descriptor
- `buf`: Pointer to data buffer
- `len`: Number of bytes to send
- `flags`: Send flags (not implemented)
- `dest_addr`: Pointer to sockaddr structure with destination address
- `addrlen`: Length of the address structure

**Returns:**
- Number of bytes sent on success
- SOCKET_ERROR on error

**Example (UDP):**
```c
struct sockaddr_in dest;
dest.sin_family = AF_INET;
dest.sin_addr.s_addr = inet_addr("192.168.1.100");
dest.sin_port = htons(53);  // DNS port

sendto(sock, query, query_len, 0, (struct sockaddr*)&dest, sizeof(dest));
```

**Notes:**
- Automatically calls CONNECT before SEND for the specified destination
- Useful for connectionless sockets (UDP)

---

#### recvfrom()
Receive data and get the source address.

**Prototype:**
```c
int recvfrom(unsigned char sockfd, void *buf, size_t len, unsigned char flags,
             struct sockaddr *src_addr, socklen_t *addrlen);
```

**Parameters:**
- `sockfd`: Socket descriptor
- `buf`: Pointer to buffer to store received data
- `len`: Maximum number of bytes to receive
- `flags`: Receive flags (not implemented)
- `src_addr`: Pointer to sockaddr structure to store source address
- `addrlen`: Pointer to length of address structure (input/output)

**Returns:**
- Number of bytes received
- SOCKET_ERROR on error

**Example:**
```c
struct sockaddr_in sender;
socklen_t sender_len = sizeof(sender);
char buffer[1024];

int bytes = recvfrom(sock, buffer, sizeof(buffer), 0,
                    (struct sockaddr*)&sender, &sender_len);
```

---

#### socket_close()
Close a socket and release its resources.

**Prototype:**
```c
unsigned int socket_close(unsigned char sockfd);
```

**Parameters:**
- `sockfd`: Socket descriptor to close

**Returns:**
- 0 on success
- Error code on failure

**Example:**
```c
socket_close(sock);
sock = INVALID_SOCKET;
```

**Important:** Always close sockets when done to free CH395 resources for new connections.

---

## Usage Example

### TCP Client Example

```c
#include <stdio.h>
#include <string.h>
#include <sys/socket.h>
#include <arpa/inet.h>

int main() {
    unsigned char sock;
    struct sockaddr_in server;
    char buffer[1024];
    int bytes_received;

    // Create socket
    sock = socket(AF_INET, SOCK_STREAM, 0);
    if (sock == INVALID_SOCKET) {
        printf("Socket creation failed\n");
        return 1;
    }

    // Setup server address
    server.sin_family = AF_INET;
    server.sin_addr.s_addr = inet_addr("142.251.156.119");  // google.com
    server.sin_port = htons(80);  // HTTP port

    // Connect to server
    if (connect(sock, (struct sockaddr*)&server, sizeof(server)) != 0) {
        printf("Connection failed\n");
        socket_close(sock);
        return 1;
    }

    // Send HTTP request
    const char *request = "GET / HTTP/1.1\r\nHost: google.com\r\nConnection: close\r\n\r\n";
    if (send(sock, request, strlen(request), 0) == SOCKET_ERROR) {
        printf("Send failed\n");
        socket_close(sock);
        return 1;
    }

    // Receive response
    while ((bytes_received = recv(sock, buffer, sizeof(buffer) - 1, 0)) > 0) {
        buffer[bytes_received] = '\0';
        printf("%s", buffer);
    }

    // Close socket
    socket_close(sock);
    return 0;
}
```

---

## Behavior Notes

### Source Port Allocation

**Important:** This library implements automatic source port allocation to prevent connection conflicts:

- Each call to `connect()` allocates a source port from the range **170 to 425** (170 + $FF = 170 + 255)
- The source port is automatically incremented after each connection
- This prevents issues when reconnecting to the same host

**Rationale:**
When connecting to the same host repeatedly, the remote computer may still be in the process of closing the previous connection from the same source port. The TCP protocol requires a TIME_WAIT state (typically 2*MSL or about 4 minutes) before a port can be reused for the same destination. By incrementing the source port, we avoid this limitation.

**Example:**
```c
// First connection uses source port 170
connect(sock1, &server, sizeof(server));

// Second connection uses source port 171
connect(sock2, &server, sizeof(server));

// After 256 connections, wraps back to 170
```

### Error Handling

Common error codes returned by socket operations:

```c
EPROTOTYPE      = 41  // Protocol wrong type
ESOCKTNOSUPPORT = 44  // Socket type not supported
EPFNOSUPPORT    = 46  // Protocol family not supported
EAFNOSUPPORT    = 47  // Address family not supported
EADDRINUSE      = 48  // Address already in use
ENETDOWN        = 50  // Network is down
ENETUNREACH     = 51  // Network is unreachable
ECONNRESET      = 54  // Connection reset by peer
EISCONN         = 56  // Socket is already connected
ENOTCONN        = 57  // Socket is not connected
ETIMEDOUT       = 60  // Connection timed out
ECONNREFUSED    = 61  // Connection refused
EHOSTUNREACH    = 65  // No route to host
```

### CH395-Specific Notes

The CH395 controller has the following characteristics:

- **Maximum Sockets:** 8 simultaneous sockets
- **Protocols:** TCP, UDP, IP RAW, MAC RAW
- **Buffer Size:** 24KB RAM for send/receive buffers
- **Features:** DHCP, PPPoE, ARP, ICMP, IGMP
- **Speed:** 10/100M Ethernet

**Socket States (TCP):**
- CH395_TCP_CLOSED
- CH395_TCP_LISTEN
- CH395_TCP_SYN_SENT
- CH395_TCP_SYN_REVD
- CH395_TCP_ESTABLISHED
- CH395_TCP_FIN_WAIT_1
- CH395_TCP_FIN_WAIT_2
- CH395_TCP_CLOSE_WAIT
- CH395_TCP_CLOSING
- CH395_TCP_LAST_ACK
- CH395_TCP_TIME_WAIT

---

## Building

### Prerequisites

1. Install Orix SDK
2. Set up ORIXCC compiler
3. Ensure ca65 assembler is available

### Build Process

```bash
# Clone the repository
git clone https://github.com/orix-software/socket-lib.git
cd socket-lib

# Configure (if needed)
./configure

# Build
make

# Build result
# - socketlib.lib: Library file
# - socketlib.tgz: Distribution package
```

### Build Options

- **DEBUG:** Set to enable debug output
- **OPTIMIZE:** Set to enable optimizations
- **CH395_PATH:** Path to CH395 header files

---

## Installation

### Manual Installation

1. Copy header files to your include directory:
   ```bash
   cp -r src/include/* /path/to/include/
   ```

2. Link with the socket library:
   ```bash
   orixcc -o myapp myapp.c -lsocket
   ```

### Using the Pre-built Library

The pre-built library `socketlib.lib` can be used directly:

```bash
orixcc -o myapp myapp.c socketlib.lib
```

---

## Testing

The repository includes test programs to verify functionality:

### HTTP Client Test

Location: `test/gethttp.c`

This test creates a TCP socket, connects to a web server, sends an HTTP GET request, and displays the response.

**Usage:**
```bash
cd test
orixcc -o gethttp gethttp.c -I../src/include
```

**Note:** Requires DNS resolution or use direct IP addresses.

### Limitations

1. **DNS:** No built-in DNS resolution (use IP addresses or external resolver)
2. **bind():** Work in progress - not fully functional
3. **Flags:** Most flag parameters in send()/recv() are not implemented
4. **Non-blocking:** Currently all operations are blocking
5. **AF_UNIX:** Unix domain sockets not fully implemented

---

## Troubleshooting

### Common Issues

**"Socket error, start network"**
- Solution: Ensure CH395 is properly initialized and network is connected
- Check: `CH395_DETECTED` should return $AA

**Connection refused / Connection timed out**
- Verify server is running and accessible
- Check firewall settings
- Verify IP address and port

**No route to host**
- Check network connectivity
- Verify default gateway configuration

**Too many open sockets**
- Close unused sockets with `socket_close()`
- Maximum of 8 simultaneous sockets (CH395 limitation)

### Debugging Tips

1. Check CH395 status registers
2. Verify network cable connection
3. Test with known-working network services
4. Use Wireshark or tcpdump to monitor network traffic

---

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Submit a pull request

### Coding Guidelines

- Follow Orix coding standards
- Use existing code style and conventions
- Add comments for complex logic
- Update documentation for new features
- Test on actual hardware when possible

---

## License

This library is part of the Orix software ecosystem. See the repository for specific licensing information.

---

## References

- [Orix OS Documentation](https://orix-software.github.io/)
- [Orix Developer Manual](https://orix-software.github.io/developer_manual/)
- [CH395 Datasheet](https://www.wch-ic.com/downloads/CH395DS1_PDF.html)
- [BSD Socket API](https://en.wikipedia.org/wiki/Berkeley_sockets)

---

## Change History

See [VERSION](VERSION) file for version history.

**Version 2026.4**
- Updated connect() to handle source port allocation
- Fixed source port increment logic
- Documentation improvements

---

*Maintained by the Orix Software Team*
