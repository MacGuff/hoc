%{
#define YYSTYPE double
%}

%token NUMBER
%left '+' '-'
%left '*' '/'
%%
list:
        | list '\n'
        | list expr '\n' { printf("\t%.8g\n", $2); }
        ;
expr:     NUMBER { $$ = $1; }
        | expr '+' expr { $$ = $1 + $3; }
        | expr '-' expr { $$ = $1 - $3; }
        | expr '*' expr { $$ = $1 * $3; }
        | expr '/' expr { $$ = $1 / $3; }
        | '(' expr ')' { $$ = $2;}
        ;
%%

#include <stdio.h>
#include <ctype.h>

char *progname;
int lineno = 0;

int main(int argc, char *argv[])
{
    progname = argv[0];
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
        scanf("%lf", &yylval);
        return NUMBER;
    }

    if (c == '\n')
        lineno++;
    return c;
}


void yyerror(char *s)
{
    fprintf(stderr, "%s: %s, near line: %d\n", progname, s, lineno);
}
