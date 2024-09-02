#ifndef KANAYAGO_H
#define KANAYAGO_H 1

#include "node.h"
#include "internal/ruby_parser.h"

rb_parser_t *rb_parser_params_new(void);
VALUE rb_parser_compile_string(VALUE, const char *, VALUE, int);
VALUE rb_node_integer_literal_val(const NODE *);
VALUE rb_node_float_literal_val(const NODE *);
VALUE rb_node_rational_literal_val(const NODE *);
VALUE rb_node_imaginary_literal_val(const NODE *);
VALUE rb_node_str_string_val(const NODE *);
VALUE rb_node_sym_string_val(const NODE *);

// Add extern for Kanayago
extern const rb_data_type_t ruby_parser_data_type;
extern const rb_data_type_t ast_data_type;
// End for Kanayago

#endif /* KANAYAGO_H */
