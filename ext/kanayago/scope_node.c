#include "kanayago.h"

VALUE rb_cScopeNode;

VALUE
scope_node_new(const NODE *node)
{
    VALUE result = rb_class_new_instance(0, 0, rb_cScopeNode);

    rb_ivar_set(result, symbol("args"), ast_to_node_instance((const NODE *)(RNODE_SCOPE(node)->nd_args)));
    rb_ivar_set(result, symbol("body"), ast_to_node_instance(RNODE_SCOPE(node)->nd_body));

    return result;
}

static VALUE
scope_node_args_get(VALUE self)
{
    return rb_ivar_get(self, symbol("args"));
}

static VALUE
scope_node_body_get(VALUE self)
{
    return rb_ivar_get(self, symbol("body"));
}

void
Init_ScopeNode(VALUE module)
{
    rb_cScopeNode = rb_define_class_under(module, "ScopeNode", rb_cObject);
    rb_define_method(rb_cScopeNode, "args", scope_node_args_get, 0);
    rb_define_method(rb_cScopeNode, "body", scope_node_body_get, 0);
}
