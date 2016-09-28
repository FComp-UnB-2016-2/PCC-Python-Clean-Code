#ifndef VARIABLE
#define VARIABLE

typedef struct _variable {
  char*  name; // Name of variable identify by compiler
  char*  type; // The type of variable
} Variable;


Variable* Variable_new(char* name, char* type);

#endif
