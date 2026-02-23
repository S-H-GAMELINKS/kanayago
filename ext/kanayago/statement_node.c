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
VALUE rb_cSingletonDefinitionNode;
VALUE rb_cSingletonClassNode;
VALUE rb_cAttributeAssignmentNode;
VALUE rb_cSafeCallNode;
VALUE rb_cSuperNode;
VALUE rb_cZeroSuperNode;
VALUE rb_cCaseNode;
VALUE rb_cCase2Node;
VALUE rb_cCase3Node;
VALUE rb_cWhenNode;
VALUE rb_cRetryNode;
VALUE rb_cRedoNode;
VALUE rb_cBreakNode;
VALUE rb_cNextNode;
VALUE rb_cDefinedNode;
VALUE rb_cIterNode;
VALUE rb_cEnsureNode;
VALUE rb_cRescueNode;
VALUE rb_cRescueBodyNode;
VALUE rb_cOperatorAssignment1Node;
VALUE rb_cOperatorAssignment2Node;
VALUE rb_cOperatorAssignmentAndNode;
VALUE rb_cOperatorAssignmentOrNode;
VALUE rb_cOperatorConstantDeclarationNode;
VALUE rb_cYieldNode;
VALUE rb_cLambdaNode;
VALUE rb_cSplatNode;
VALUE rb_cBlockPassNode;
VALUE rb_cArgsAuxNode;
VALUE rb_cOptArgNode;
VALUE rb_cKwArgNode;
VALUE rb_cPostArgNode;
VALUE rb_cArgsCatNode;
VALUE rb_cArgsPushNode;
VALUE rb_cForMasgnNode;
VALUE rb_cMasgnNode;
VALUE rb_cDasgnNode;
VALUE rb_cOnceNode;
VALUE rb_cErrinfoNode;
VALUE rb_cPostexeNode;
VALUE rb_cErrorNode;

VALUE
if_statement_node_new(const NODE *node)
{
    VALUE obj = rb_class_new_instance(0, 0, rb_cIfStatementNode);

    rb_ivar_set(obj, rb_intern("@cond"), ast_to_node_instance(RNODE_IF(node)->nd_cond));
    rb_ivar_set(obj, rb_intern("@body"), ast_to_node_instance(RNODE_IF(node)->nd_body));
    rb_ivar_set(obj, rb_intern("@else"), ast_to_node_instance(RNODE_IF(node)->nd_else));

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

VALUE
singleton_definition_node_new(const NODE *node)
{
    VALUE obj = rb_class_new_instance(0, 0, rb_cSingletonDefinitionNode);

    rb_ivar_set(obj, rb_intern("@recv"), ast_to_node_instance(RNODE_DEFS(node)->nd_recv));
    rb_ivar_set(obj, rb_intern("@mid"), ID2SYM(RNODE_DEFS(node)->nd_mid));
    rb_ivar_set(obj, rb_intern("@defn"), ast_to_node_instance(RNODE_DEFS(node)->nd_defn));

    return obj;
}

VALUE
singleton_class_node_new(const NODE *node)
{
    VALUE obj = rb_class_new_instance(0, 0, rb_cSingletonClassNode);

    rb_ivar_set(obj, rb_intern("@recv"), ast_to_node_instance(RNODE_SCLASS(node)->nd_recv));
    rb_ivar_set(obj, rb_intern("@body"), ast_to_node_instance(RNODE_SCLASS(node)->nd_body));

    return obj;
}

VALUE
attribute_assignment_node_new(const NODE *node)
{
    VALUE obj = rb_class_new_instance(0, 0, rb_cAttributeAssignmentNode);

    rb_ivar_set(obj, rb_intern("@recv"), ast_to_node_instance(RNODE_ATTRASGN(node)->nd_recv));
    rb_ivar_set(obj, rb_intern("@mid"), ID2SYM(RNODE_ATTRASGN(node)->nd_mid));
    rb_ivar_set(obj, rb_intern("@args"), ast_to_node_instance(RNODE_ATTRASGN(node)->nd_args));

    return obj;
}

VALUE
safe_call_node_new(const NODE *node)
{
    VALUE obj = rb_class_new_instance(0, 0, rb_cSafeCallNode);

    rb_ivar_set(obj, rb_intern("@recv"), ast_to_node_instance(RNODE_QCALL(node)->nd_recv));
    rb_ivar_set(obj, rb_intern("@mid"), ID2SYM(RNODE_QCALL(node)->nd_mid));
    rb_ivar_set(obj, rb_intern("@args"), ast_to_node_instance(RNODE_QCALL(node)->nd_args));

    return obj;
}

VALUE
super_node_new(const NODE *node)
{
    VALUE obj = rb_class_new_instance(0, 0, rb_cSuperNode);

    rb_ivar_set(obj, rb_intern("@args"), ast_to_node_instance(RNODE_SUPER(node)->nd_args));

    return obj;
}

VALUE
zero_super_node_new(const NODE *node)
{
    VALUE obj = rb_class_new_instance(0, 0, rb_cZeroSuperNode);

    return obj;
}

VALUE
case_node_new(const NODE *node)
{
    VALUE obj = rb_class_new_instance(0, 0, rb_cCaseNode);

    rb_ivar_set(obj, rb_intern("@head"), ast_to_node_instance(RNODE_CASE(node)->nd_head));
    rb_ivar_set(obj, rb_intern("@body"), ast_to_node_instance(RNODE_CASE(node)->nd_body));

    return obj;
}

VALUE
case2_node_new(const NODE *node)
{
    VALUE obj = rb_class_new_instance(0, 0, rb_cCase2Node);

    rb_ivar_set(obj, rb_intern("@body"), ast_to_node_instance(RNODE_CASE2(node)->nd_body));

    return obj;
}

VALUE
case3_node_new(const NODE *node)
{
    VALUE obj = rb_class_new_instance(0, 0, rb_cCase3Node);

    rb_ivar_set(obj, rb_intern("@head"), ast_to_node_instance(RNODE_CASE3(node)->nd_head));
    rb_ivar_set(obj, rb_intern("@body"), ast_to_node_instance(RNODE_CASE3(node)->nd_body));

    return obj;
}

VALUE
when_node_new(const NODE *node)
{
    VALUE obj = rb_class_new_instance(0, 0, rb_cWhenNode);

    rb_ivar_set(obj, rb_intern("@head"), ast_to_node_instance(RNODE_WHEN(node)->nd_head));
    rb_ivar_set(obj, rb_intern("@body"), ast_to_node_instance(RNODE_WHEN(node)->nd_body));
    rb_ivar_set(obj, rb_intern("@next"), ast_to_node_instance(RNODE_WHEN(node)->nd_next));

    return obj;
}

VALUE
retry_node_new(const NODE *node)
{
    VALUE obj = rb_class_new_instance(0, 0, rb_cRetryNode);

    return obj;
}

VALUE
redo_node_new(const NODE *node)
{
    VALUE obj = rb_class_new_instance(0, 0, rb_cRedoNode);

    return obj;
}

VALUE
break_node_new(const NODE *node)
{
    VALUE obj = rb_class_new_instance(0, 0, rb_cBreakNode);

    rb_ivar_set(obj, rb_intern("@statements"),
                ast_to_node_instance(RNODE_BREAK(node)->nd_stts));

    return obj;
}

VALUE
next_node_new(const NODE *node)
{
    VALUE obj = rb_class_new_instance(0, 0, rb_cNextNode);

    rb_ivar_set(obj, rb_intern("@statements"),
                ast_to_node_instance(RNODE_NEXT(node)->nd_stts));

    return obj;
}

VALUE
defined_node_new(const NODE *node)
{
    VALUE obj = rb_class_new_instance(0, 0, rb_cDefinedNode);

    rb_ivar_set(obj, rb_intern("@head"),
                ast_to_node_instance(RNODE_DEFINED(node)->nd_head));

    return obj;
}

VALUE
iter_node_new(const NODE *node)
{
    VALUE obj = rb_class_new_instance(0, 0, rb_cIterNode);

    rb_ivar_set(obj, rb_intern("@body"), ast_to_node_instance(RNODE_ITER(node)->nd_body));
    rb_ivar_set(obj, rb_intern("@iter"), ast_to_node_instance(RNODE_ITER(node)->nd_iter));

    return obj;
}

VALUE
ensure_node_new(const NODE *node)
{
    VALUE obj = rb_class_new_instance(0, 0, rb_cEnsureNode);

    rb_ivar_set(obj, rb_intern("@head"), ast_to_node_instance(RNODE_ENSURE(node)->nd_head));
    rb_ivar_set(obj, rb_intern("@ensr"), ast_to_node_instance(RNODE_ENSURE(node)->nd_ensr));

    return obj;
}

VALUE
rescue_node_new(const NODE *node)
{
    VALUE obj = rb_class_new_instance(0, 0, rb_cRescueNode);

    rb_ivar_set(obj, rb_intern("@head"), ast_to_node_instance(RNODE_RESCUE(node)->nd_head));
    rb_ivar_set(obj, rb_intern("@resq"), ast_to_node_instance(RNODE_RESCUE(node)->nd_resq));
    rb_ivar_set(obj, rb_intern("@else"), ast_to_node_instance(RNODE_RESCUE(node)->nd_else));

    return obj;
}

VALUE
resbody_node_new(const NODE *node)
{
    VALUE obj = rb_class_new_instance(0, 0, rb_cRescueBodyNode);

    rb_ivar_set(obj, rb_intern("@args"), ast_to_node_instance(RNODE_RESBODY(node)->nd_args));
    rb_ivar_set(obj, rb_intern("@exc_var"), ast_to_node_instance(RNODE_RESBODY(node)->nd_exc_var));
    rb_ivar_set(obj, rb_intern("@body"), ast_to_node_instance(RNODE_RESBODY(node)->nd_body));
    rb_ivar_set(obj, rb_intern("@next"), ast_to_node_instance(RNODE_RESBODY(node)->nd_next));

    return obj;
}

VALUE
operator_assignment1_node_new(const NODE *node)
{
    VALUE obj = rb_class_new_instance(0, 0, rb_cOperatorAssignment1Node);

    rb_ivar_set(obj, rb_intern("@recv"), ast_to_node_instance(RNODE_OP_ASGN1(node)->nd_recv));
    rb_ivar_set(obj, rb_intern("@mid"), ID2SYM(RNODE_OP_ASGN1(node)->nd_mid));
    rb_ivar_set(obj, rb_intern("@index"), ast_to_node_instance(RNODE_OP_ASGN1(node)->nd_index));
    rb_ivar_set(obj, rb_intern("@rvalue"), ast_to_node_instance(RNODE_OP_ASGN1(node)->nd_rvalue));

    return obj;
}

VALUE
operator_assignment2_node_new(const NODE *node)
{
    VALUE obj = rb_class_new_instance(0, 0, rb_cOperatorAssignment2Node);

    rb_ivar_set(obj, rb_intern("@recv"), ast_to_node_instance(RNODE_OP_ASGN2(node)->nd_recv));
    rb_ivar_set(obj, rb_intern("@value"), ast_to_node_instance(RNODE_OP_ASGN2(node)->nd_value));
    rb_ivar_set(obj, rb_intern("@vid"), ID2SYM(RNODE_OP_ASGN2(node)->nd_vid));
    rb_ivar_set(obj, rb_intern("@mid"), ID2SYM(RNODE_OP_ASGN2(node)->nd_mid));

    return obj;
}

VALUE
operator_assignment_and_node_new(const NODE *node)
{
    VALUE obj = rb_class_new_instance(0, 0, rb_cOperatorAssignmentAndNode);

    rb_ivar_set(obj, rb_intern("@head"), ast_to_node_instance(RNODE_OP_ASGN_AND(node)->nd_head));
    rb_ivar_set(obj, rb_intern("@value"), ast_to_node_instance(RNODE_OP_ASGN_AND(node)->nd_value));

    return obj;
}

VALUE
operator_assignment_or_node_new(const NODE *node)
{
    VALUE obj = rb_class_new_instance(0, 0, rb_cOperatorAssignmentOrNode);

    rb_ivar_set(obj, rb_intern("@head"), ast_to_node_instance(RNODE_OP_ASGN_OR(node)->nd_head));
    rb_ivar_set(obj, rb_intern("@value"), ast_to_node_instance(RNODE_OP_ASGN_OR(node)->nd_value));

    return obj;
}

VALUE
operator_constant_declaration_node_new(const NODE *node)
{
    VALUE obj = rb_class_new_instance(0, 0, rb_cOperatorConstantDeclarationNode);

    rb_ivar_set(obj, rb_intern("@head"), ast_to_node_instance(RNODE_OP_CDECL(node)->nd_head));
    rb_ivar_set(obj, rb_intern("@value"), ast_to_node_instance(RNODE_OP_CDECL(node)->nd_value));
    rb_ivar_set(obj, rb_intern("@aid"), ID2SYM(RNODE_OP_CDECL(node)->nd_aid));
    rb_ivar_set(obj, rb_intern("@shareability"), INT2NUM(RNODE_OP_CDECL(node)->shareability));

    return obj;
}

VALUE
yield_node_new(const NODE *node)
{
    VALUE obj = rb_class_new_instance(0, 0, rb_cYieldNode);

    rb_ivar_set(obj, rb_intern("@head"), ast_to_node_instance(RNODE_YIELD(node)->nd_head));

    return obj;
}

VALUE
lambda_node_new(const NODE *node)
{
    VALUE obj = rb_class_new_instance(0, 0, rb_cLambdaNode);

    rb_ivar_set(obj, rb_intern("@body"), ast_to_node_instance(RNODE_LAMBDA(node)->nd_body));

    return obj;
}

VALUE
splat_node_new(const NODE *node)
{
    VALUE obj = rb_class_new_instance(0, 0, rb_cSplatNode);

    rb_ivar_set(obj, rb_intern("@head"), ast_to_node_instance(RNODE_SPLAT(node)->nd_head));

    return obj;
}

VALUE
block_pass_node_new(const NODE *node)
{
    VALUE obj = rb_class_new_instance(0, 0, rb_cBlockPassNode);

    rb_ivar_set(obj, rb_intern("@head"), ast_to_node_instance(RNODE_BLOCK_PASS(node)->nd_head));
    rb_ivar_set(obj, rb_intern("@body"), ast_to_node_instance(RNODE_BLOCK_PASS(node)->nd_body));
    rb_ivar_set(obj, rb_intern("@forwarding"), RNODE_BLOCK_PASS(node)->forwarding ? Qtrue : Qfalse);

    return obj;
}

VALUE
args_aux_node_new(const NODE *node)
{
    VALUE obj = rb_class_new_instance(0, 0, rb_cArgsAuxNode);

    rb_ivar_set(obj, rb_intern("@pid"), ID2SYM(RNODE_ARGS_AUX(node)->nd_pid));
    rb_ivar_set(obj, rb_intern("@plen"), INT2NUM(RNODE_ARGS_AUX(node)->nd_plen));
    rb_ivar_set(obj, rb_intern("@next"), ast_to_node_instance(RNODE_ARGS_AUX(node)->nd_next));

    return obj;
}

VALUE
opt_arg_node_new(const NODE *node)
{
    VALUE obj = rb_class_new_instance(0, 0, rb_cOptArgNode);

    rb_ivar_set(obj, rb_intern("@body"), ast_to_node_instance(RNODE_OPT_ARG(node)->nd_body));
    rb_ivar_set(obj, rb_intern("@next"), ast_to_node_instance((NODE *)RNODE_OPT_ARG(node)->nd_next));

    return obj;
}

VALUE
kw_arg_node_new(const NODE *node)
{
    VALUE obj = rb_class_new_instance(0, 0, rb_cKwArgNode);

    rb_ivar_set(obj, rb_intern("@body"), ast_to_node_instance(RNODE_KW_ARG(node)->nd_body));
    rb_ivar_set(obj, rb_intern("@next"), ast_to_node_instance((NODE *)RNODE_KW_ARG(node)->nd_next));

    return obj;
}

VALUE
post_arg_node_new(const NODE *node)
{
    VALUE obj = rb_class_new_instance(0, 0, rb_cPostArgNode);

    rb_ivar_set(obj, rb_intern("@first"), ast_to_node_instance(RNODE_POSTARG(node)->nd_1st));
    rb_ivar_set(obj, rb_intern("@second"), ast_to_node_instance(RNODE_POSTARG(node)->nd_2nd));

    return obj;
}

VALUE
args_cat_node_new(const NODE *node)
{
    VALUE obj = rb_class_new_instance(0, 0, rb_cArgsCatNode);

    rb_ivar_set(obj, rb_intern("@head"), ast_to_node_instance(RNODE_ARGSCAT(node)->nd_head));
    rb_ivar_set(obj, rb_intern("@body"), ast_to_node_instance(RNODE_ARGSCAT(node)->nd_body));

    return obj;
}

VALUE
args_push_node_new(const NODE *node)
{
    VALUE obj = rb_class_new_instance(0, 0, rb_cArgsPushNode);

    rb_ivar_set(obj, rb_intern("@head"), ast_to_node_instance(RNODE_ARGSPUSH(node)->nd_head));
    rb_ivar_set(obj, rb_intern("@body"), ast_to_node_instance(RNODE_ARGSPUSH(node)->nd_body));

    return obj;
}

VALUE
for_masgn_node_new(const NODE *node)
{
    VALUE obj = rb_class_new_instance(0, 0, rb_cForMasgnNode);

    rb_ivar_set(obj, rb_intern("@var"), ast_to_node_instance(RNODE_FOR_MASGN(node)->nd_var));

    return obj;
}

VALUE
masgn_node_new(const NODE *node)
{
    VALUE obj = rb_class_new_instance(0, 0, rb_cMasgnNode);

    rb_ivar_set(obj, rb_intern("@head"), ast_to_node_instance(RNODE_MASGN(node)->nd_head));
    rb_ivar_set(obj, rb_intern("@value"), ast_to_node_instance(RNODE_MASGN(node)->nd_value));
    rb_ivar_set(obj, rb_intern("@args"), ast_to_node_instance(RNODE_MASGN(node)->nd_args));

    return obj;
}

VALUE
dasgn_node_new(const NODE *node)
{
    VALUE obj = rb_class_new_instance(0, 0, rb_cDasgnNode);

    rb_ivar_set(obj, rb_intern("@vid"), ID2SYM(RNODE_DASGN(node)->nd_vid));
    rb_ivar_set(obj, rb_intern("@value"), ast_to_node_instance(RNODE_DASGN(node)->nd_value));

    return obj;
}

VALUE
once_node_new(const NODE *node)
{
    VALUE obj = rb_class_new_instance(0, 0, rb_cOnceNode);

    rb_ivar_set(obj, rb_intern("@body"), ast_to_node_instance(RNODE_ONCE(node)->nd_body));

    return obj;
}

VALUE
errinfo_node_new(const NODE *node)
{
    VALUE obj = rb_class_new_instance(0, 0, rb_cErrinfoNode);

    return obj;
}

VALUE
postexe_node_new(const NODE *node)
{
    VALUE obj = rb_class_new_instance(0, 0, rb_cPostexeNode);

    rb_ivar_set(obj, rb_intern("@body"), ast_to_node_instance(RNODE_POSTEXE(node)->nd_body));

    return obj;
}

VALUE
error_node_new(const NODE *node)
{
    VALUE obj = rb_class_new_instance(0, 0, rb_cErrorNode);

    return obj;
}

void
Init_StatementNode(VALUE module, VALUE base)
{
    rb_cIfStatementNode = rb_define_class_under(module, "IfStatementNode", base);

    rb_cUnlessStatementNode = rb_define_class_under(module, "UnlessStatementNode", base);

    rb_cOrNode = rb_define_class_under(module, "OrNode", base);

    rb_cAndNode = rb_define_class_under(module, "AndNode", base);

    rb_cWhileNode = rb_define_class_under(module, "WhileNode", base);

    rb_cUntilNode = rb_define_class_under(module, "UntilNode", base);

    rb_cForNode = rb_define_class_under(module, "ForNode", base);

    rb_cAliasNode = rb_define_class_under(module, "AliasNode", base);

    rb_cValiasNode = rb_define_class_under(module, "ValiasNode", base);

    rb_cUndefNode = rb_define_class_under(module, "UndefNode", base);

    rb_cReturnNode = rb_define_class_under(module, "ReturnNode", base);

    rb_cGlobalAssignmentNode = rb_define_class_under(module, "GlobalAssignmentNode", base);

    rb_cClassVariableAssignmentNode = rb_define_class_under(module, "ClassVariableAssignmentNode", base);

    rb_cInstanceAssignmentNode = rb_define_class_under(module, "InstanceAssignmentNode", base);

    rb_cLocalAssignmentNode = rb_define_class_under(module, "LocalAssignmentNode", base);

    rb_cSingletonDefinitionNode = rb_define_class_under(module, "SingletonDefinitionNode", base);

    rb_cSingletonClassNode = rb_define_class_under(module, "SingletonClassNode", base);

    rb_cAttributeAssignmentNode = rb_define_class_under(module, "AttributeAssignmentNode", base);

    rb_cSafeCallNode = rb_define_class_under(module, "SafeCallNode", base);

    rb_cSuperNode = rb_define_class_under(module, "SuperNode", base);

    rb_cZeroSuperNode = rb_define_class_under(module, "ZeroSuperNode", base);

    rb_cCaseNode = rb_define_class_under(module, "CaseNode", base);

    rb_cCase2Node = rb_define_class_under(module, "Case2Node", base);

    rb_cCase3Node = rb_define_class_under(module, "Case3Node", base);

    rb_cWhenNode = rb_define_class_under(module, "WhenNode", base);

    rb_cRetryNode = rb_define_class_under(module, "RetryNode", base);

    rb_cRedoNode = rb_define_class_under(module, "RedoNode", base);

    rb_cBreakNode = rb_define_class_under(module, "BreakNode", base);

    rb_cNextNode = rb_define_class_under(module, "NextNode", base);

    rb_cDefinedNode = rb_define_class_under(module, "DefinedNode", base);

    rb_cIterNode = rb_define_class_under(module, "IterNode", base);

    rb_cEnsureNode = rb_define_class_under(module, "EnsureNode", base);

    rb_cRescueNode = rb_define_class_under(module, "RescueNode", base);

    rb_cRescueBodyNode = rb_define_class_under(module, "RescueBodyNode", base);

    rb_cOperatorAssignment1Node = rb_define_class_under(module, "OperatorAssignment1Node", base);

    rb_cOperatorAssignment2Node = rb_define_class_under(module, "OperatorAssignment2Node", base);

    rb_cOperatorAssignmentAndNode = rb_define_class_under(module, "OperatorAssignmentAndNode", base);

    rb_cOperatorAssignmentOrNode = rb_define_class_under(module, "OperatorAssignmentOrNode", base);

    rb_cOperatorConstantDeclarationNode = rb_define_class_under(module, "OperatorConstantDeclarationNode", base);

    rb_cYieldNode = rb_define_class_under(module, "YieldNode", base);

    rb_cLambdaNode = rb_define_class_under(module, "LambdaNode", base);

    rb_cSplatNode = rb_define_class_under(module, "SplatNode", base);

    rb_cBlockPassNode = rb_define_class_under(module, "BlockPassNode", base);

    rb_cArgsAuxNode = rb_define_class_under(module, "ArgsAuxNode", base);

    rb_cOptArgNode = rb_define_class_under(module, "OptArgNode", base);

    rb_cKwArgNode = rb_define_class_under(module, "KwArgNode", base);

    rb_cPostArgNode = rb_define_class_under(module, "PostArgNode", base);

    rb_cArgsCatNode = rb_define_class_under(module, "ArgsCatNode", base);

    rb_cArgsPushNode = rb_define_class_under(module, "ArgsPushNode", base);

    rb_cForMasgnNode = rb_define_class_under(module, "ForMasgnNode", base);

    rb_cMasgnNode = rb_define_class_under(module, "MasgnNode", base);

    rb_cDasgnNode = rb_define_class_under(module, "DasgnNode", base);

    rb_cOnceNode = rb_define_class_under(module, "OnceNode", base);

    rb_cErrinfoNode = rb_define_class_under(module, "ErrinfoNode", base);

    rb_cPostexeNode = rb_define_class_under(module, "PostexeNode", base);

    rb_cErrorNode = rb_define_class_under(module, "ErrorNode", base);
}
