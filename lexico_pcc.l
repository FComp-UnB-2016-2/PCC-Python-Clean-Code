%{
#include "sintatico.h"
#include <stdlib.h>
#define YYSTYPE char *
%}

%option noyywrap

white [ ]+
digit [0-9]
integer {digit}+
exponant [eE][+-]?{integer}
real {integer}("."{integer})?{exponant}?
variable ([a-zA-Z_][a-zA-Z0-9_]*)
multiple_blank_lines ([\n]){3,}
function_decorator ([@][a-z]+)
multiple_tabs ([\t]*)
word ([a-zA-Z]+)
space [ ]
line_start_function ((def){space}{variable}[\(]?[[[a-zA-Z_][a-zA-Z0-9_]*]*[ ]*[\,]*]*[\)]?\:)

%%

<<EOF>> { return (END_OF_FILE);}
{line_start_function} {yylval.strval = strdup(yytext); return(LINE_START_FUNCTION);}
{multiple_tabs} {yylval.strval = strdup(yytext); return(MULTIPLE_TABS);}
{white} { /* We ignore white characters */ }
{function_decorator} {yylval.strval = strdup(yytext); return(FUNCTION_DECORATOR);}
"return" { yylval.strval = strdup(yytext); return(RETURN);}
"from" { yylval.strval = strdup(yytext); return(FROM);}
"import" { yylval.strval = strdup(yytext); return(IMPORT);}
"class" { yylval.strval = strdup(yytext); return(CLASS);}
"if" { yylval.strval = strdup(yytext); return(IF);}
"elif" { yylval.strval = strdup(yytext); return(ELIF);}
"else" {yylval.strval = strdup(yytext); return(ELSE);}
"for" {yylval.strval = strdup(yytext); return(FOR);}
"in" {yylval.strval = strdup(yytext); return(IN);}
"def" {yylval.strval = strdup(yytext); return(DEF);}
{variable} {yylval.strval = strdup(yytext); return(VARIABLE);}
{real} {yylval.dval = atof(yytext); return(NUMBER);}
{multiple_blank_lines} {return(MULTIPLE_BLANK_LINES);}
"\n" {yylval.strval = strdup(yytext); return(END);}
"+=" { yylval.strval = strdup(yytext); return(ADD_AND);}
"+"	{ yylval.strval = strdup(yytext); return(ADD);}
"-" { yylval.strval = strdup(yytext); return(SUB);}
"*" { yylval.strval = strdup(yytext); return(MULT);}
"/" { yylval.strval = strdup(yytext); return(DIV);}
"%" { yylval.strval = strdup(yytext); return(MODULUS);}
"**" { yylval.strval = strdup(yytext); return(EXP);}
"=" { yylval.strval = strdup(yytext); return(EQUALS);}
">" { yylval.strval = strdup(yytext); return(MAJOR);}
"<" { yylval.strval = strdup(yytext); return(MINUS);}
">=" { yylval.strval = strdup(yytext); return(MAJOR_EQUALS);}
"<=" { yylval.strval = strdup(yytext); return(MINUS_EQUALS);}
"==" { yylval.strval = strdup(yytext); return(EQUALS_EQUALS);}
"," { yylval.strval = strdup(yytext); return(COMMA);}
"(" { yylval.strval = strdup(yytext); return(LEFT_PARENTHESES);}
")" { yylval.strval = strdup(yytext); return(RIGHT_PARENTHESES);}
":" { yylval.strval = strdup(yytext); return(TWO_POINTS);}
"." { yylval.strval = strdup(yytext); return(DOT);}

%%
