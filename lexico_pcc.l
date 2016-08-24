%{
#include "global.h"
#include "sintatico.h"
#include <stdlib.h>
%}
white [ \t]+
digit [0-9]
integer {digit}+
exponant [eE][+-]?{integer}
real {integer}("."{integer})?{exponant}?

%%

{white} { /* We ignore white characters */ }
{real} {
yylval=atof(yytext);
return(NUMBER);
}

"from" return(FROM);
"import" return(IMPORT);
"." return(POINT);
"class" return(CLASS);
([a-zA-Z_][a-zA-Z0-9_]*) return(VARIABLE);

%%

yywrap () {
return 0;
}
