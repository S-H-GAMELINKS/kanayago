#include "kanayago.h"

VALUE rb_cScopeNode;

VALUE
scope_node_new(const NODE *node)
{
    VALUE result = rb_class_new_instance(0, 0, rb_cScopeNode);

    rb_ivar_set(result, rb_intern("@args"), ast_to_node_instance((const NODE *)(RNODE_SCOPE(node)->nd_args)));
    rb_ivar_set(result, rb_intern("@body"), ast_to_node_instance(RNODE_SCOPE(node)->nd_body));

    return result;
}

void
Init_ScopeNode(VALUE module)
{
    rb_cScopeNode = rb_define_class_under(module, "ScopeNode", rb_cObject);
}
