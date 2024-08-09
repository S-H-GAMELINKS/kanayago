#ifndef MJOLLNIR_H
#define MJOLLNIR_H 1

#include "node.h"
#include "internal/ruby_parser.h"

rb_parser_t *rb_parser_params_new(void);
VALUE rb_parser_compile_string(VALUE, const char *, VALUE, int);
VALUE rb_node_integer_literal_val(const NODE *);
VALUE rb_node_float_literal_val(const NODE *);

extern const rb_data_type_t ruby_parser_data_type;
extern const rb_data_type_t ast_data_type;

#endif /* MJOLLNIR_H */
