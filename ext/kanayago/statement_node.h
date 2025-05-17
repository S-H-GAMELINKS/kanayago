#ifndef KANAYAGO_STATEMENT_NODE_H
#define KANAYAGO_STATEMENT_NODE_H

#include "internal/ruby_parser.h"
#include "kanayago.h"

VALUE if_statement_node_new(const NODE *);
VALUE unless_statement_node_new(const NODE *);
VALUE or_node_new(const NODE *);
VALUE and_node_new(const NODE *);
VALUE while_node_new(const NODE *);
VALUE until_node_new(const NODE *);
VALUE for_node_new(const NODE *);
VALUE alias_node_new(const NODE *);
VALUE valias_node_new(const NODE *);
VALUE undef_node_new(const NODE *);
VALUE return_node_new(const NODE *);
VALUE global_assignment_node_new(const NODE *);

void Init_StatementNode(VALUE);

#endif
