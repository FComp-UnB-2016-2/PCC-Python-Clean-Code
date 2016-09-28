#ifndef NODE
#define NODE

#include "variable.h"

/*
The data struct implemented is a binary tree with basic operations without
the operations of remove.
*/

// The content of each node, witch receive the data from compiler
typedef struct _node {
  Variable* variable;
  struct _node* node_left;
  struct _node* node_right;
} Node;

Node *Node_new(Variable* variable);

void Node_destroy(Node* node);

unsigned int Node_add_variable_to_array(Node* node, Variable* array, unsigned int index);

#endif
