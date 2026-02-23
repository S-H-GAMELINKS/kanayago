#ifndef KANAYAGO_PATTERN_NODE_H
#define KANAYAGO_PATTERN_NODE_H

#include "kanayago.h"

VALUE in_node_new(const NODE *);
VALUE array_pattern_node_new(const NODE *);
VALUE hash_pattern_node_new(const NODE *);
VALUE find_pattern_node_new(const NODE *);

void Init_PatternNode(VALUE, VALUE);

#endif
