.PHONY: bison main clean

CC = gcc
FLAGS = -w -lm
SOURCES = main.c lex.yy.c y.tab.c y.tab.h

all: bison flex main

bison:
	bison -y -d -Wno parser.y

flex:
	flex flex.l

main:
	$(CC) $(SOURCES) -o main $(FLAGS)

clean:
	rm -f y.tab.c y.tab.h main lex.yy.c