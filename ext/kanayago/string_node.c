#include "string_node.h"
#include "internal/ruby_parser.h"
#include "internal/encoding.h"
#include "kanayago.h"

VALUE rb_cDynamicStringNode;
VALUE rb_cEmbeddedExpressionStringNode;

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

void
Init_StringNode(VALUE module)
{
    rb_cDynamicStringNode = rb_define_class_under(module, "DynamicStringNode", rb_cObject);

    rb_cEmbeddedExpressionStringNode = rb_define_class_under(module, "EmbeddedExpressionStringNode", rb_cObject);
}
