CC= gcc

CFLAGS:= -std=c99 -Wall -g

all: iimp

iimp.tab.c iimp.tab.h: iimp.y environ.h
	bison -d iimp.y

lex.yy.c: iimp.l iimp.tab.h
	flex iimp.l

iimp:lex.yy.c iimp.tab.c iimp.tab.h
	$(CC) $(CFLAGS) -o iimp iimp.tab.c lex.yy.c

clean:
	rm *~ *# *.o 
	rm iimp iimp.tab.c iimp.tab.h lex.yy.c
