#include "pattern_node.h"
#include "internal/ruby_parser.h"
#include "kanayago.h"

VALUE rb_cInNode;
VALUE rb_cArrayPatternNode;
VALUE rb_cHashPatternNode;
VALUE rb_cFindPatternNode;

VALUE
in_node_new(const NODE *node)
{
    VALUE obj = rb_class_new_instance(0, 0, rb_cInNode);

    rb_ivar_set(obj, rb_intern("@head"), ast_to_node_instance(RNODE_IN(node)->nd_head));
    rb_ivar_set(obj, rb_intern("@body"), ast_to_node_instance(RNODE_IN(node)->nd_body));
    rb_ivar_set(obj, rb_intern("@next"), ast_to_node_instance(RNODE_IN(node)->nd_next));

    return obj;
}

VALUE
array_pattern_node_new(const NODE *node)
{
    VALUE obj = rb_class_new_instance(0, 0, rb_cArrayPatternNode);
    NODE *rest_arg = RNODE_ARYPTN(node)->rest_arg;

    rb_ivar_set(obj, rb_intern("@pconst"), ast_to_node_instance(RNODE_ARYPTN(node)->nd_pconst));
    rb_ivar_set(obj, rb_intern("@pre_args"), ast_to_node_instance(RNODE_ARYPTN(node)->pre_args));
    // rest_arg can be NODE_SPECIAL_NO_NAME_REST (-1), which should be preserved as a special marker
    rb_ivar_set(obj, rb_intern("@rest_arg"),
                (rest_arg == (NODE *)-1) ? INT2FIX(-1) : ast_to_node_instance(rest_arg));
    rb_ivar_set(obj, rb_intern("@post_args"), ast_to_node_instance(RNODE_ARYPTN(node)->post_args));

    return obj;
}

VALUE
hash_pattern_node_new(const NODE *node)
{
    VALUE obj = rb_class_new_instance(0, 0, rb_cHashPatternNode);

    rb_ivar_set(obj, rb_intern("@pconst"), ast_to_node_instance(RNODE_HSHPTN(node)->nd_pconst));
    rb_ivar_set(obj, rb_intern("@pkwargs"), ast_to_node_instance(RNODE_HSHPTN(node)->nd_pkwargs));
    rb_ivar_set(obj, rb_intern("@pkwrestarg"), ast_to_node_instance(RNODE_HSHPTN(node)->nd_pkwrestarg));

    return obj;
}

VALUE
find_pattern_node_new(const NODE *node)
{
    VALUE obj = rb_class_new_instance(0, 0, rb_cFindPatternNode);
    NODE *pre_rest_arg = RNODE_FNDPTN(node)->pre_rest_arg;
    NODE *post_rest_arg = RNODE_FNDPTN(node)->post_rest_arg;

    rb_ivar_set(obj, rb_intern("@pconst"), ast_to_node_instance(RNODE_FNDPTN(node)->nd_pconst));
    // rest args can be NODE_SPECIAL_NO_NAME_REST (-1)
    rb_ivar_set(obj, rb_intern("@pre_rest_arg"),
                (pre_rest_arg == (NODE *)-1) ? INT2FIX(-1) : ast_to_node_instance(pre_rest_arg));
    rb_ivar_set(obj, rb_intern("@args"), ast_to_node_instance(RNODE_FNDPTN(node)->args));
    rb_ivar_set(obj, rb_intern("@post_rest_arg"),
                (post_rest_arg == (NODE *)-1) ? INT2FIX(-1) : ast_to_node_instance(post_rest_arg));

    return obj;
}

void
Init_PatternNode(VALUE module, VALUE base)
{
    rb_cInNode = rb_define_class_under(module, "InNode", base);

    rb_cArrayPatternNode = rb_define_class_under(module, "ArrayPatternNode", base);

    rb_cHashPatternNode = rb_define_class_under(module, "HashPatternNode", base);

    rb_cFindPatternNode = rb_define_class_under(module, "FindPatternNode", base);
}
