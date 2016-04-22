%{
#include <stdio.h>

#define YY_DECL int yylex()

#include "shell.tab.h"

%}

%%

\n		{return T_NEWLINE;}
"ls"		{return T_LS;}
"ps"		{return T_PS;}
"exit"		{return T_QUIT;}
"quit"		{return T_QUIT;}
[a-zA-Z0-9]+ {return T_INVALIDO;}
%%
 