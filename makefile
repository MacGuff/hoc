hoc1: hoc.o
	cc hoc.o -o hoc1
hoc.o: hoc.y
	yacc hoc.y
	cc -c y.tab.c
	mv y.tab.o hoc.o

clean:
	rm y.tab.c *.o
