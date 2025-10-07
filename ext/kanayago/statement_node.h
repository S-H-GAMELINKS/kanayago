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
VALUE class_variable_assignment_node_new(const NODE *);
VALUE instance_assignment_node_new(const NODE *);
VALUE local_assignment_node_new(const NODE *);
VALUE singleton_definition_node_new(const NODE *);
VALUE singleton_class_node_new(const NODE *);
VALUE attribute_assignment_node_new(const NODE *);
VALUE safe_call_node_new(const NODE *);
VALUE super_node_new(const NODE *);
VALUE zero_super_node_new(const NODE *);
VALUE case_node_new(const NODE *);
VALUE case2_node_new(const NODE *);
VALUE case3_node_new(const NODE *);
VALUE when_node_new(const NODE *);
VALUE retry_node_new(const NODE *);
VALUE iter_node_new(const NODE *);
VALUE ensure_node_new(const NODE *);
VALUE rescue_node_new(const NODE *);
VALUE resbody_node_new(const NODE *);

void Init_StatementNode(VALUE);

#endif
