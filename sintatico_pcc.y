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
      fprintf(file, "from %s import %s", content1 , content2);
    } else {
        //Log_error("Não foi possível abrir o arquivo!\n");
        exit(0);
    }
}

void write_body_class(FILE* file, const char* content1, const char* content2) {
    if (file != NULL) {
      fprintf(file, "class %s(%s):", content1 , content2);
    } else {
        //Log_error("Não foi possível abrir o arquivo!\n");
        exit(0);
    }
}

void write_body_fuction(FILE* file, const char* content) {
    if (file != NULL) {
      fprintf(file, "\n\n\t%s", content);
    } else {
        //Log_error("Não foi possível abrir o arquivo!\n");
        exit(0);
    }
}

void write_body_decorator(FILE* file, const char* content, const char* content2) {
    if (file != NULL) {
      fprintf(file, "\n\n\t%s\n\t%s", content, content2);
    } else {
        //Log_error("Não foi possível abrir o arquivo!\n");
        exit(0);
    }
}

void write_atribution_line(FILE* file, const char* content, const char* content2) {
    if (file != NULL) {
      fprintf(file, "\n%s = %s", content, content2);
    } else {
        //Log_error("Não foi possível abrir o arquivo!\n");
        exit(0);
    }
}

void write_conditional_line(FILE* file, const char* content, const int option) {
    if (file != NULL) {
      switch (option) {
        case 0:
          fprintf(file, "\nif %s:", content);
          break;
        case 1:
          fprintf(file, "\nif(%s):", content);
          break;
      }
    } else {
        //Log_error("Não foi possível abrir o arquivo!\n");
        exit(0);
    }
}

void write_compare_conditional_line(FILE* file, const char* content, const char* content2, const char* content3) {
    if (file != NULL) {
      fprintf(file, "%s %s %s", content, content2, content3);
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

%token <strval> FROM VARIABLE IMPORT CLASS FUNCTION_DECORATOR LINE_START_FUNCTION END IF EQUALS MAJOR MINUS MAJOR_EQUALS MINUS_EQUALS
%token <dval> NUMBER
%token LEFT_PARENTHESES RIGHT_PARENTHESES TWO_POINTS END_OF_FILE TAB MULTIPLE_BLANK_LINES

%type <strval> MultipleLine LineImport LineClass GeneralLine LineIf LineOperator

%start Input

%%

Input:
  { open_output_file("saida"); }
  | Input MultipleLine { }
  ;
MultipleLine:
  END_OF_FILE { close_output_file(output_file); return(0); }
  | END { write_to_file(output_file, "");}
  | END TAB FUNCTION_DECORATOR END END TAB LINE_START_FUNCTION END { write_body_decorator(output_file, $3, $7);} GeneralLine
  | LineImport END { write_to_file(output_file, "\n"); }
  | LineImport END END { write_to_file(output_file, "\n\n\n"); } LineClass 
  | LineImport MULTIPLE_BLANK_LINES { write_to_file(output_file, "\n\n\n"); } LineClass
  | END TAB LINE_START_FUNCTION END { write_body_fuction(output_file, $3); }
  | GeneralLine 
  | LineOperator END
  ;
LineImport:
  IMPORT VARIABLE { write_body_import(output_file, $2);  }
  | FROM VARIABLE IMPORT VARIABLE { write_body_from(output_file, $2, $4); }
  ;
LineClass:
  CLASS VARIABLE LEFT_PARENTHESES RIGHT_PARENTHESES TWO_POINTS { write_body_class(output_file, $2, "");  }
  | CLASS VARIABLE LEFT_PARENTHESES VARIABLE RIGHT_PARENTHESES TWO_POINTS { write_body_class(output_file, $2, $4);  }
  ;
GeneralLine:
  LineIf
  ;

LineIf:
  IF VARIABLE TWO_POINTS { write_conditional_line(output_file, $2, 0); }
  | IF LEFT_PARENTHESES VARIABLE RIGHT_PARENTHESES TWO_POINTS { write_conditional_line(output_file, $3, 1); }
  | IF LineOperator TWO_POINTS
  | IF LEFT_PARENTHESES LineOperator { write_conditional_line(output_file, $3, 1); } RIGHT_PARENTHESES TWO_POINTS
  ;

LineOperator:
  VARIABLE EQUALS VARIABLE { write_compare_conditional_line(output_file, $1, $2, $3); }
  ;

%%

int yyerror(char *s) {
   printf("%s\n",s);
}

int main(void) {
   yyparse();
}
