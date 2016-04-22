%{

#include <stdio.h>
#include <stdlib.h>

extern int yylex();
extern int yyparse();
extern FILE* yyin;

void yyerror(const char* s);
%}

%union {
	int ival;
}

%token T_LS T_LEFT T_RIGHT
%token T_PS T_INVALIDO
%token T_NEWLINE T_QUIT
%left T_LS T_MINUS

%type<ival> expression

%start inicio

%%

inicio: 
	   | inicio line 
;

line: T_NEWLINE
    | expression T_NEWLINE {} 
    | T_QUIT T_NEWLINE { printf("Fim!\n"); exit(0); }
;

expression: T_LS { $$ = system("/bin/ls"); }
;

expression: T_PS { $$ = system("/bin/ps"); }
;

expression: T_INVALIDO { printf("Comando invalido!\n");}
;

%%

int main() {
	yyin = stdin;

	do { 
		yyparse();
	} while(!feof(yyin));

	return 0;
}

void yyerror(const char* s) {
	fprintf(stderr, "Parse error: %s\n", s);
	exit(1);
}
