#include "mjollnir.h"
#include "internal/ruby_parser.h"
#include "ruby/ruby.h"
#include "rubyparser.h"

VALUE rb_mMjollnir;

VALUE
ast_to_values(VALUE hash, const NODE *node, int indent)
{
    enum node_type type;

    if (!node) {
        return Qnil;
    }

    type = nd_type(node);

    switch (type) {
	case NODE_SCOPE:
	  rb_hash_aset(hash, rb_str_new2("NODE_SCOPE"), ast_to_values(hash, RNODE_SCOPE(node)->nd_body, indent++));
	  return hash;
	case NODE_INTEGER: {
	  VALUE result = rb_hash_new();
	  rb_hash_aset(result, rb_str_new2("NODE_INTEGER"), rb_node_integer_literal_val(node));
	  return result;
	}
	default:
	  return Qfalse;
    }
}

static VALUE
parse(VALUE self, VALUE source)
{   
    struct ruby_parser *parser;
    rb_parser_t *parser_params;

    parser_params = rb_parser_params_new();
    VALUE vparser = TypedData_Make_Struct(0, struct ruby_parser,
                                         &ruby_parser_data_type, parser);
    parser->parser_params = parser_params;


    VALUE vast = rb_parser_compile_string(vparser, "main", source, 0);

    rb_ast_t *ast;

    TypedData_Get_Struct(vast, rb_ast_t, &ast_data_type, ast);

    VALUE result = rb_hash_new();

    return ast_to_values(result, ast->body.root, 0);
}

RUBY_FUNC_EXPORTED void
Init_mjollnir(void)
{
    rb_mMjollnir = rb_define_module("Mjollnir");
    rb_define_singleton_method(rb_mMjollnir, "parse", parse, 1);
}
