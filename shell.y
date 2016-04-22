%{

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

extern int yylex();
extern int yyparse();
extern FILE* yyin;

void yyerror(const char* s);
%}

%union {
	int integer;
	char string;
}

%token <integer> T_NUM
%token <string> T_ARG
%token T_PS T_INVALIDO T_KILL T_LS T_MKDIR
%token T_NEWLINE T_QUIT

%type<string> comando

%start inicio

%%

inicio: 
	   | inicio line 
;

line: T_NEWLINE
    | comando T_NEWLINE {} 
    | T_QUIT T_NEWLINE { printf("Fim!\n"); exit(0); }
;

comando: T_LS { $$ = system("/bin/ls"); }
	   | T_PS { $$ = system("/bin/ps"); }
	   | T_KILL T_NUM {  char string[100], stringfinal[1000] = "/bin/kill ";
 	   					 int i, rem, len = 0, n;
					     n = $2;
					     while (n != 0)
					     {
					         len++;
					         n /= 10;
					     }
					     for (i = 0; i < len; i++)
					     {
					         rem = $2 % 10;
					         $2 = $2 / 10;
					         string[len - (i + 1)] = rem + '0';
					     }
					     string[len] = '\0';
					     strcat(stringfinal, string);
					     $$ = system(stringfinal); 
	   				 }
	   | T_MKDIR T_ARG { printf("TODO");}
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
}

