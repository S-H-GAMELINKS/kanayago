#ifndef MJOLLNIR_H
#define MJOLLNIR_H 1

#include "node.h"
#include "internal/ruby_parser.h"

// Add some Ruby's Parser struct and enum for Mjollnir
enum lex_type {
    lex_type_str,
    lex_type_io,
    lex_type_array,
    lex_type_generic,
};

struct ruby_parser {
    rb_parser_t *parser_params;
    enum lex_type type;
    union {
        struct lex_pointer_string lex_str;
        struct {
            VALUE file;
        } lex_io;
        struct {
            VALUE ary;
        } lex_array;
    } data;
};

// End of Add for Mjollnir

rb_parser_t *rb_parser_params_new(void);
VALUE rb_parser_compile_string(VALUE, const char *, VALUE, int);
VALUE rb_node_integer_literal_val(const NODE *);
VALUE rb_node_float_literal_val(const NODE *);
VALUE rb_node_rational_literal_val(const NODE *);
VALUE rb_node_imaginary_literal_val(const NODE *);
VALUE rb_node_str_string_val(const NODE *);

extern const rb_data_type_t ruby_parser_data_type;
extern const rb_data_type_t ast_data_type;

#endif /* MJOLLNIR_H */
