#ifndef KANAYAGO_VARIABLE_NODE_H
#define KANAYAGO_VARIABLE_NODE_H
#include "kanayago.h"

VALUE local_variable_node_new(const NODE *);
VALUE instance_variable_node_new(const NODE *);
VALUE class_variable_node_new(const NODE *);
VALUE global_variable_node_new(const NODE *);

void Init_VariableNode(VALUE);
#endif
