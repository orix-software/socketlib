SOURCES8=$(wildcard src/*.s)
OBJECTS8=$(SOURCES8:.s=.o)

ifeq ($(CC65_HOME),)
        CC = cl65
        AS = ca65
        LD = ld65
        AR = ar65
else
        CC = $(CC65_HOME)/bin/cl65
        AS = $(CC65_HOME)/bin/ca65
        LD = $(CC65_HOME)/bin/ld65
        AR = $(CC65_HOME)/bin/ar65
endif

all: init $(SOURCES8) $(OBJECTS8) test

init: $(SOURCE)
	./configure

$(OBJECTS8): $(SOURCES8)
	@mkdir target/telestrat/lib/ -p
	@$(AS) -ttelestrat $(@:.o=.s) -o $@ --include-dir src/include -I libs/usr/include/asm/
	@$(AR) r socket.lib $@
	@mkdir -p build/lib8
	@mkdir -p build/usr/include/sys
	@mkdir -p build/usr/include/asm
	@cp src/socket.mac build/usr/include/asm
	@cp src/include/socket.h build/usr/include/sys/
	@cp src/include/socket.inc build/usr/include/asm/
	@cp socket.lib build/lib8/

test:
	@$(CC) -ttelestrat -I src/include -I libs/include test/gethttp.c socket.lib libs/lib8/ch395-8.lib -o gethttp

# tool:
# 	@mkdir -p target/telestrat/ch395cfg/
# 	$(CC) -ttelestrat -I src/include tools/ch395cfg/src/main.c target/telestrat/lib/ch395-8.lib -o target/telestrat/ch395cfg/ch395cfg
# 	$(CC) -ttelestrat -I src/include tools/ch395cfg/src/telnetd.c target/telestrat/lib/ch395-8.lib -o target/telestrat/ch395cfg/telnetd
# 	$(CC) -ttelestrat -I src/include tools/ch395cfg/src/wget.c target/telestrat/lib/ch395-8.lib -o target/telestrat/ch395cfg/wget

clean:
	rm src/*.o
	rm socket.lib
