%{
#include "sintatico.h"
#include <stdlib.h>
#define YYSTYPE char *
%}

%option noyywrap

white [ \t]+
digit [0-9]
integer {digit}+
exponant [eE][+-]?{integer}
real {integer}("."{integer})?{exponant}?
variable ([a-zA-Z_][a-zA-Z0-9_]*)
multiple_blank_lines ([\n]){3,}
function_decorator ([@][a-z]+)
tab ([\t])
word ([a-zA-Z]+)
space [ ]
line_start_function ((def){space}{word}\([{word}{space}\,]*\)\:)

%%

<<EOF>> { return (END_OF_FILE);}
{line_start_function} {yylval.strval = strdup(yytext); return(LINE_START_FUNCTION);}
{tab} {return(TAB);}
{white} { /* We ignore white characters */ }
{function_decorator} {yylval.strval = strdup(yytext); return(FUNCTION_DECORATOR);}
"from" { yylval.strval = strdup(yytext); return(FROM);}
"import" { yylval.strval = strdup(yytext); return(IMPORT);}
"class" { yylval.strval = strdup(yytext); return(CLASS);}
{variable} {yylval.strval = strdup(yytext); return(VARIABLE);}
{real} {yylval.dval = atof(yytext); return(NUMBER);}
{multiple_blank_lines} {return(MULTIPLE_BLANK_LINES);}
"\n" {yylval.strval = strdup(yytext); return(END);}
"(" return(LEFT_PARENTHESES);
")" return(RIGHT_PARENTHESES);
":" return(TWO_POINTS);
"=" return(EQUALS);

%%
