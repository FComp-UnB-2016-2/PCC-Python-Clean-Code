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
      fprintf(file, "\n\t%s\n\t%s", content, content2);
    } else {
        //Log_error("Não foi possível abrir o arquivo!\n");
        exit(0);
    }
}

void write_loop_line(FILE* file, const char* content, const char* content2) {
    if (file != NULL) {
      fprintf(file, "for %s in %s:", content, content2);
    } else {
        //Log_error("Não foi possível abrir o arquivo!\n");
        exit(0);
    }
}

void write_atribution_line(FILE* file, const char* content, const char* content2) {
     if (file != NULL) {
       fprintf(file, "%s = %s", content, content2);
     } else {
         //Log_error("Não foi possível abrir o arquivo!\n");
         exit(0);
     }
 }

 void write_function_line(FILE* file, const char* content, const char* content2) {
     if (file != NULL) {
       fprintf(file, "%s(%s)", content, content2);
     } else {
         //Log_error("Não foi possível abrir o arquivo!\n");
         exit(0);
     }
 }

void write_conditional_line(FILE* file, const char* content, const int option) {
    if (file != NULL) {
      switch (option) {
        case 0:
          fprintf(file, "if %s:", content);
          break;
        case 1:
          fprintf(file, "if(%s):", content);
          break;
        case 2:
          fprintf(file, "elif %s:", content);
          break;
        case 3:
          fprintf(file, "elif(%s):", content);
          break;
        case 4:
          fprintf(file, "else:");
          break;
      }
    } else {
        //Log_error("Não foi possível abrir o arquivo!\n");
        exit(0);
    }
}

void strrep(char *str, char old, char new)  {
    char *pos;
    while (1)  {
        pos = strchr(str, old);
        if (pos == NULL)  {
            break;
        }
        *pos = new;
    }
}

%}

%union {
    int ival;
    double dval;
    char* strval;
}

%token <strval> FROM VARIABLE IMPORT CLASS FUNCTION_DECORATOR LINE_START_FUNCTION END IF EQUALS MAJOR MINUS MAJOR_EQUALS MINUS_EQUALS
%token <strval> EQUALS_EQUALS ELIF ELSE FOR IN ADD_AND ADD SUB MULT DIV MODULUS EXP COMMA LEFT_PARENTHESES RIGHT_PARENTHESES TWO_POINTS DOT
%token <dval> NUMBER
%token END_OF_FILE TAB MULTIPLE_BLANK_LINES

%type <strval> MultipleLine LineImport LineClass GeneralLine LineIf LineOperator LineFor LineAtribution LineFunction Parameters FunctionParameters
%type <strval> LineStartFunction 

%start Input

%%

Input:
  { open_output_file("saida"); }
  | Input MultipleLine { }
  ;

MultipleLine:
  END_OF_FILE { close_output_file(output_file); return(0); }
  | END { write_to_file(output_file, "");}
  | LineImport END { write_to_file(output_file, "\n"); }
  | LineImport END END { write_to_file(output_file, "\n\n\n"); } LineClass 
  | LineImport MULTIPLE_BLANK_LINES { write_to_file(output_file, "\n\n\n"); } LineClass
  | LineStartFunction {write_to_file(output_file, "\n\t\t");}
  | GeneralLine {write_to_file(output_file, "\n\t\t");}
  ;
LineStartFunction:
  END TAB LINE_START_FUNCTION END { write_body_fuction(output_file, $3); }
  | END TAB FUNCTION_DECORATOR END END TAB LINE_START_FUNCTION { write_body_decorator(output_file, $3, $7);}
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
  | LineFor
  | LineAtribution
  ;
LineIf:
  IF LineOperator TWO_POINTS { write_conditional_line(output_file, $2, 0); }
  | IF LEFT_PARENTHESES LineOperator RIGHT_PARENTHESES TWO_POINTS { write_conditional_line(output_file, $3, 1); }
  | ELIF LineOperator TWO_POINTS { write_conditional_line(output_file, $2, 2); }
  | ELIF LEFT_PARENTHESES LineOperator RIGHT_PARENTHESES TWO_POINTS { write_conditional_line(output_file, $3, 3); }
  | ELSE  TWO_POINTS{ write_conditional_line(output_file, "", 4); }
  ;
LineFor:
  FOR VARIABLE IN VARIABLE TWO_POINTS { write_loop_line(output_file, $2, $4);}
  ;
LineAtribution:
  VARIABLE EQUALS VARIABLE { write_atribution_line(output_file, $1, $3);}
  | VARIABLE EQUALS LineFunction {write_atribution_line(output_file, $1, $3); }
  ;
LineFunction:
  VARIABLE LEFT_PARENTHESES FunctionParameters RIGHT_PARENTHESES {strcat($$, $3); strcat($$, $4); *$3 = '\0'; strcat($3, "(");}
  ;
FunctionParameters:
  {}
  | FunctionParameters Parameters {strrep(strcat($$, $2), ':', '(');}
  ;
Parameters:
  VARIABLE
  | VARIABLE COMMA {strcat($$, $2); strcat($$, " ");}
  ;
LineOperator:
  VARIABLE
  | VARIABLE EQUALS_EQUALS VARIABLE {strcat($$, " "); strcat($$, $2); strcat($$, " "); strcat($$, $3);}
  | VARIABLE ADD VARIABLE {strcat($$, " "); strcat($$, $2); strcat($$, " "); strcat($$, $3);}
  | VARIABLE SUB VARIABLE {strcat($$, " "); strcat($$, $2); strcat($$, " "); strcat($$, $3);}
  | VARIABLE MULT VARIABLE {strcat($$, " "); strcat($$, $2); strcat($$, " "); strcat($$, $3);}
  | VARIABLE DIV VARIABLE {strcat($$, " "); strcat($$, $2); strcat($$, " "); strcat($$, $3);}
  | VARIABLE MODULUS VARIABLE {strcat($$, " "); strcat($$, $2); strcat($$, " "); strcat($$, $3);}
  | VARIABLE EXP VARIABLE {strcat($$, " "); strcat($$, $2); strcat($$, " "); strcat($$, $3);}
  | VARIABLE ADD_AND VARIABLE {strcat($$, " "); strcat($$, $2); strcat($$, " "); strcat($$, $3);}
  | VARIABLE MAJOR VARIABLE {strcat($$, " "); strcat($$, $2); strcat($$, " "); strcat($$, $3);}
  | VARIABLE MINUS VARIABLE {strcat($$, " "); strcat($$, $2); strcat($$, " "); strcat($$, $3);}
  | VARIABLE MAJOR_EQUALS VARIABLE {strcat($$, " "); strcat($$, $2); strcat($$, " "); strcat($$, $3);}
  | VARIABLE MINUS_EQUALS VARIABLE {strcat($$, " "); strcat($$, $2); strcat($$, " "); strcat($$, $3);}
  ;

%%

int yyerror(char *s) {
   printf("%s\n",s);
}

int main(void) {
   yyparse();
}
