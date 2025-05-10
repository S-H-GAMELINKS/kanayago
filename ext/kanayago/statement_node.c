#include "statement_node.h"
#include "internal/ruby_parser.h"
#include "kanayago.h"
#include "rubyparser.h"

VALUE rb_cIfStatementNode;
VALUE rb_cUnlessStatementNode;
VALUE rb_cOrNode;
VALUE rb_cAndNode;
VALUE rb_cWhileNode;
VALUE rb_cUntilNode;
VALUE rb_cForNode;

VALUE
if_statement_node_new(const NODE *node)
{
    VALUE obj = rb_class_new_instance(0, 0, rb_cIfStatementNode);

    rb_ivar_set(obj, rb_intern("cond"), ast_to_node_instance(RNODE_IF(node)->nd_cond));
    rb_ivar_set(obj, rb_intern("body"), ast_to_node_instance(RNODE_IF(node)->nd_body));
    rb_ivar_set(obj, rb_intern("else"), ast_to_node_instance(RNODE_IF(node)->nd_else));

    return obj;
}

VALUE
unless_statement_node_new(const NODE *node)
{
    VALUE obj = rb_class_new_instance(0, 0, rb_cUnlessStatementNode);

    rb_ivar_set(obj, rb_intern("@cond"), ast_to_node_instance(RNODE_UNLESS(node)->nd_cond));
    rb_ivar_set(obj, rb_intern("@body"), ast_to_node_instance(RNODE_UNLESS(node)->nd_body));
    rb_ivar_set(obj, rb_intern("@else"), ast_to_node_instance(RNODE_UNLESS(node)->nd_else));

    return obj;
}

VALUE
or_node_new(const NODE *node)
{
    VALUE obj = rb_class_new_instance(0, 0, rb_cOrNode);

    rb_ivar_set(obj, rb_intern("@first"), ast_to_node_instance(RNODE_OR(node)->nd_1st));
    rb_ivar_set(obj, rb_intern("@second"), ast_to_node_instance(RNODE_OR(node)->nd_2nd));

    return obj;
}

VALUE
and_node_new(const NODE *node)
{
    VALUE obj = rb_class_new_instance(0, 0, rb_cAndNode);

    rb_ivar_set(obj, rb_intern("@first"), ast_to_node_instance(RNODE_AND(node)->nd_1st));
    rb_ivar_set(obj, rb_intern("@second"), ast_to_node_instance(RNODE_AND(node)->nd_2nd));

    return obj;
}

VALUE
while_node_new(const NODE *node)
{
    VALUE obj = rb_class_new_instance(0, 0, rb_cWhileNode);

    rb_ivar_set(obj, rb_intern("@state"), LONG2FIX(RNODE_WHILE(node)->nd_state));
    rb_ivar_set(obj, rb_intern("@cond"), ast_to_node_instance(RNODE_WHILE(node)->nd_cond));
    rb_ivar_set(obj, rb_intern("@body"), ast_to_node_instance(RNODE_WHILE(node)->nd_body));

    return obj;
}

VALUE
until_node_new(const NODE *node)
{
    VALUE obj = rb_class_new_instance(0, 0, rb_cUntilNode);

    rb_ivar_set(obj, rb_intern("@state"), LONG2FIX(RNODE_UNTIL(node)->nd_state));
    rb_ivar_set(obj, rb_intern("@cond"), ast_to_node_instance(RNODE_UNTIL(node)->nd_cond));
    rb_ivar_set(obj, rb_intern("@body"), ast_to_node_instance(RNODE_UNTIL(node)->nd_body));

    return obj;
}

VALUE
for_node_new(const NODE *node)
{
    VALUE obj = rb_class_new_instance(0, 0, rb_cForNode);

    rb_ivar_set(obj, rb_intern("@iter"), ast_to_node_instance(RNODE_FOR(node)->nd_iter));
    rb_ivar_set(obj, rb_intern("@body"), ast_to_node_instance(RNODE_FOR(node)->nd_body));

    return obj;
}

void
Init_StatementNode(VALUE module)
{
    rb_cIfStatementNode = rb_define_class_under(module, "IfStatementNode", rb_cObject);

    rb_cUnlessStatementNode = rb_define_class_under(module, "UnlessStatementNode", rb_cObject);

    rb_cOrNode = rb_define_class_under(module, "OrNode", rb_cObject);

    rb_cAndNode = rb_define_class_under(module, "AndNode", rb_cObject);

    rb_cWhileNode = rb_define_class_under(module, "WhileNode", rb_cObject);

    rb_cUntilNode = rb_define_class_under(module, "UntilNode", rb_cObject);

    rb_cForNode = rb_define_class_under(module, "ForNode", rb_cObject);
}
