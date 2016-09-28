#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <assert.h>
#include "variable.h"
#include "node.h"
#include "simbol_table.h"
#include "../templates/verify_templates.h"


SimbolTable* SimbolTable_new() {
    SimbolTable* simbol_table = (SimbolTable*) malloc(sizeof(SimbolTable));

    simbol_table->root = NULL;
    simbol_table->size = 0;

    return simbol_table;
}

// Search the node by its variable name
Node* SimbolTable_search_node(SimbolTable* simbol_table, char* name) {
    Node* node_found = NULL;
    Node* current_node = simbol_table->root;

    // Loop ends when there is no more nodes to look OR the name was found in one of the nodes
    while ((current_node != NULL) && (node_found == NULL)) {
        int test = strcmp(name, current_node->variable->name);

        if (test == 0) { // it is the current node, KILL LOOP
            node_found = current_node;
        } else if (test > 0) { // It's to the right of the current node
            current_node = current_node->node_right;
        } else { // It's to the left ot the current node
            current_node = current_node->node_left;
        }
    }

    return node_found;
}

// Search for a variable by its name
Variable* SimbolTable_find(SimbolTable* simbol_table, char* name) {
    Node* node  = SimbolTable_search_node(simbol_table, name);
    Variable* result = NULL;

    if (node != NULL) {
        result = node->variable;
    } else {
        result = NULL;
    }

    return result;
}

// Add a new data to the tree
int SimbolTable_insert_variable(SimbolTable* simbol_table, Variable* variable) {
    assert(simbol_table != NULL);
    assert(variable != NULL);

    Variable* variable_already_added = SimbolTable_find(simbol_table, variable->name);
    int node_added = 0;

    /*
     * FIXME: Is the SimbleTable work to alert the user that a variable was already decladed or
     * the compiler should verify it before addind a new varibale ?
     */

    Node* actual_node = simbol_table->root;
    Node* node = Node_new(variable);

    if (actual_node == NULL) {
        simbol_table->root = node;
        simbol_table->size = 1;
        node_added = 1;
    } else {
        do {
            int test = strcmp(variable->name, actual_node->variable->name);

            if (test < 0) { // Its to the left
                if (actual_node->node_left == NULL) {
                    actual_node->node_left = node;
                    node_added = 1;
                } else {
                    actual_node = actual_node->node_left;
                }
            } else { // Its to the right
                if (actual_node->node_right == NULL) {
                    actual_node->node_right = node;
                    node_added = 1;
                } else {
                    actual_node = actual_node->node_right;
                }
            }
        } while(!node_added);

        simbol_table->size += 1;
    }


    return node_added;
}


int SimbolTable_insert(SimbolTable* simbol_table, char* name, char* type) {
    assert(simbol_table != NULL);
    Variable* variable = Variable_new(name, type);

    int data_added = SimbolTable_insert_variable(simbol_table, variable);

    return data_added;
}


void SimbolTable_destroy(SimbolTable* simbol_table) {
    assert(simbol_table != NULL);

    Node_destroy(simbol_table->root);
    free(simbol_table);
    simbol_table = NULL;
}


Variable* SimbolTable_get_variables_as_array(SimbolTable* simbol_table) {
    assert(simbol_table != NULL);
    Variable* variables_array = (Variable*) malloc(sizeof(Variable)*simbol_table->size);

    Node_add_variable_to_array(simbol_table->root, variables_array, 0);

    return variables_array;
}

