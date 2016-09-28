#ifndef SIMBOL_TABLE
#define SIMBOL_TABLE

#include "variable.h"
#include "node.h"
#include <stdlib.h>
typedef struct _simbol_table {
  Node* root;
  size_t size;
} SimbolTable;


SimbolTable* SimbolTable_new();

Node* SimbolTable_search_node(SimbolTable* simbol_table, char* name);

Variable* SimbolTable_find(SimbolTable* simbol_table, char* name);

int SimbolTable_insert_variable(SimbolTable* simbol_table, Variable* variable);

int SimbolTable_insert(SimbolTable* simbol_table, char* name, char* type);

void SimbolTable_destroy(SimbolTable* simbol_table);

Variable* SimbolTable_get_variables_as_array(SimbolTable* simbol_table);

#endif
