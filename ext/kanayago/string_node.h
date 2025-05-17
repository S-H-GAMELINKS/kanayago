#ifndef KANAYAGO_STRING_NODE_H
#define KANAYAGO_STRING_NODE_H

#include "kanayago.h"

VALUE dynamic_string_node_new(const NODE*);
VALUE embedded_expression_string_node_new(const NODE *);

void Init_StringNode(VALUE);

#endif
