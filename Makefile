AS_LUA_VERSION = 1.0
LUA_VERSION =   5.1

LDFLAGS +=          -shared -o "as_lua.so"  ./src/as_lua.o -laerospike -lcrypto -lpthread -lrt -llua -lm -lz

LUA_INCLUDE_DIR ?= /usr/include/lua5.1/
LUA_LIB_DIR ?=     /usr/local/lib/lua/5.1/

export CPATH += $(LUA_INCLUDE_DIR)

CFLAGS ?=          -O0 -g3 -Wall -c -fmessage-length=0 -MMD -MP -MF"src/as_lua.d" -MT"src/as_lua.d" -o "./src/as_lua.o" "src/as_lua.c" -std=gnu99 -g -rdynamic -Wall -fno-common -fno-strict-aliasing -fPIC -DMARCH_x86_64 -D_FILE_OFFSET_BITS=64 -D_REENTRANT -D_GNU_SOURCE

CC=gcc

INSTALL ?= install

.PHONY: all clean install

all:
	$(CC) $(CFLAGS)
	$(CC) $(LDFLAGS)

install:
	$(INSTALL) -d $(LUA_LIB_DIR)
	$(INSTALL) as_lua.so $(LUA_LIB_DIR)

clean:
	rm -f *.o *.so


