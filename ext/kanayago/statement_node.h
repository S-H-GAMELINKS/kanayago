#ifndef KANAYAGO_STATEMENT_NODE_H
#define KANAYAGO_STATEMENT_NODE_H

#include "internal/ruby_parser.h"
#include "kanayago.h"

VALUE if_statement_node_new(const NODE *);
VALUE unless_statement_node_new(const NODE *);
VALUE or_node_new(const NODE *);
VALUE and_node_new(const NODE *);

void Init_StatementNode(VALUE);

#endif
