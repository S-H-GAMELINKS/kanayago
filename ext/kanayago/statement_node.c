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
VALUE rb_cAliasNode;
VALUE rb_cValiasNode;
VALUE rb_cUndefNode;
VALUE rb_cReturnNode;
VALUE rb_cGlobalAssignmentNode;
VALUE rb_cClassVariableAssignmentNode;
VALUE rb_cInstanceAssignmentNode;
VALUE rb_cLocalAssignmentNode;

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

VALUE
alias_node_new(const NODE *node)
{
    VALUE obj = rb_class_new_instance(0, 0, rb_cAliasNode);

    rb_ivar_set(obj, rb_intern("@first"), ast_to_node_instance(RNODE_ALIAS(node)->nd_1st));
    rb_ivar_set(obj, rb_intern("@second"), ast_to_node_instance(RNODE_ALIAS(node)->nd_2nd));

    return obj;
}

VALUE
valias_node_new(const NODE *node)
{
    VALUE obj = rb_class_new_instance(0, 0, rb_cValiasNode);

    rb_ivar_set(obj, rb_intern("@alias"), ID2SYM(RNODE_VALIAS(node)->nd_alias));
    rb_ivar_set(obj, rb_intern("@original"), ID2SYM(RNODE_VALIAS(node)->nd_orig));

    return obj;
}

VALUE
undef_node_new(const NODE *node)
{
    VALUE obj = rb_class_new_instance(0, 0, rb_cUndefNode);
    VALUE undefs = rb_ary_new();

    rb_parser_ary_t *nd_undefs = RNODE_UNDEF(node)->nd_undefs;

    for (int i = 0; i < nd_undefs->len; i++) {
        rb_ary_push(undefs, ast_to_node_instance((const NODE *)(nd_undefs->data[i])));
    }

    rb_ivar_set(obj, rb_intern("@undefs"), undefs);

    return obj;
}

VALUE
return_node_new(const NODE *node)
{
    VALUE obj = rb_class_new_instance(0, 0, rb_cReturnNode);

    rb_ivar_set(obj, rb_intern("@statements"), ast_to_node_instance(RNODE_RETURN(node)->nd_stts));

    return obj;
}

VALUE
global_assignment_node_new(const NODE *node)
{
    VALUE obj = rb_class_new_instance(0, 0, rb_cGlobalAssignmentNode);

    rb_ivar_set(obj, rb_intern("@id"), ID2SYM(RNODE_GASGN(node)->nd_vid));
    rb_ivar_set(obj, rb_intern("@value"), ast_to_node_instance(RNODE_GASGN(node)->nd_value));

    return obj;
}

VALUE
class_variable_assignment_node_new(const NODE *node)
{
    VALUE obj = rb_class_new_instance(0, 0, rb_cClassVariableAssignmentNode);

    rb_ivar_set(obj, rb_intern("@id"), ID2SYM(RNODE_IASGN(node)->nd_vid));
    rb_ivar_set(obj, rb_intern("@value"), ast_to_node_instance(RNODE_IASGN(node)->nd_value));

    return obj;
}

VALUE
instance_assignment_node_new(const NODE *node)
{
    VALUE obj = rb_class_new_instance(0, 0, rb_cInstanceAssignmentNode);

    rb_ivar_set(obj, rb_intern("@id"), ID2SYM(RNODE_IASGN(node)->nd_vid));
    rb_ivar_set(obj, rb_intern("@value"), ast_to_node_instance(RNODE_IASGN(node)->nd_value));

    return obj;
}

VALUE
local_assignment_node_new(const NODE *node)
{
    VALUE obj = rb_class_new_instance(0, 0, rb_cLocalAssignmentNode);

    rb_ivar_set(obj, rb_intern("@id"), ID2SYM(RNODE_LASGN(node)->nd_vid));
    rb_ivar_set(obj, rb_intern("@value"), ast_to_node_instance(RNODE_LASGN(node)->nd_value));

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

    rb_cAliasNode = rb_define_class_under(module, "AliasNode", rb_cObject);

    rb_cValiasNode = rb_define_class_under(module, "ValiasNode", rb_cObject);

    rb_cUndefNode = rb_define_class_under(module, "UndefNode", rb_cObject);

    rb_cReturnNode = rb_define_class_under(module, "ReturnNode", rb_cObject);

    rb_cGlobalAssignmentNode = rb_define_class_under(module, "GlobalAssignmentNode", rb_cObject);

    rb_cClassVariableAssignmentNode = rb_define_class_under(module, "ClassVariableAssignmentNode", rb_cObject);

    rb_cInstanceAssignmentNode = rb_define_class_under(module, "InstanceAssignmentNode", rb_cObject);

    rb_cLocalAssignmentNode = rb_define_class_under(module, "LocalAssignmentNode", rb_cObject);
}
