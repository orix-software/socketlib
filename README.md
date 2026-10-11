# Socket lib

**Version:** 2026.3

A socket library for Orix operating system on Telestrat/Oric computers, providing Berkeley socket API compatibility for network programming on 6502-based systems.

## Documentation

### Overview

This library implements standard Berkeley socket functions for the Orix operating system, allowing network communication on Oric/Telestrat computers using the CH395 Ethernet controller. It provides a familiar API for developers coming from Unix-like systems.

### API Reference

The library provides the following functions, compatible with standard socket programming:

- **`socket(domain, type, protocol)`** - Create a new socket
  - `domain`: Address family (AF_INET = 2 for IPv4)
  - `type`: Socket type (SOCK_STREAM = 3 for TCP, SOCK_DGRAM = 2 for UDP)
  - `protocol`: Protocol (0 for default)
  - Returns: Socket descriptor or 255 (INVALID_SOCKET) on error

- **`bind(socket, addr, addrlen)`** - Bind a socket to a local address
  - Currently a stub implementation

- **`connect(sockfd, addr, addrlen)`** - Connect to a remote host
  - `sockfd`: Socket descriptor
  - `addr`: Pointer to sockaddr_in structure
  - `addrlen`: Size of address structure
  - Returns: Error code (0 for success)

- **`send(sockfd, buf, len, flags)`** - Send data on a connected socket
  - `sockfd`: Socket descriptor
  - `buf`: Pointer to data buffer
  - `len`: Length of data to send
  - `flags`: Not currently handled
  - Returns: Number of bytes sent

- **`recv(sockfd, buf, len, flags)`** - Receive data from a socket
  - `sockfd`: Socket descriptor
  - `buf`: Pointer to receive buffer
  - `len`: Maximum length to receive
  - `flags`: Not currently handled
  - Returns: Number of bytes received

- **`sendto(sockfd, buf, len, flags, dest_addr, addrlen)`** - Send data to a specific destination
  - Combines connect() and send() operations
  - Useful for UDP datagrams

- **`recvfrom(sockfd, buf, len, flags, src_addr, addrlen)`** - Receive data with source address
  - Receives data and stores source address

- **`socket_close(sockfd)`** - Close a socket
  - `sockfd`: Socket descriptor to close

### Data Structures

```c
struct sockaddr_in {
    unsigned char sin_family;   // Address family (AF_INET)
    struct in_addr sin_addr;    // IPv4 address (4 bytes)
    unsigned int sin_port;     // Port number (big-endian)
};

struct in_addr {
    long s_addr;  // IPv4 address in binary format
};
```

### Constants

- **Address Families:**
  - `AF_UNSPEC` = 0
  - `AF_UNIX` = 1
  - `AF_INET` = 2

- **Socket Types:**
  - `SOCK_STREAM` = 3 (TCP)
  - `SOCK_DGRAM` = 2 (UDP)
  - `SOCK_RAW` = 1

- **Error Codes:**
  - `INVALID_SOCKET` = 255
  - `SOCKET_ERROR` = 255
  - `EPROTOTYPE` = 41
  - `ESOCKTNOSUPPORT` = 44
  - `EPFNOSUPPORT` = 46
  - `EAFNOSUPPORT` = 47
  - `EADDRINUSE` = 48
  - And more...

## Repository

- **Source Code:** `src/` directory contains assembly source files (.s)
- **Headers:** `src/include/sys/` contains C header files for socket API
- **Build Output:** `socket.lib` - Static library for linking
- **Build Directory:** `build/` - Contains compiled artifacts
- **Test Code:** `test/gethttp.c` - Example HTTP client using the library
- **Version File:** `VERSION` - Contains current version (2025.2)

### Source Files

Assembly implementations in `src/`:
- `_socket.s` - socket() function implementation
- `_connect.s` - connect() function implementation
- `_bind.s` - bind() function implementation (stub)
- `_send.s` - send() function implementation
- `_recv.s` - recv() function implementation
- `_sendto.s` - sendto() function implementation
- `_recvfrom.s` - recvfrom() function implementation
- `_socket_close.s` - socket_close() function implementation

Header files in `src/include/sys/`:
- `socket.h` - C function declarations and structure definitions
- `socket.inc` - Assembly constants and structure definitions
- `socket.mac` - Assembly macros for kernel calls

## Dependencies

### Required Libraries

The socket library depends on:

1. **ch395lib** - CH395 Ethernet controller library
   - Provides low-level network hardware access
   - Download: `http://repo.orix.oric.org/dists/2024.2/tgz/6502/ch395lib.tgz`

2. **inetlib** - Internet protocol library
   - Provides network protocol implementations
   - Download: `http://repo.orix.oric.org/dists/2024.2/tgz/6502/inetlib.tgz`

3. **orix-sdk** - Orix Software Development Kit
   - Required for building Orix applications
   - Repository: `https://github.com/assinie/orix-sdk`

### Build Tools

- **cc65** - Cross-compiler toolchain for 6502
  - Repository: `https://github.com/cc65/cc65`
  - Required tools: `ca65` (assembler), `cl65` (compiler), `ld65` (linker), `ar65` (archiver)

### Development Environment

The repository includes a submodule reference to orix-sdk:
```
Dependencies:
- orix-sdk (submodule in dependencies/orix-sdk/)
```

## behavior

Each calls to connect will allocate source port from 170 to 170 + $FF. Each time a connect is performed, source port = source port ++

Because when we connect to same host, we are trying to connect to same source port from Orix and the remote computer won't accept a connexion from a source port when connection is still closing.

### Port Allocation Strategy

- **Base Port:** 170 (0xAA)
- **Range:** 170 to 170 + 255 (170 to 425)
- **Allocation:** Sequential increment on each connect() call
- **Rationale:** Prevents connection conflicts when rapidly reconnecting to the same host

This behavior ensures that when reconnecting to the same remote host, the library uses a different source port each time, avoiding issues where the remote computer may still be processing the previous connection's closure.

### Kernel Integration

The library interfaces with the Orix kernel through the following system calls:

- `KERNEL_SOCKET_NETWORK` ($05) - Create a socket
- `KERNEL_BIND_NETWORK` ($06) - Bind a socket
- `KERNEL_CONNECT_NETWORK` ($07) - Connect to remote
- `KERNEL_RECV_NETWORK` ($08) - Receive data
- `KERNEL_SEND_NETWORK` ($09) - Send data
- `KERNEL_SOCKET_CLOSE_NETWORK` ($0A) - Close socket

### Build Process

The Makefile compiles all assembly source files and creates a static library:

```makefile
Target: socket.lib
Sources: All .s files in src/
Tools: ca65 (assembler), ar65 (archiver)
```

Build artifacts are placed in:
- `target/telestrat/lib/socket.lib` - Compiled library
- `build/lib8/socket.lib` - Build directory copy
- `build/usr/include/sys/socket.h` - Header files
- `build/usr/include/asm/socket.inc` - Assembly includes
- `build/usr/include/asm/socket.mac` - Macro definitions
