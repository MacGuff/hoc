%{
#include "hoc.h"
%}
%union {
    double val;
    symbol *sym;
}
%token <val> NUMBER
%token <sym> VAR BLTIN UNDEF
%token NEWLINE
%type <val> expr asgn
%right '='
%left '+' '-'
%left '*' '/'
%left UNARYMINUS
%right '^'
%%
list:   /**/
        | list NEWLINE
        | list asgn NEWLINE
        | list expr NEWLINE { printf("\t%.8g\n", $2); }
        | list error NEWLINE { yyerrok; }
        ;
asgn:     VAR '=' expr { $$ = $1->u.val=$3; $1->type = VAR; }
        ;
expr:     NUMBER { $$ = $1; }
        | VAR    { if ($1->type == UNDEF)
                        err("undefined variable");
                    $$ = $1->u.val; }
        | asgn
        | BLTIN '(' expr ')' { $$ = (*($1->u.ptr))($3); }
        | expr '+' expr { $$ = $1 + $3; }
        | expr '-' expr { $$ = $1 - $3; }
        | expr '*' expr { $$ = $1 * $3; }
        | expr '/' expr
            {
                if ($3 == 0.0)
                    err("div by zero");
                $$ = $1 / $3; }
        | '(' expr ')' { $$ = $2;}
        | '-' expr %prec UNARYMINUS { $$ = -$2; }
        ;
%%

#include <stdio.h>
#include <ctype.h>
#include <signal.h>
#include <setjmp.h>

void fpecatch(int);

jmp_buf begin;
char *progname;
int lineno = 1;

int main(int argc, char *argv[])
{
    progname = argv[0];
    init();
    setjmp(begin);
    signal(SIGFPE, fpecatch);
    yyparse();
    return 0;
}

int yylex()
{
    int c;

    while ((c = getchar()) == ' ' || c == '\t')
        ;
    if (c == EOF)
        return 0;
    if (c == '.' || isdigit(c)) {
        ungetc(c, stdin);
        scanf("%lf", &yylval.val);
        return NUMBER;
    }

    if (isalpha(c)) {
        symbol *s;
        char sbuf[100], *p = sbuf;
        do {
            *p++ = c;
        } while ((c=getchar()) != EOF && isalnum(c));

        ungetc(c, stdin);
        *p = '\0';
        if ((s = lookup(sbuf)) == NULL)
            s = install(sbuf, UNDEF, 0.0);
        yylval.sym = s;
        return s->type == UNDEF ? VAR : s->type;
    }
    if (c == '\n') {
        lineno++;
    }
    if (c == '\n' || c == ';')
        return NEWLINE;
    return c;
}


void yyerror(char *s)
{
    fprintf(stderr, "%s: %s, near line: %d\n", progname, s, lineno);
}

void err(char *s)
{
    fprintf(stderr, "%s: %s, near line: %d\n", progname, s, lineno);
    longjmp(begin, 0);
}
void fpecatch(int u)
{
    err("float point exception");
}
