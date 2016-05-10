%{

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

extern int yylex();
extern int yyparse();
extern FILE* yyin;

void yyerror(const char* s);

void printLinha(){
	char completo[4096] = "FelipeShell:";
	char path[2048];
	getcwd(path, sizeof(path));
	strcat(completo,path);
	strcat(completo,">> ");
	printf("%s",completo); 
}

%}

%union {
	int integer;
	float pfloat;
	char string;
	char * stringp;
}

%token <pfloat> T_NUMF
%token <integer> T_NUM
%token <stringp> T_ARG
%token T_PS T_INVALIDO T_KILL T_LS T_MKDIR T_RMDIR T_NEWLINE T_QUIT T_CD T_TOUCH T_IFCONFIG T_START

%token T_SOMA T_SUBT T_MULT T_DIV T_PESQ T_PDIR
%left T_SOMA T_SUBT 
%left T_MULT T_DIV

%type<string> comando
%type<integer> calcint
%type<pfloat> calcfloat

%start inicio

%%

inicio: { printLinha(); }
	   | inicio line { printLinha(); }
;

line: T_NEWLINE 
    | comando T_NEWLINE  
    | calcint T_NEWLINE { 	
    						printf("Resultado: %i\n", $1);
    					}
    | calcfloat T_NEWLINE { 
    						printf("Resultado: %f\n", $1);
						  }
    | T_QUIT T_NEWLINE { printf("Fim!\n"); exit(0); }
;

comando: T_LS { system("/bin/ls"); }
	   | T_PS { system("/bin/ps"); }
	   | T_KILL T_NUM {  
	   					 char string[100], stringfinal[1000] = "/bin/kill ";
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
					     system(stringfinal); 
	   				 }
	   | T_MKDIR T_ARG {
	   					 char stringfinal[1000] = "/bin/mkdir ";
	   					 strcat(stringfinal, $2);
	   					 system(stringfinal);
	   				   }
	   | T_RMDIR T_ARG {
	   					 char stringfinal[1000] = "/bin/rmdir ";
	   					 strcat(stringfinal, $2);
	   					 system(stringfinal);
	   				   }

	   | T_CD T_ARG {		
	   					int ret;
	   					if(strcmp($2, "..") == 0){
	   						ret = chdir($2);
	   					}
	   					else if(strchr($2,'/')!= NULL){
	   						ret = chdir($2);
	   					}
	   					else {
		   					char path[2048];
		   					getcwd(path, sizeof(path));
		   					strcat(path, "/");
		   					strcat(path, $2);
							ret = chdir(path);
	   					}
	   					
						if(ret != 0){
							printf("Erro! Diretorio nao encontrado!\n");
						}
					}
		| T_TOUCH T_ARG {
						  char stringfinal[1000] = "/bin/touch ";
						  strcat(stringfinal, $2);
						  system(stringfinal);
						}
		| T_IFCONFIG { system("ifconfig"); }
		| T_START T_ARG { 
							if(fork() == 0){
								system($2);
								exit(0);
							} 
						}
		| T_ARG { yyerror("Arg found"); }
;

calcfloat: T_NUMF                  { $$ = $1; }
	  | calcfloat T_SOMA calcfloat { $$ = $1 + $3; }
	  | calcfloat T_SUBT calcfloat { $$ = $1 - $3; }
	  | calcfloat T_MULT calcfloat { $$ = $1 * $3; }
	  | calcfloat T_DIV calcfloat  { $$ = $1 / $3; }
	  | calcint T_SOMA calcfloat   { $$ = $1 + $3; }
	  | calcint T_SUBT calcfloat   { $$ = $1 - $3; }
	  | calcint T_MULT calcfloat   { $$ = $1 * $3; }
	  | calcint T_DIV calcfloat	   { $$ = $1 / $3; }
	  | calcfloat T_SOMA calcint   { $$ = $1 + $3; }
	  | calcfloat T_SUBT calcint   { $$ = $1 - $3; }
	  | calcfloat T_MULT calcint   { $$ = $1 * $3; }
	  | calcfloat T_DIV calcint	   { $$ = $1 / $3; }
	  | calcint T_DIV calcint	   { $$ = $1 / (float)$3; }
;

calcint: T_NUM				    { $$ = $1; }
	  | calcint T_SOMA calcint	{ $$ = $1 + $3; }
	  | calcint T_SUBT calcint	{ $$ = $1 - $3; }
	  | calcint T_MULT calcint	{ $$ = $1 * $3; }
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
	fprintf(stderr, "Comando/Argumento nao valido. Erro: %s\n", s);
}
