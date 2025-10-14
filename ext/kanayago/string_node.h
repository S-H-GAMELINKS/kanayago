#ifndef KANAYAGO_STRING_NODE_H
#define KANAYAGO_STRING_NODE_H

#include "kanayago.h"

VALUE dynamic_string_node_new(const NODE*);
VALUE dynamic_symbol_node_new(const NODE*);
VALUE embedded_expression_string_node_new(const NODE *);
VALUE execute_string_node_new(const NODE *);
VALUE dynamic_execute_string_node_new(const NODE *);
VALUE regexp_node_new(const NODE *);
VALUE dynamic_regexp_node_new(const NODE *);
VALUE match_node_new(const NODE *);
VALUE match2_node_new(const NODE *);
VALUE match3_node_new(const NODE *);

void Init_StringNode(VALUE);

#endif
