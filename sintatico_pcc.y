%{
#include "global.h"
#include <stdio.h>
#include <stdlib.h>
#include <math.h>

FILE* output_file = NULL;

void open_output_file(char* file_name) {
    if (!output_file) {
        char complete_file_name[60];
        sprintf(complete_file_name, "%s.txt", file_name);
        output_file = fopen(complete_file_name, "w");
    }
}

void close_output_file() {
    if (output_file != NULL) {
        fclose(output_file);
    }
}

void write_to_file(FILE* file, const char* content) {
    if (file != NULL) {
      fprintf(file, "%s", content);
    } else {
        //Log_error("Não foi possível abrir o arquivo!\n");
        exit(0);
    }
}
%}

%union {
    int ival;
    double dval;
    char* strval;
}

%token <strval> FROM VARIABLE IMPORT CLASS END MULTIPLE_BLANK_LINES FUNCTION_DECORATOR
%token <dval> NUMBER

%type <strval> MultipleLine

%start Input


%start Input

%%

Input:
  /* Empty */
   | Input MultipleLine
   ;
MultipleLine:
  END
  | FUNCTION_DECORATOR END { printf("Resultado: DECORATOR "); }
  | LineImport END END LineClass { printf("Resultado: LineImport END END END LineClass"); }
  | MULTIPLE_BLANK_LINES { printf("Resultado: END END"); }
  ;
LineImport:
  IMPORT VARIABLE
  | FROM VARIABLE IMPORT VARIABLE
  ;
LineClass:
  CLASS VARIABLE
  ;
%%

int yyerror(char *s) {
   printf("%s\n",s);
}

int main(void) {
   yyparse();
}
