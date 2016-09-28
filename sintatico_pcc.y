%{
#include "global.h"
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <string.h>

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

void write_body_import(FILE* file, const char* content) {
    if (file != NULL) {
      fprintf(file, "import %s", content);
    } else {
        //Log_error("Não foi possível abrir o arquivo!\n");
        exit(0);
    }
}

void write_body_from(FILE* file, const char* content1, const char* content2) {
    if (file != NULL) {
      fprintf(file, "from %s import %s\n", content1 , content2);
    } else {
        //Log_error("Não foi possível abrir o arquivo!\n");
        exit(0);
    }
}

void write_body_class(FILE* file, const char* content1, const char* content2) {
    if (file != NULL) {
      fprintf(file, "class %s(%s):\n", content1 , content2);
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

%token <strval> FROM VARIABLE IMPORT CLASS END MULTIPLE_BLANK_LINES FUNCTION_DECORATOR TAB
%token <dval> NUMBER
%token LEFT_PARENTHESES RIGHT_PARENTHESES TWO_POINTS

%type <strval> MultipleLine LineImport LineClass

%start Input

%%

Input:
  { open_output_file("saida"); }
  | Input MultipleLine { return(1); }
  ;
MultipleLine:
  END
  | FUNCTION_DECORATOR END { printf("Resultado: DECORATOR "); }
  | LineImport END END { write_to_file(output_file, "\n\n\n"); } LineClass 
  | LineImport MULTIPLE_BLANK_LINES { write_to_file(output_file, "\n\n\n"); } LineClass
  | TAB { write_to_file(output_file, "\t");}
  ;
LineImport:
  IMPORT VARIABLE { write_body_import(output_file, $2);  }
  | FROM VARIABLE IMPORT VARIABLE { write_body_from(output_file, $2, $4);  }
  ;
LineClass:
  CLASS VARIABLE LEFT_PARENTHESES RIGHT_PARENTHESES TWO_POINTS { write_body_class(output_file, $2, "");  }
  | CLASS VARIABLE LEFT_PARENTHESES VARIABLE RIGHT_PARENTHESES TWO_POINTS { write_body_class(output_file, $2, $4);  }
  ;
%%

int yyerror(char *s) {
   printf("%s\n",s);
}

int main(void) {
   yyparse();
}
