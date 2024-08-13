#include "mjollnir.h"
#include "internal/ruby_parser.h"
#include "ruby/ruby.h"
#include "rubyparser.h"
#include <stdio.h>

VALUE rb_mMjollnir;

VALUE ast_to_values(VALUE, const NODE *);

VALUE
opcall_node_to_hash(const NODE *node)
{
    VALUE result = rb_hash_new();
    rb_hash_aset(result, rb_str_new2("recv"), ast_to_values(result, RNODE_OPCALL(node)->nd_recv));
    rb_hash_aset(result, rb_str_new2("mid"), ID2SYM(RNODE_OPCALL(node)->nd_mid));
    rb_hash_aset(result, rb_str_new2("args"), ast_to_values(result, RNODE_OPCALL(node)->nd_args));
    return result;
}

VALUE
call_node_to_hash(const NODE *node)
{
    VALUE result = rb_hash_new();
    rb_hash_aset(result, rb_str_new2("recv"), ast_to_values(result, RNODE_OPCALL(node)->nd_recv));
    rb_hash_aset(result, rb_str_new2("mid"), ID2SYM(RNODE_CALL(node)->nd_mid));
    rb_hash_aset(result, rb_str_new2("args"), ast_to_values(result, RNODE_CALL(node)->nd_args));
    return result;
}

VALUE
list_node_to_hash(const NODE *node)
{
    VALUE result = rb_ary_new();
    NODE *nd_head = RNODE_LIST(node)->nd_head;
    int list_len = RNODE_LIST(node)->as.nd_alen;

    for (int i = 0; i < list_len; i++ ) {
	rb_ary_push(result, ast_to_values(Qnil, nd_head));
	nd_head = RNODE_LIST(node)->nd_next;
    }

    return result;
}

VALUE
ast_to_values(VALUE hash, const NODE *node)
{
    enum node_type type;

    if (!node) {
        return Qnil;
    }

    type = nd_type(node);

    switch (type) {
	case NODE_SCOPE:
	  rb_hash_aset(hash, rb_str_new2("NODE_SCOPE"), ast_to_values(hash, RNODE_SCOPE(node)->nd_body));
	  return hash;
	case NODE_OPCALL: {
	  VALUE result = rb_hash_new();
	  rb_hash_aset(result, rb_str_new2("NODE_OPCALL"), opcall_node_to_hash(node));
	  return result;
	}
	case NODE_CALL: {
	  VALUE result = rb_hash_new();
	  rb_hash_aset(result, rb_str_new2("NODE_CALL"), call_node_to_hash(node));
	  return result;
	}
	case NODE_BLOCK: {
	  VALUE result = rb_hash_new();
	  rb_hash_aset(result, rb_str_new2("NODE_BLOCK"), ast_to_values(hash, RNODE_BLOCK(node)->nd_head));
	  return result;
	}
	case NODE_LIST: {
	  VALUE result = rb_hash_new();
	  rb_hash_aset(result, rb_str_new2("NODE_LIST"), list_node_to_hash(node));
	  return result;
	}
	case NODE_INTEGER: {
	  VALUE result = rb_hash_new();
	  rb_hash_aset(result, rb_str_new2("NODE_INTEGER"), rb_node_integer_literal_val(node));
	  return result;
	}
	case NODE_FLOAT: {
	  VALUE result = rb_hash_new();
	  rb_hash_aset(result, rb_str_new2("NODE_FLOAT"), rb_node_float_literal_val(node));
	  return result;
	}
	case NODE_RATIONAL: {
	  VALUE result = rb_hash_new();
	  rb_hash_aset(result, rb_str_new2("NODE_RATIONAL"), rb_node_rational_literal_val(node));
	  return result;
	}
	case NODE_IMAGINARY: {
	  VALUE result = rb_hash_new();
	  rb_hash_aset(result, rb_str_new2("NODE_IMAGINARY"), rb_node_imaginary_literal_val(node));
	  return result;
	}
	case NODE_STR: {
	  VALUE result = rb_hash_new();
	  rb_hash_aset(result, rb_str_new2("NODE_STR"), rb_node_str_string_val(node));
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

    return ast_to_values(result, ast->body.root);
}

RUBY_FUNC_EXPORTED void
Init_mjollnir(void)
{
    rb_mMjollnir = rb_define_module("Mjollnir");
    rb_define_singleton_method(rb_mMjollnir, "parse", parse, 1);
}
