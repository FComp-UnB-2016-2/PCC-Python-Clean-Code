%{
#include "global.h"
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
%}

%start Input

%%

Input:
   /* Empty */ {printf("Resultado %f\n", $$);}
   ;
%%

int yyerror(char *s) {
   printf("%s\n",s);
}

int main(void) {
   yyparse();
}
