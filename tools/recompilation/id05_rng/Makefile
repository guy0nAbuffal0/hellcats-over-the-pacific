CC ?= clang
CFLAGS ?= -std=c11 -Wall -Wextra -Werror -O0 -g
SANITIZE ?=
ifneq ($(SANITIZE),)
CFLAGS += -fsanitize=$(SANITIZE)
LDFLAGS += -fsanitize=$(SANITIZE)
endif

.PHONY: all test clean

all: test_rng_id05

test_rng_id05: test_rng_id05.c rng_id05.c rng_id05.h
	$(CC) $(CFLAGS) $(LDFLAGS) -o $@ test_rng_id05.c rng_id05.c

test: test_rng_id05
	./test_rng_id05

clean:
	rm -f test_rng_id05
