#include <stdlib.h>
#include <string.h>
#include <assert.h>
#include "variable.h"
#include "node.h"


Node* Node_new(Variable* variable) {
  Node* node = (Node*) malloc(sizeof(Node));

  node->variable = variable;
  node->node_left = NULL;
  node->node_right = NULL;

  return node;
}

// remove an entire tree from the memory
void Node_destroy(Node* node) {
  if (node != NULL) {
    Node_destroy(node->node_left);
    Node_destroy(node->node_right);

    free(node->variable);
    node->variable = NULL;

    free(node);
    node = NULL;
  }
}


unsigned int Node_add_variable_to_array(Node* node, Variable* array, unsigned int index) {
  assert(array != NULL);

  if (node != NULL) {
    if (node->node_left != NULL) {
      index = Node_add_variable_to_array(node->node_left, array, index);
    }

    array[index] = *node->variable;
    index += 1;

    if (node->node_right != NULL) {
      index = Node_add_variable_to_array(node->node_right, array, index);
    }
  }

  return index;
}

