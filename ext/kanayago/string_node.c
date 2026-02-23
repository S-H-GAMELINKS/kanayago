#include "string_node.h"
#include "internal/ruby_parser.h"
#include "internal/encoding.h"
#include "kanayago.h"

VALUE rb_cDynamicStringNode;
VALUE rb_cDynamicSymbolNode;
VALUE rb_cEmbeddedExpressionStringNode;
VALUE rb_cExecuteStringNode;
VALUE rb_cDynamicExecuteStringNode;
VALUE rb_cRegexpNode;
VALUE rb_cDynamicRegexpNode;
VALUE rb_cMatchNode;
VALUE rb_cMatch2Node;
VALUE rb_cMatch3Node;

VALUE
dynamic_string_node_new(const NODE *node)
{
    VALUE obj = rb_class_new_instance(0, 0, rb_cDynamicStringNode);
    rb_parser_string_t *str = RNODE_DSTR(node)->string;
    const NODE *nd_next = (const NODE *)RNODE_DSTR(node)->nd_next;

    if (str) {
        rb_encoding *enc = str->enc;
        char *ptr = str->ptr;
        long len = str->len;
        rb_ivar_set(obj, rb_intern("@string"), rb_enc_str_new(ptr, len, enc));
    } else {
        rb_ivar_set(obj, rb_intern("@string"), rb_str_new("", 0));
    }

    if (nd_next && nd_next != (NODE *)-1) {
        rb_ivar_set(obj, rb_intern("@next_nodes"), ast_to_node_instance(nd_next));
    } else {
        rb_ivar_set(obj, rb_intern("@next_nodes"), Qnil);
    }

    return obj;
}

VALUE
dynamic_symbol_node_new(const NODE *node)
{
    VALUE obj = rb_class_new_instance(0, 0, rb_cDynamicSymbolNode);
    rb_parser_string_t *str = RNODE_DSYM(node)->string;
    const NODE *nd_next = (const NODE *)RNODE_DSYM(node)->nd_next;

    if (str) {
        rb_encoding *enc = str->enc;
        char *ptr = str->ptr;
        long len = str->len;
        rb_ivar_set(obj, rb_intern("@string"), rb_enc_str_new(ptr, len, enc));
    } else {
        rb_ivar_set(obj, rb_intern("@string"), rb_str_new("", 0));
    }

    if (nd_next && nd_next != (NODE *)-1) {
        rb_ivar_set(obj, rb_intern("@next_nodes"), ast_to_node_instance(nd_next));
    } else {
        rb_ivar_set(obj, rb_intern("@next_nodes"), Qnil);
    }

    return obj;
}

VALUE
embedded_expression_string_node_new(const NODE *node)
{
    VALUE obj = rb_class_new_instance(0, 0, rb_cEmbeddedExpressionStringNode);

    rb_ivar_set(obj, rb_intern("@body"), ast_to_node_instance(RNODE_EVSTR(node)->nd_body));

    return obj;
}

VALUE
execute_string_node_new(const NODE *node)
{
    VALUE result = rb_class_new_instance(0, 0, rb_cExecuteStringNode);
    rb_parser_string_t *str = RNODE_XSTR(node)->string;
    rb_encoding *enc = str->enc;
    char *ptr = str->ptr;
    long len = str->len;
    enum rb_parser_string_coderange_type coderange = str->coderange;

    rb_ivar_set(result, rb_intern("@ptr"), rb_enc_str_new(ptr, len, enc));
    rb_ivar_set(result, rb_intern("@len"), LONG2FIX(len));
    rb_ivar_set(result, rb_intern("@enc"), rb_enc_from_encoding(enc));
    rb_ivar_set(result, rb_intern("@coderange"), INT2FIX(coderange));

    return result;
}

VALUE
dynamic_execute_string_node_new(const NODE *node)
{
    VALUE obj = rb_class_new_instance(0, 0, rb_cDynamicExecuteStringNode);
    rb_parser_string_t *str = RNODE_DXSTR(node)->string;
    const NODE *nd_next = (const NODE *)RNODE_DXSTR(node)->nd_next;

    if (str) {
        rb_encoding *enc = str->enc;
        char *ptr = str->ptr;
        long len = str->len;
        rb_ivar_set(obj, rb_intern("@string"), rb_enc_str_new(ptr, len, enc));
    } else {
        rb_ivar_set(obj, rb_intern("@string"), rb_str_new("", 0));
    }

    if (nd_next && nd_next != (NODE *)-1) {
        rb_ivar_set(obj, rb_intern("@next_nodes"), ast_to_node_instance(nd_next));
    } else {
        rb_ivar_set(obj, rb_intern("@next_nodes"), Qnil);
    }

    return obj;
}

VALUE
regexp_node_new(const NODE *node)
{
    VALUE result = rb_class_new_instance(0, 0, rb_cRegexpNode);
    rb_parser_string_t *str = RNODE_REGX(node)->string;
    rb_encoding *enc = str->enc;
    char *ptr = str->ptr;
    long len = str->len;
    enum rb_parser_string_coderange_type coderange = str->coderange;
    int options = RNODE_REGX(node)->options;

    rb_ivar_set(result, rb_intern("@ptr"), rb_enc_str_new(ptr, len, enc));
    rb_ivar_set(result, rb_intern("@len"), LONG2FIX(len));
    rb_ivar_set(result, rb_intern("@enc"), rb_enc_from_encoding(enc));
    rb_ivar_set(result, rb_intern("@coderange"), INT2FIX(coderange));
    rb_ivar_set(result, rb_intern("@options"), INT2FIX(options));

    return result;
}

VALUE
dynamic_regexp_node_new(const NODE *node)
{
    VALUE obj = rb_class_new_instance(0, 0, rb_cDynamicRegexpNode);
    rb_parser_string_t *str = RNODE_DREGX(node)->string;
    long options = RNODE_DREGX(node)->as.nd_cflag;
    const NODE *nd_next = (const NODE *)RNODE_DREGX(node)->nd_next;

    if (str) {
        rb_encoding *enc = str->enc;
        char *ptr = str->ptr;
        long len = str->len;
        rb_ivar_set(obj, rb_intern("@string"), rb_enc_str_new(ptr, len, enc));
    } else {
        rb_ivar_set(obj, rb_intern("@string"), rb_str_new("", 0));
    }

    if (nd_next && nd_next != (NODE *)-1) {
        rb_ivar_set(obj, rb_intern("@next_nodes"), ast_to_node_instance(nd_next));
    } else {
        rb_ivar_set(obj, rb_intern("@next_nodes"), Qnil);
    }

    rb_ivar_set(obj, rb_intern("@options"), LONG2FIX(options));

    return obj;
}

VALUE
match_node_new(const NODE *node)
{
    VALUE result = rb_class_new_instance(0, 0, rb_cMatchNode);
    rb_parser_string_t *str = RNODE_MATCH(node)->string;
    rb_encoding *enc = str->enc;
    char *ptr = str->ptr;
    long len = str->len;
    enum rb_parser_string_coderange_type coderange = str->coderange;
    int options = RNODE_MATCH(node)->options;

    rb_ivar_set(result, rb_intern("@ptr"), rb_enc_str_new(ptr, len, enc));
    rb_ivar_set(result, rb_intern("@len"), LONG2FIX(len));
    rb_ivar_set(result, rb_intern("@enc"), rb_enc_from_encoding(enc));
    rb_ivar_set(result, rb_intern("@coderange"), INT2FIX(coderange));
    rb_ivar_set(result, rb_intern("@options"), INT2FIX(options));

    return result;
}

VALUE
match2_node_new(const NODE *node)
{
    VALUE obj = rb_class_new_instance(0, 0, rb_cMatch2Node);

    rb_ivar_set(obj, rb_intern("@recv"), ast_to_node_instance(RNODE_MATCH2(node)->nd_recv));
    rb_ivar_set(obj, rb_intern("@value"), ast_to_node_instance(RNODE_MATCH2(node)->nd_value));
    rb_ivar_set(obj, rb_intern("@args"), ast_to_node_instance(RNODE_MATCH2(node)->nd_args));

    return obj;
}

VALUE
match3_node_new(const NODE *node)
{
    VALUE obj = rb_class_new_instance(0, 0, rb_cMatch3Node);

    rb_ivar_set(obj, rb_intern("@recv"), ast_to_node_instance(RNODE_MATCH3(node)->nd_recv));
    rb_ivar_set(obj, rb_intern("@value"), ast_to_node_instance(RNODE_MATCH3(node)->nd_value));

    return obj;
}

void
Init_StringNode(VALUE module, VALUE base)
{
    rb_cDynamicStringNode = rb_define_class_under(module, "DynamicStringNode", base);

    rb_cDynamicSymbolNode = rb_define_class_under(module, "DynamicSymbolNode", base);

    rb_cEmbeddedExpressionStringNode = rb_define_class_under(module, "EmbeddedExpressionStringNode", base);

    rb_cExecuteStringNode = rb_define_class_under(module, "ExecuteStringNode", base);

    rb_cDynamicExecuteStringNode = rb_define_class_under(module, "DynamicExecuteStringNode", base);

    rb_cRegexpNode = rb_define_class_under(module, "RegexpNode", base);

    rb_cDynamicRegexpNode = rb_define_class_under(module, "DynamicRegexpNode", base);

    rb_cMatchNode = rb_define_class_under(module, "MatchNode", base);

    rb_cMatch2Node = rb_define_class_under(module, "Match2Node", base);

    rb_cMatch3Node = rb_define_class_under(module, "Match3Node", base);
}
