%{
#include "sintatico.h"
#include <stdlib.h>
#define YYSTYPE char *
%}
white [ \t]+
digit [0-9]
integer {digit}+
exponant [eE][+-]?{integer}
real {integer}("."{integer})?{exponant}?
variable ([a-zA-Z_][a-zA-Z0-9_]*)

%%

{white} { /* We ignore white characters */ }

"from" return(FROM);
"import" return(IMPORT);
"." return(POINT); 
"class" return(CLASS);
{variable} { yylval.strval = strdup(yytext); return(VARIABLE); }
"\n" return(END);

%%

yywrap () {
return 0;
}
