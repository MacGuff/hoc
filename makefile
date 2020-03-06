YFLAGS = -d
OBJS = hoc.o init.o symbol.o

hoc3: $(OBJS)
	cc $(OBJS) -lm -o hoc3
hoc.o: hoc.h

init.o symbol.o: hoc.h y.tab.h

y.tab.h: hoc.y

clean:
	rm -f *.tab.[ch] *.o
