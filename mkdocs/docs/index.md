# Socketlib

This lib uses Orix kernel routines.

Each routines call subroutine from kernel

<!-- BPMBEGIN -->

## C functions

- [bind](_bind.md)
- [connect](_connect.md)
- [recv](_recv.md)
- [recvfrom](_recvfrom.md)
- [send](_send.md)
- [sendto](_sendto.md)
- [socket](_socket.md)
- [socket_close](_socket_close.md)

## Assembly functions

- [bind](bind.md)

## Macros (for assembly)

- [SOCKET domain, type, protocol](socket_macro.md)
- [CONNECT socket, ip, dest_port](socket_macro.md)
- [SEND socket, buffer, length](socket_macro.md)
- [RECV socket, buffer, length](socket_macro.md)
- [CLOSE_SOCKET socket](socket_macro.md)

## Examples

- [Gethttp](gethttp.md)



<!-- BPMEND -->
