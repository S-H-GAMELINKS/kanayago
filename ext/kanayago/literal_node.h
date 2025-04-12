#ifndef KANAYAGO_LITERAL_NODE_H
#define KANAYAGO_LITERAL_NODE_H

VALUE integer_node_new(const NODE *);
VALUE float_node_new(const NODE *);
VALUE rational_node_new(const NODE *);
VALUE imaginary_node_new(const NODE *);
VALUE symbol_node_new(const NODE *);
VALUE string_node_new(const NODE *);

void Init_LiteralNode(VALUE);

#endif
