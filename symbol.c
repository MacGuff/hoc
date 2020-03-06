#include <stdlib.h>
#include "hoc.h"

static symbol *symlist = 0;

static char *emalloc(size_t n)
{
	char *p;

	if ((p = malloc(n)) == NULL)
		err("out of memory");
	return p;
}

symbol *install(char *s, int t, double d)
{
    symbol *sp;

    sp = (symbol *)emalloc(sizeof(symbol));
    sp->name = emalloc(strlen(s) + 1);
    strcpy(sp->name, s);
    sp->type = t;
    sp->u.val = d;
    sp->next = symlist;
    symlist = sp;

    return sp;
}

symbol *lookup(char *s)
{
    symbol *sp;

    for(sp = symlist; sp != (symbol *) 0; sp = sp->next) {
        if (strcmp(sp->name, s) == 0)
            return sp;
    }

    return 0;
}
