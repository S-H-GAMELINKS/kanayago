#include "kanayago.h"

#define symbol(arg) \
    ID2SYM(rb_intern((arg)))

VALUE rb_mKanayago;

static VALUE ast_to_hash(const NODE *);

static VALUE
node_opcall_to_hash(const NODE *node)
{
    VALUE result = rb_hash_new();
    rb_hash_aset(result, symbol("recv"), ast_to_hash(RNODE_OPCALL(node)->nd_recv));
    rb_hash_aset(result, symbol("mid"), ID2SYM(RNODE_OPCALL(node)->nd_mid));
    rb_hash_aset(result, symbol("args"), ast_to_hash(RNODE_OPCALL(node)->nd_args));
    return result;
}

static VALUE
node_call_to_hash(const NODE *node)
{
    VALUE result = rb_hash_new();

    rb_hash_aset(result, symbol("recv"), ast_to_hash(RNODE_OPCALL(node)->nd_recv));
    rb_hash_aset(result, symbol("mid"), ID2SYM(RNODE_CALL(node)->nd_mid));
    rb_hash_aset(result, symbol("args"), ast_to_hash(RNODE_CALL(node)->nd_args));

    return result;
}

static VALUE
node_fcall_to_hash(const NODE *node)
{
    VALUE result = rb_hash_new();

    rb_hash_aset(result, symbol("mid"), ID2SYM(RNODE_FCALL(node)->nd_mid));
    rb_hash_aset(result, symbol("args"), ast_to_hash(RNODE_FCALL(node)->nd_args));

    return result;
}

static VALUE
node_list_to_hash(const NODE *node)
{
    VALUE result = rb_ary_new();
    NODE *nd_head = RNODE_LIST(node)->nd_head;
    int list_len = RNODE_LIST(node)->as.nd_alen;

    for (int i = 0; i < list_len; i++ ) {
	rb_ary_push(result, ast_to_hash(nd_head));
	nd_head = RNODE_LIST(node)->nd_next;
    }

    return result;
}

static VALUE
node_defn_to_hash(const NODE *node)
{
    VALUE result = rb_hash_new();

    rb_hash_aset(result, symbol("mid"), ID2SYM(RNODE_DEFN(node)->nd_mid));
    rb_hash_aset(result, symbol("defn"), ast_to_hash(RNODE_DEFN(node)->nd_defn));

    return result;
}

static VALUE
node_block_to_hash(const NODE *node)
{
    VALUE result = rb_ary_new();
    const NODE *current_node = node;

    while (current_node) {
 	rb_ary_push(result, ast_to_hash(RNODE_BLOCK(current_node)->nd_head));
	current_node = RNODE_BLOCK(current_node)->nd_next;
    }

    return result;
}

static VALUE
node_lasgn_to_hash(const NODE *node)
{
    VALUE result = rb_hash_new();

    rb_hash_aset(result, symbol("id"), ID2SYM(RNODE_LASGN(node)->nd_vid));
    rb_hash_aset(result, symbol("value"), ast_to_hash(RNODE_LASGN(node)->nd_value));

    return result;
}

static VALUE
node_lvar_to_hash(const NODE *node)
{
    VALUE result = rb_hash_new();

    rb_hash_aset(result, symbol("vid"), ID2SYM(RNODE_LVAR(node)->nd_vid));

    return result;
}

static VALUE
node_if_to_hash(const NODE *node)
{
    VALUE result = rb_hash_new();

    rb_hash_aset(result, symbol("cond"), ast_to_hash(RNODE_IF(node)->nd_cond));
    rb_hash_aset(result, symbol("body"), ast_to_hash(RNODE_IF(node)->nd_body));
    rb_hash_aset(result, symbol("else"), ast_to_hash(RNODE_IF(node)->nd_else));

    return result;
}

static VALUE
node_unless_to_hash(const NODE *node)
{
    VALUE result = rb_hash_new();

    rb_hash_aset(result, symbol("cond"), ast_to_hash(RNODE_UNLESS(node)->nd_cond));
    rb_hash_aset(result, symbol("body"), ast_to_hash(RNODE_UNLESS(node)->nd_body));
    rb_hash_aset(result, symbol("else"), ast_to_hash(RNODE_UNLESS(node)->nd_else));

    return result;
}

static VALUE
node_const_to_hash(const NODE *node)
{
    VALUE result = rb_hash_new();

    rb_hash_aset(result, symbol("vid"), ID2SYM(RNODE_CONST(node)->nd_vid));

    return result;
}

static VALUE
node_cdecl_to_hash(const NODE *node)
{
    VALUE result = rb_hash_new();

    rb_hash_aset(result, symbol("vid"), ID2SYM(RNODE_CDECL(node)->nd_vid));
    rb_hash_aset(result, symbol("else"), ast_to_hash(RNODE_CDECL(node)->nd_else));
    rb_hash_aset(result, symbol("value"), ast_to_hash(RNODE_CDECL(node)->nd_value));

    return result;
}

static VALUE
node_literal_to_hash(const NODE *node)
{
    enum node_type type = nd_type(node);

    switch (type) {
	case NODE_INTEGER: {
	  VALUE result = rb_hash_new();
	  rb_hash_aset(result, symbol("NODE_INTEGER"), rb_node_integer_literal_val(node));
	  return result;
	}
	case NODE_FLOAT: {
	  VALUE result = rb_hash_new();
	  rb_hash_aset(result, symbol("NODE_FLOAT"), rb_node_float_literal_val(node));
	  return result;
	}
	case NODE_RATIONAL: {
	  VALUE result = rb_hash_new();
	  rb_hash_aset(result, symbol("NODE_RATIONAL"), rb_node_rational_literal_val(node));
	  return result;
	}
	case NODE_IMAGINARY: {
	  VALUE result = rb_hash_new();
	  rb_hash_aset(result, symbol("NODE_IMAGINARY"), rb_node_imaginary_literal_val(node));
	  return result;
	}
	case NODE_STR: {
	  VALUE result = rb_hash_new();
	  rb_hash_aset(result, symbol("NODE_STR"), rb_node_str_string_val(node));
	  return result;
	}
	case NODE_SYM: {
	  VALUE result = rb_hash_new();
	  rb_hash_aset(result, symbol("NODE_SYM"), rb_node_sym_string_val(node));
	  return result;
	}
	default:
	  return Qnil;
    }
}

static VALUE
node_class_to_hash(const NODE *node)
{
    VALUE result = rb_hash_new();

    rb_hash_aset(result, symbol("cpath"), ast_to_hash(RNODE_CLASS(node)->nd_cpath));
    rb_hash_aset(result, symbol("super"), ast_to_hash(RNODE_CLASS(node)->nd_super));
    rb_hash_aset(result, symbol("body"), ast_to_hash(RNODE_CLASS(node)->nd_body));

    return result;
}

static VALUE
node_colon2_to_hash(const NODE *node)
{
    VALUE result = rb_hash_new();

    rb_hash_aset(result, symbol("mid"), ID2SYM(RNODE_COLON2(node)->nd_mid));
    rb_hash_aset(result, symbol("head"), ast_to_hash(RNODE_COLON2(node)->nd_head));

    return result;
}

static VALUE
node_begin_to_hash(const NODE *node)
{
    VALUE result = rb_hash_new();

    rb_hash_aset(result, symbol("body"), ast_to_hash(RNODE_BEGIN(node)->nd_body));

    return result;
}

static VALUE
node_scope_to_hash(const NODE *node)
{
    VALUE result = rb_hash_new();

    rb_hash_aset(result, symbol("args"), ast_to_hash((const NODE *)(RNODE_SCOPE(node)->nd_args)));
    rb_hash_aset(result, symbol("body"), ast_to_hash(RNODE_SCOPE(node)->nd_body));

    return result;
}

static VALUE
args_ainfo_to_hash(const struct rb_args_info ainfo)
{
    VALUE result = rb_hash_new();

    rb_hash_aset(result, symbol("forwarding"), INT2NUM(ainfo.forwarding));
    rb_hash_aset(result, symbol("pre_args_num"), INT2NUM(ainfo.pre_args_num));
    rb_hash_aset(result, symbol("pre_init"), ast_to_hash(ainfo.pre_init));
    rb_hash_aset(result, symbol("post_args_num"), INT2NUM(ainfo.post_args_num));
    rb_hash_aset(result, symbol("post_init"), ast_to_hash(ainfo.post_init));
    rb_hash_aset(result, symbol("first_post_arg"), Qnil);
    rb_hash_aset(result, symbol("rest_arg"), Qnil);
    rb_hash_aset(result, symbol("block_arg"), Qnil);
    rb_hash_aset(result, symbol("opt_args"), ast_to_hash((const NODE *)(ainfo.opt_args)));
    rb_hash_aset(result, symbol("kw_args"), ast_to_hash((const NODE *)(ainfo.kw_args)));
    rb_hash_aset(result, symbol("kw_rest_arg"), ast_to_hash(ainfo.kw_rest_arg));

    return result;
}

static VALUE
node_args_to_hash(const NODE *node)
{
    VALUE result = rb_hash_new();
    VALUE ainfo_hash = args_ainfo_to_hash(RNODE_ARGS(node)->nd_ainfo);

    rb_hash_aset(result, symbol("ainfo"), ainfo_hash);

    return result;
}

static VALUE
node_ivar_to_hash(const NODE *node)
{
    VALUE result = rb_hash_new();

    rb_hash_aset(result, symbol("vid"), ID2SYM(RNODE_IVAR(node)->nd_vid));

    return result;
}

static VALUE
ast_to_hash(const NODE *node)
{
    enum node_type type;

    if (!node) {
        return Qnil;
    }

    type = nd_type(node);

    switch (type) {
	case NODE_SCOPE: {
	  VALUE result = rb_hash_new();
	  rb_hash_aset(result, symbol("NODE_SCOPE"), node_scope_to_hash(node));
	  return result;
	}
	case NODE_CLASS: {
	  VALUE result = rb_hash_new();
	  rb_hash_aset(result, symbol("NODE_CLASS"), node_class_to_hash(node));
	  return result;
	}
	case NODE_DEFN: {
	  VALUE result = rb_hash_new();
	  rb_hash_aset(result, symbol("NODE_DEFN"), node_defn_to_hash(node));
	  return result;
	}
	case NODE_OPCALL: {
	  VALUE result = rb_hash_new();
	  rb_hash_aset(result, symbol("NODE_OPCALL"), node_opcall_to_hash(node));
	  return result;
	}
	case NODE_FCALL: {
	  VALUE result = rb_hash_new();
	  rb_hash_aset(result, symbol("NODE_FCALL"), node_fcall_to_hash(node));
	  return result;
	}
	case NODE_CALL: {
	  VALUE result = rb_hash_new();
	  rb_hash_aset(result, symbol("NODE_CALL"), node_call_to_hash(node));
	  return result;
	}
	case NODE_ARGS: {
	  VALUE result = rb_hash_new();
	  rb_hash_aset(result, symbol("NODE_ARGS"), node_args_to_hash(node));
	  return result;
	}
	case NODE_BLOCK: {
	  VALUE result = rb_hash_new();
	  rb_hash_aset(result, symbol("NODE_BLOCK"), node_block_to_hash(node));
	  return result;
	}
	case NODE_LASGN: {
	  VALUE result = rb_hash_new();
	  rb_hash_aset(result, symbol("NODE_LASGN"), node_lasgn_to_hash(node));
	  return result;
	}
	case NODE_LVAR: {
	  VALUE result = rb_hash_new();
	  rb_hash_aset(result, symbol("NODE_LVAR"), node_lvar_to_hash(node));
	  return result;
	}
	case NODE_IF: {
	  VALUE result = rb_hash_new();
	  rb_hash_aset(result, symbol("NODE_IF"), node_if_to_hash(node));
	  return result;
	}
	case NODE_UNLESS: {
	  VALUE result = rb_hash_new();
	  rb_hash_aset(result, symbol("NODE_UNLESS"), node_unless_to_hash(node));
	  return result;
	}
	case NODE_LIST: {
	  VALUE result = rb_hash_new();
	  rb_hash_aset(result, symbol("NODE_LIST"), node_list_to_hash(node));
	  return result;
	}
	case NODE_CONST: {
	  VALUE result = rb_hash_new();
	  rb_hash_aset(result, symbol("NODE_CONST"), node_const_to_hash(node));
	  return result;
	}
	case NODE_CDECL: {
	  VALUE result = rb_hash_new();
	  rb_hash_aset(result, symbol("NODE_CDECL"), node_cdecl_to_hash(node));
	  return result;
	}
	case NODE_COLON2: {
	  VALUE result = rb_hash_new();
	  rb_hash_aset(result, symbol("NODE_COLON2"), node_colon2_to_hash(node));
	  return result;
	}
	case NODE_BEGIN: {
	  VALUE result = rb_hash_new();
	  rb_hash_aset(result, symbol("NODE_BEGIN"), node_begin_to_hash(node));
	  return result;
	}
	case NODE_IVAR: {
	  VALUE result = rb_hash_new();
	  rb_hash_aset(result, symbol("NODE_IVAR"), node_ivar_to_hash(node));
	  return result;
	}
	case NODE_INTEGER:
	case NODE_FLOAT:
	case NODE_RATIONAL:
	case NODE_IMAGINARY:
	case NODE_STR:
	case NODE_SYM:
	  return node_literal_to_hash(node);
	default:
	  return Qfalse;
    }
}

static VALUE
kanayago_parse(VALUE self, VALUE source)
{   
    struct ruby_parser *parser;
    rb_parser_t *parser_params;

    parser_params = rb_parser_params_new();
    VALUE vparser = TypedData_Make_Struct(0, struct ruby_parser,
                                         &ruby_parser_data_type, parser);
    parser->parser_params = parser_params;


    VALUE vast = rb_parser_compile_string(vparser, "main", source, 0);

    rb_ast_t *ast = rb_ruby_ast_data_get(vast);

    return ast_to_hash(ast->body.root);
}

RUBY_FUNC_EXPORTED void
Init_kanayago(void)
{
    rb_mKanayago = rb_define_module("Kanayago");
    rb_define_module_function(rb_mKanayago, "kanayago_parse", kanayago_parse, 1);
}
