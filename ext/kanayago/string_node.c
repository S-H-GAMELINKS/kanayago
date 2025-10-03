#include "string_node.h"
#include "internal/ruby_parser.h"
#include "internal/encoding.h"
#include "kanayago.h"

VALUE rb_cDynamicStringNode;
VALUE rb_cEmbeddedExpressionStringNode;
VALUE rb_cExecuteStringNode;
VALUE rb_cDynamicExecuteStringNode;

VALUE
dynamic_string_node_new(const NODE *node)
{
    VALUE obj = rb_class_new_instance(0, 0, rb_cDynamicStringNode);
    rb_parser_string_t *str = RNODE_DSTR(node)->string;
    rb_encoding *enc = str->enc;
    char *ptr = str->ptr;
    long len = str->len;

    rb_ivar_set(obj, rb_intern("@string"), rb_enc_str_new(ptr, len, enc));
    rb_ivar_set(obj, rb_intern("@next_nodes"), ast_to_node_instance((const NODE *)RNODE_DSTR(node)->nd_next));

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
    rb_encoding *enc = str->enc;
    char *ptr = str->ptr;
    long len = str->len;

    rb_ivar_set(obj, rb_intern("@string"), rb_enc_str_new(ptr, len, enc));
    rb_ivar_set(obj, rb_intern("@next_nodes"), ast_to_node_instance((const NODE *)RNODE_DXSTR(node)->nd_next));

    return obj;
}

void
Init_StringNode(VALUE module)
{
    rb_cDynamicStringNode = rb_define_class_under(module, "DynamicStringNode", rb_cObject);

    rb_cEmbeddedExpressionStringNode = rb_define_class_under(module, "EmbeddedExpressionStringNode", rb_cObject);

    rb_cExecuteStringNode = rb_define_class_under(module, "ExecuteStringNode", rb_cObject);

    rb_cDynamicExecuteStringNode = rb_define_class_under(module, "DynamicExecuteStringNode", rb_cObject);
}
