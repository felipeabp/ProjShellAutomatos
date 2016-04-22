%{
#include <stdio.h>

#define YY_DECL int yylex()

#include "shell.tab.h"

%}

%%

\n		{return T_NEWLINE;}
"ls"		{return T_LS;}
"ps"		{return T_PS;}
"kill"		{return T_KILL;}
"quit"		{return T_QUIT;}
"mkdir"		{return T_MKDIR;}
[0-9]+		{yylval.integer = atoi(yytext); return T_NUM;}
[a-zA-Z0-9]+ {return T_ARG; }
%%
 