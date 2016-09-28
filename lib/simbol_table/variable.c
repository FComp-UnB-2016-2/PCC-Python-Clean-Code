#include <stdlib.h>
#include "variable.h"

Variable* Variable_new(char* name, char* type) {
  Variable* variable = (Variable*) malloc(sizeof(Variable));

  variable->name = name;
  variable->type = type;

  return variable;
}

