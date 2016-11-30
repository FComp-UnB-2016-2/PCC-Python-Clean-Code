%{
#include "global.h"
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <string.h>

FILE* output_file = NULL;
int number_identation;
int beginning_block = 1;
char * output_file_name[100];

void open_output_file(char* file_name) {
    if (!output_file) {
        char complete_file_name[60];
        sprintf(complete_file_name, "%s.py", file_name);
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

char* return_loop_line(char* content, char* content2) {
    return ("for %s in %s:", content, content2);
}

char* return_atribution_line(char* content, char* content2) {
    return ("%s = %s", content, content2);
}

void write_function_line(FILE* file, const char* content, const char* content2) {
    if (file != NULL) {
        fprintf(file, "%s(%s)", content, content2);
    } else {
        //Log_error("Não foi possível abrir o arquivo!\n");
        exit(0);
    }
}

char* return_conditional_line(char* content, const int option) {
    switch (option) {
        case 0:
            strcat(content, "if ");
            return content;
            break;
        case 1:
            return ("if (%s):", content);
            break;
        case 2:
            return ("elif %s:", content);
            break;
        case 3:
            return ("elif(%s):", content);
            break;
        case 4:
            return ("else:");
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

int calculate_tabs(char *tabs) {
  number_identation = 0;
  char *pos;
  while (1)  {
      pos = strchr(tabs, '\t');
      if (pos == NULL)  {
          break;
      }
      number_identation++;
      *pos = &pos;
  }

  FILE* file_tabs = NULL;
  file_tabs = fopen("tabs.txt", "w");

  char str_file[15];
  sprintf(str_file, "%d", number_identation);

  fprintf(file_tabs, "%s", str_file);

  if (file_tabs != NULL) {
      fclose(file_tabs);
  }

  return number_identation;
}

void increase_identation() {
  FILE* fr = NULL;
  fr = fopen ("tabs.txt", "rt");

  number_identation=0;

  fscanf(fr, "%d", &number_identation);
  fclose(fr);

  FILE* file_tabs = NULL;
  file_tabs = fopen("tabs.txt", "w");

  char str_file[15];
  sprintf(str_file, "%d", number_identation + 1);

  fprintf(file_tabs, "%s", str_file);

  if (file_tabs != NULL) {
      fclose(file_tabs);
  }
}

char* return_tabs() {
  int n;
  long elapsed_seconds;
  char line[80];

  FILE* fr = NULL;
  fr = fopen ("tabs.txt", "rt");

  number_identation=0;

  fscanf(fr, "%d", &number_identation);
  fclose(fr);

  char tabs[100];
  memset(tabs, '\0', sizeof(tabs));
  strcpy(tabs,"");

  int counter = 0;
  for(counter = 0; counter < number_identation ; counter++) {
    strcat(tabs,"\t");
  }

  return tabs;
}

int verify_beginning_code_block() {
  if (beginning_block == 1)
  {
    beginning_block = 0;
    return 1;
  }
  else
  {
    return 0;
  }
}

void finish_code_block()
{
  beginning_block = 1;
}

%}

%union {
    int ival;
    double dval;
    char* strval;
}

%token <strval> FROM RETURN VARIABLE IMPORT CLASS FUNCTION_DECORATOR LINE_START_FUNCTION END IF EQUALS MAJOR MINUS MAJOR_EQUALS MINUS_EQUALS MULTIPLE_TABS
%token <strval> EQUALS_EQUALS ELIF ELSE FOR IN ADD_AND ADD SUB MULT DIV MODULUS EXP COMMA LEFT_PARENTHESES RIGHT_PARENTHESES TWO_POINTS DOT DEF
%token <dval> NUMBER
%token END_OF_FILE MULTIPLE_BLANK_LINES

%type <strval> MultipleLine LineImport LineClass CodeBlock LineIf LineIdentation LineOperator LineFor LineAtribution LineFunction Parameter Parameters FunctionParameters
%type <strval> LineStartFunction BigCodeBlock BlockImport

%start Input

%%

Input:
  { open_output_file(output_file_name); }
  | Input MultipleLine { }
  ;

MultipleLine:
  END_OF_FILE { close_output_file(output_file); return(0); }
  | BlockImport { write_to_file(output_file, "\n\n"); } LineClass
  | BlockImport END { write_to_file(output_file, "\n\n"); } LineClass 
  | BlockImport END END { write_to_file(output_file, "\n\n"); } LineClass 
  | BlockImport MULTIPLE_BLANK_LINES { write_to_file(output_file, "\n\n"); } LineClass
  | BigCodeBlock
  | LineAtribution  { write_to_file(output_file, $1);}
  | END { write_to_file(output_file, "\n");}
  ;
BlockImport:
  { $$ = ""; }
  | LineImport END BlockImport { }
  ;
LineImport:
  IMPORT VARIABLE { write_body_import(output_file, $2); write_to_file(output_file, "\n"); }
  | FROM VARIABLE IMPORT VARIABLE { write_body_from(output_file, $2, $4); write_to_file(output_file, "\n"); }
  ;
LineClass:
  CLASS VARIABLE LEFT_PARENTHESES RIGHT_PARENTHESES TWO_POINTS { write_body_class(output_file, $2, "");  }
  | CLASS VARIABLE LEFT_PARENTHESES FunctionParameters RIGHT_PARENTHESES TWO_POINTS { write_body_class(output_file, $2, $4);  }
  | CLASS VARIABLE TWO_POINTS { write_body_class(output_file, $2, "");  }
  ;
BigCodeBlock:
  MULTIPLE_TABS CodeBlock { number_identation = calculate_tabs($1); write_to_file(output_file, return_tabs()); write_to_file(output_file, $2); }
  ;
CodeBlock:
  { $$ = ""; }
  | LineIdentation END MULTIPLE_TABS CodeBlock
  {
    strcat($$, "\n");
    strcat($$, return_tabs());
    strcat($$, $4);
    increase_identation();
  }
  | LineAtribution { increase_identation(); $$=$1; }
  ;
LineIdentation:
  LineIf { $$ = $1; }
  | LineFor { $$ = $1; }
  | LineStartFunction { $$ = $1; }
  ;
LineIf:
  IF LineOperator TWO_POINTS { strcat($$, " "); strcat($$, $2); strcat($$, ":"); }
  | IF LEFT_PARENTHESES LineOperator RIGHT_PARENTHESES TWO_POINTS { strcat($$, " ("); strcat($$, $3); strcat($$, "):"); }
  | ELIF LineOperator TWO_POINTS { strcat($$, " "); strcat($$, $2); strcat($$, ":"); }
  | ELIF LEFT_PARENTHESES LineOperator RIGHT_PARENTHESES TWO_POINTS { strcat($$, " ("); strcat($$, $3); strcat($$, "):"); }
  | ELSE TWO_POINTS { strcat($$, ":"); }
  ;
LineFor:
  FOR VARIABLE IN VARIABLE TWO_POINTS { strcat($$, " "); strcat($$, $2); strcat($$, ":"); }
  ;
LineStartFunction:
  FUNCTION_DECORATOR END DEF VARIABLE LEFT_PARENTHESES FunctionParameters RIGHT_PARENTHESES TWO_POINTS { strcat($$, "\n"); strcat($$, $3); strcat($$, " "); strcat($$, $4); strcat($$, $5); strcat($$, $6);  strcat($$, $7);  strcat($$, $8); }
  | FUNCTION_DECORATOR END END DEF VARIABLE LEFT_PARENTHESES FunctionParameters RIGHT_PARENTHESES TWO_POINTS { strcat($$, "\n"); strcat($$, $4); strcat($$, " "); strcat($$, $5); strcat($$, $6); strcat($$, $7);  strcat($$, $8);  strcat($$, $9); }
  | FUNCTION_DECORATOR MULTIPLE_BLANK_LINES DEF VARIABLE LEFT_PARENTHESES FunctionParameters RIGHT_PARENTHESES TWO_POINTS { strcat($$, "\n"); strcat($$, $3); strcat($$, " "); strcat($$, $4); strcat($$, $5); strcat($$, $6);  strcat($$, $7);  strcat($$, $8); }
  | DEF VARIABLE LEFT_PARENTHESES FunctionParameters RIGHT_PARENTHESES TWO_POINTS { strcat($$, " "); strcat($$, $2); strcat($$, $3); strcat($$, $4); strcat($$, $5); strcat($$, $6); }
  | DEF VARIABLE LEFT_PARENTHESES RIGHT_PARENTHESES TWO_POINTS { strcat($$, " "); strcat($$, $2); strcat($$, $3); strcat($$, $4); strcat($$, $5); }
  ;
LineAtribution:
  FunctionParameters EQUALS FunctionParameters { strcat($$, " = "); strcat($$, $3); }
  | FunctionParameters EQUALS LineFunction { strcat($$, " = "); strcat($$, $3); }
  | LineFunction { }
  | RETURN LineFunction { strcat($$, " "); strcat($$, $2); }
  ;
LineFunction:
  FunctionParameters LEFT_PARENTHESES FunctionParameters RIGHT_PARENTHESES { strcat($$, $2); strcat($$, $3); strcat($$, $4);}
  | FunctionParameters LEFT_PARENTHESES RIGHT_PARENTHESES { strcat($$, $2); strcat($$, $3); }
  ;
FunctionParameters:
  Parameters { $$ = $1; }
  ;
Parameters:
  { $$ = ""; }
  | Parameter Parameters { strcat($$, $2); }
Parameter:
  VARIABLE { $$ = $1; }
  | VARIABLE COMMA { strcat($$, $2); strcat($$, " "); }
  | VARIABLE DOT{ strcat($$, $2); }
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

int main( int argc, char *argv[ ] ){
  if(argc == 2){
    strcpy(output_file_name, argv[1]);
  } else{
    printf("\nInforme o nome do arquivo de saída!!!\n\n");
  }

  yyparse();
}
