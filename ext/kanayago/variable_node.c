#include "internal/ruby_parser.h"
#include "kanayago.h"

VALUE rb_cLocalVariableNode;
VALUE rb_cDynamicVariableNode;
VALUE rb_cInstanceVariableNode;
VALUE rb_cClassVariableNode;
VALUE rb_cGlobalVariableNode;

VALUE
local_variable_node_new(const NODE *node)
{
    VALUE obj = rb_class_new_instance(0, 0, rb_cLocalVariableNode);

    rb_ivar_set(obj, rb_intern("@vid"), ID2SYM(RNODE_LVAR(node)->nd_vid));

    return obj;
}

VALUE
dynamic_variable_node_new(const NODE *node)
{
    VALUE obj = rb_class_new_instance(0, 0, rb_cDynamicVariableNode);
    ID vid = RNODE_DVAR(node)->nd_vid;

    rb_ivar_set(obj, rb_intern("@vid"), vid ? ID2SYM(vid) : Qnil);

    return obj;
}

VALUE
instance_variable_node_new(const NODE *node)
{
    VALUE obj = rb_class_new_instance(0, 0, rb_cInstanceVariableNode);

    rb_ivar_set(obj, rb_intern("@vid"), ID2SYM(RNODE_IVAR(node)->nd_vid));

    return obj;
}

VALUE
class_variable_node_new(const NODE *node)
{
    VALUE obj = rb_class_new_instance(0, 0, rb_cClassVariableNode);

    rb_ivar_set(obj, rb_intern("@vid"), ID2SYM(RNODE_IVAR(node)->nd_vid));

    return obj;
}

VALUE
global_variable_node_new(const NODE *node)
{
    VALUE obj = rb_class_new_instance(0, 0, rb_cGlobalVariableNode);

    rb_ivar_set(obj, rb_intern("@vid"), ID2SYM(RNODE_GVAR(node)->nd_vid));

    return obj;
}

void
Init_VariableNode(VALUE module)
{
    rb_cLocalVariableNode = rb_define_class_under(module, "LocalVariableNode", rb_cObject);

    rb_cDynamicVariableNode = rb_define_class_under(module, "DynamicVariableNode", rb_cObject);

    rb_cInstanceVariableNode = rb_define_class_under(module, "InstanceVariableNode", rb_cObject);

    rb_cClassVariableNode = rb_define_class_under(module, "ClassVariableNode", rb_cObject);

    rb_cGlobalVariableNode = rb_define_class_under(module, "GlobalVariableNode", rb_cObject);
}
