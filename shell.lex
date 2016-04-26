%{
#include <stdio.h>

#define YY_DECL int yylex()

#include "shell.tab.h"

%}

%%

[ \t]	; //ignora espaços em branco
\n		{return T_NEWLINE;}
"ls"		{return T_LS;}
"ps"		{return T_PS;}
"kill"		{return T_KILL;}
"quit"		{return T_QUIT;}
"mkdir"		{return T_MKDIR;}
"rmdir"		{return T_RMDIR;}
"cd"		{return T_CD;}
"touch"		{return T_TOUCH;}
"ifconfig"	{return T_IFCONFIG;}
"start"		{return T_START;}
"+"			{return T_SOMA;}
"-"			{return T_SUBT;}
"*"			{return T_MULT;}
"/"			{return T_DIV;}
[0-9]+		{yylval.integer = atoi(yytext); return T_NUM;}
[0-9]+\.[0-9]+ 	{yylval.pfloat = atof(yytext); return T_NUMF;}
[a-zA-Z0-9]+ 	{yylval.stringp = yytext; return T_ARG; }
[a-zA-Z0-9]+[.]?[a-zA-Z0-9]* {yylval.stringp = yytext; return T_ARCARG; }
[a-zA-Z0-9/.]+ 	{yylval.stringp = yytext; return T_FOLDERARG; }

%%
 