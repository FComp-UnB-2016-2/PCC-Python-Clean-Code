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

%token <strval> VARIABLE
%token FROM CLASS IMPORT POINT 
%token END


%start Input

%%

Input:
   /* Empty */
   | Input Line {
      close_output_file();    
   }
   ;
Line:
   END
   | Expression END
   ;
Expression:
   VARIABLE { open_output_file("teste"); write_to_file(output_file, $1);  }
   ;

%%

int yyerror(char *s) {
   printf("%s\n",s);
}

int main(void) {
   yyparse();
}
