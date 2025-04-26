#ifndef KANAYAGO_LITERAL_NODE_H
#define KANAYAGO_LITERAL_NODE_H

#include "kanayago.h"

VALUE integer_node_new(const NODE *);
VALUE float_node_new(const NODE *);
VALUE rational_node_new(const NODE *);
VALUE imaginary_node_new(const NODE *);
VALUE symbol_node_new(const NODE *);
VALUE string_node_new(const NODE *);
VALUE zero_list_node_new(const NODE *);
VALUE file_node_new(const NODE *node);
VALUE line_node_new(const NODE *);
VALUE encoding_node_new(const NODE *);
VALUE nil_node_new(const NODE *);

void Init_LiteralNode(VALUE);

#endif
