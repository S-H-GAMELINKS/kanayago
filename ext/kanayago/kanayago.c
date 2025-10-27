#include "kanayago.h"
#include "scope_node.h"
#include "literal_node.h"
#include "string_node.h"
#include "statement_node.h"
#include "variable_node.h"
#include "pattern_node.h"
#include "internal/encoding.h"
#include "internal/ruby_parser.h"
#include "rubyparser.h"

VALUE rb_mKanayago;

VALUE rb_cConstantNode;
VALUE rb_cConstantDeclarationNode;
VALUE rb_cDefinitionNode;
VALUE rb_cOperatorCallNode;
VALUE rb_cCallNode;
VALUE rb_cFunctionCallNode;
VALUE rb_cVariableCallNode;
VALUE rb_cArgumentsNode;
VALUE rb_cListNode;
VALUE rb_cBlockNode;
VALUE rb_cBeginNode;
VALUE rb_cClassNode;
VALUE rb_cModuleNode;
VALUE rb_cColon2Node;
VALUE rb_cColon3Node;
VALUE rb_cSelfNode;

static VALUE
operator_call_node_new(const NODE *node)
{
    VALUE obj = rb_class_new_instance(0, 0, rb_cOperatorCallNode);

    rb_ivar_set(obj, symbol("recv"), ast_to_node_instance(RNODE_OPCALL(node)->nd_recv));
    rb_ivar_set(obj, symbol("mid"), ID2SYM(RNODE_OPCALL(node)->nd_mid));
    rb_ivar_set(obj, symbol("args"), ast_to_node_instance(RNODE_OPCALL(node)->nd_args));

    return obj;
}

static VALUE
operator_call_node_recv_get(VALUE self)
{
    return rb_ivar_get(self, symbol("recv"));
}

static VALUE
operator_call_node_mid_get(VALUE self)
{
    return rb_ivar_get(self, symbol("mid"));
}

static VALUE
operator_call_node_args_get(VALUE self)
{
    return rb_ivar_get(self, symbol("args"));
}

static VALUE
call_node_new(const NODE *node)
{
    VALUE result = rb_class_new_instance(0, 0, rb_cCallNode);

    rb_ivar_set(result, symbol("recv"), ast_to_node_instance(RNODE_OPCALL(node)->nd_recv));
    rb_ivar_set(result, symbol("mid"), ID2SYM(RNODE_CALL(node)->nd_mid));
    rb_ivar_set(result, symbol("args"), ast_to_node_instance(RNODE_CALL(node)->nd_args));

    return result;
}

static VALUE
call_node_recv_get(VALUE self)
{
    return rb_ivar_get(self, symbol("recv"));
}

static VALUE
call_node_mid_get(VALUE self)
{
    return rb_ivar_get(self, symbol("mid"));
}

static VALUE
call_node_args_get(VALUE self)
{
    return rb_ivar_get(self, symbol("args"));
}

static VALUE
function_call_node_new(const NODE *node)
{
    VALUE obj = rb_class_new_instance(0, 0, rb_cFunctionCallNode);

    rb_ivar_set(obj, symbol("mid"), ID2SYM(RNODE_FCALL(node)->nd_mid));
    rb_ivar_set(obj, symbol("args"), ast_to_node_instance(RNODE_FCALL(node)->nd_args));

    return obj;
}

static VALUE
function_call_node_mid_get(VALUE self)
{
    return rb_ivar_get(self, symbol("mid"));
}

static VALUE
function_call_node_args_get(VALUE self)
{
    return rb_ivar_get(self, symbol("args"));
}

static VALUE
variable_call_node_new(const NODE *node)
{
    VALUE obj = rb_class_new_instance(0, 0, rb_cVariableCallNode);

    rb_ivar_set(obj, rb_intern("@mid"), ID2SYM(RNODE_VCALL(node)->nd_mid));

    return obj;
}

static VALUE
variable_call_node_mid_get(VALUE self)
{
    return rb_ivar_get(self, rb_intern("@mid"));
}

static VALUE
list_node_new(const NODE *node)
{
    VALUE obj = rb_class_new_instance(0, 0, rb_cListNode);
    VALUE val = rb_ary_new();
    const NODE *nd_current = node;
    int list_len = RNODE_LIST(node)->as.nd_alen;

    while (nd_current) {
        rb_ary_push(val, ast_to_node_instance(RNODE_LIST(nd_current)->nd_head));
        nd_current = RNODE_LIST(nd_current)->nd_next;
    }

    rb_ivar_set(obj, rb_intern("@val"), val);
    rb_ivar_set(obj, rb_intern("@len"), INT2FIX(list_len));

    return obj;
}

static VALUE
definition_node_new(const NODE *node)
{
    VALUE obj = rb_class_new_instance(0, 0, rb_cDefinitionNode);

    rb_ivar_set(obj, symbol("mid"), ID2SYM(RNODE_DEFN(node)->nd_mid));
    rb_ivar_set(obj, symbol("defn"), ast_to_node_instance(RNODE_DEFN(node)->nd_defn));

    return obj;
}

static VALUE
definition_node_mid_get(VALUE self)
{
    return rb_ivar_get(self, symbol("mid"));
}

static VALUE
definition_node_defn_get(VALUE self)
{
    return rb_ivar_get(self, symbol("defn"));
}

static VALUE
block_node_new(const NODE *node)
{
    VALUE obj = rb_class_new_instance(0, 0, rb_cBlockNode);
    const NODE *current_node = node;

    while (current_node) {
        rb_ary_push(obj, ast_to_node_instance(RNODE_BLOCK(current_node)->nd_head));
        current_node = RNODE_BLOCK(current_node)->nd_next;
    }

    return obj;
}

static VALUE
constant_node_new(const NODE *node)
{
    VALUE obj = rb_class_new_instance(0, 0, rb_cConstantNode);

    rb_ivar_set(obj, symbol("vid"), ID2SYM(RNODE_CONST(node)->nd_vid));

    return obj;
}

static VALUE
constant_node_vid_get(VALUE self)
{
    return rb_ivar_get(self, symbol("vid"));
}

static VALUE
constant_declaration_node_new(const NODE *node)
{
    VALUE obj = rb_class_new_instance(0, 0, rb_cConstantDeclarationNode);

    rb_ivar_set(obj, symbol("vid"), ID2SYM(RNODE_CDECL(node)->nd_vid));
    rb_ivar_set(obj, symbol("else"), ast_to_node_instance(RNODE_CDECL(node)->nd_else));
    rb_ivar_set(obj, symbol("value"), ast_to_node_instance(RNODE_CDECL(node)->nd_value));

    return obj;
}

static VALUE
constant_declaration_node_vid_get(VALUE self)
{
    return rb_ivar_get(self, symbol("vid"));
}

static VALUE
constant_declaration_node_else_get(VALUE self)
{
    return rb_ivar_get(self, symbol("else"));
}

static VALUE
constant_declaration_node_value_get(VALUE self)
{
    return rb_ivar_get(self, symbol("value"));
}

static VALUE
node_literal_to_hash(const NODE *node)
{
    enum node_type type = nd_type(node);

    switch (type) {
	case NODE_INTEGER:
	  return integer_node_new(node);
	case NODE_FLOAT:
	  return float_node_new(node);
	case NODE_RATIONAL:
	  return rational_node_new(node);
	case NODE_IMAGINARY:
	  return imaginary_node_new(node);
	case NODE_STR:
	  return string_node_new(node);
	case NODE_SYM:
	  return symbol_node_new(node);
	case NODE_ZLIST:
	  return zero_list_node_new(node);
	case NODE_FILE:
	  return file_node_new(node);
	case NODE_LINE:
	  return line_node_new(node);
	case NODE_ENCODING:
	  return encoding_node_new(node);
	case NODE_NIL:
	  return nil_node_new(node);
	case NODE_TRUE:
	  return true_node_new(node);
	case NODE_FALSE:
	  return false_node_new(node);
	default:
	  return Qnil;
    }
}

static VALUE
class_node_new(const NODE *node)
{
    VALUE obj = rb_class_new_instance(0, 0, rb_cClassNode);

    rb_ivar_set(obj, symbol("cpath"), ast_to_node_instance(RNODE_CLASS(node)->nd_cpath));
    rb_ivar_set(obj, symbol("super"), ast_to_node_instance(RNODE_CLASS(node)->nd_super));
    rb_ivar_set(obj, symbol("body"), ast_to_node_instance(RNODE_CLASS(node)->nd_body));

    return obj;
}

static VALUE
class_node_cpath_get(VALUE self)
{
    return rb_ivar_get(self, symbol("cpath"));
}

static VALUE
class_node_super_get(VALUE self)
{
    return rb_ivar_get(self, symbol("super"));
}

static VALUE
class_node_body_get(VALUE self)
{
    return rb_ivar_get(self, symbol("body"));
}

static VALUE
module_node_new(const NODE *node)
{
    VALUE obj = rb_class_new_instance(0, 0, rb_cModuleNode);

    rb_ivar_set(obj, rb_intern("@cpath"), ast_to_node_instance(RNODE_CLASS(node)->nd_cpath));
    rb_ivar_set(obj, rb_intern("@super"), ast_to_node_instance(RNODE_CLASS(node)->nd_super));
    rb_ivar_set(obj, rb_intern("@body"), ast_to_node_instance(RNODE_CLASS(node)->nd_body));

    return obj;
}

static VALUE
colon2_node_new(const NODE *node)
{
    VALUE obj = rb_class_new_instance(0, 0, rb_cColon2Node);

    rb_ivar_set(obj, symbol("mid"), ID2SYM(RNODE_COLON2(node)->nd_mid));
    rb_ivar_set(obj, symbol("head"), ast_to_node_instance(RNODE_COLON2(node)->nd_head));

    return obj;
}

static VALUE
colon2_node_mid_get(VALUE self)
{
    return rb_ivar_get(self, symbol("mid"));
}

static VALUE
colon2_node_head_get(VALUE self)
{
    return rb_ivar_get(self, symbol("head"));
}

static VALUE
colon3_node_new(const NODE *node)
{
    VALUE obj = rb_class_new_instance(0, 0, rb_cColon3Node);

    rb_ivar_set(obj, rb_intern("@mid"), ID2SYM(RNODE_COLON3(node)->nd_mid));

    return obj;
}

static VALUE
colon3_node_mid_get(VALUE self)
{
    return rb_ivar_get(self, rb_intern("@mid"));
}

static VALUE
begin_node_new(const NODE *node)
{
    VALUE obj = rb_class_new_instance(0, 0, rb_cBeginNode);

    rb_ivar_set(obj, symbol("body"), ast_to_node_instance(RNODE_BEGIN(node)->nd_body));

    return obj;
}

static VALUE
begin_node_body_get(VALUE self)
{
    return rb_ivar_get(self, symbol("body"));
}

static VALUE
args_ainfo_to_hash(const struct rb_args_info ainfo)
{
    VALUE result = rb_hash_new();

    rb_hash_aset(result, symbol("forwarding"), INT2NUM(ainfo.forwarding));
    rb_hash_aset(result, symbol("pre_args_num"), INT2NUM(ainfo.pre_args_num));
    rb_hash_aset(result, symbol("pre_init"), ast_to_node_instance(ainfo.pre_init));
    rb_hash_aset(result, symbol("post_args_num"), INT2NUM(ainfo.post_args_num));
    rb_hash_aset(result, symbol("post_init"), ast_to_node_instance(ainfo.post_init));

    rb_hash_aset(result, symbol("first_post_arg"), ainfo.first_post_arg ? ID2SYM(ainfo.first_post_arg) : Qnil);
    rb_hash_aset(result, symbol("rest_arg"), ainfo.rest_arg ? ID2SYM(ainfo.rest_arg) : Qnil);
    rb_hash_aset(result, symbol("block_arg"), ainfo.block_arg ? ID2SYM(ainfo.block_arg) : Qnil);

    rb_hash_aset(result, symbol("opt_args"), ast_to_node_instance((const NODE *)(ainfo.opt_args)));
    rb_hash_aset(result, symbol("kw_args"), ast_to_node_instance((const NODE *)(ainfo.kw_args)));
    rb_hash_aset(result, symbol("kw_rest_arg"), ast_to_node_instance(ainfo.kw_rest_arg));

    return result;
}

static VALUE
arguments_node_new(const NODE *node)
{
    VALUE obj = rb_class_new_instance(0, 0, rb_cArgumentsNode);
    VALUE ainfo_hash = args_ainfo_to_hash(RNODE_ARGS(node)->nd_ainfo);

    rb_ivar_set(obj, symbol("ainfo"), ainfo_hash);

    return obj;
}

static VALUE
arguments_node_ainfo_get(VALUE self)
{
    return rb_ivar_get(self, symbol("ainfo"));
}

static VALUE
self_node_new(const NODE *node)
{
    VALUE obj = rb_class_new_instance(0, 0, rb_cSelfNode);

    rb_ivar_set(obj, rb_intern("@state"), LONG2FIX(RNODE_SELF(node)->nd_state));

    return obj;
}

VALUE
ast_to_node_instance(const NODE *node)
{
    enum node_type type;

    if (!node) {
        return Qnil;
    }

    if (node == (NODE *)-1) {
        return Qnil;
    }

    type = nd_type(node);

    switch (type) {
	case NODE_SCOPE:
	  return scope_node_new(node);
	case NODE_CLASS:
	  return class_node_new(node);
	case NODE_MODULE:
	  return module_node_new(node);
	case NODE_DEFN:
	  return definition_node_new(node);
	case NODE_DEFS:
	  return singleton_definition_node_new(node);
	case NODE_SCLASS:
	  return singleton_class_node_new(node);
	case NODE_ATTRASGN:
	  return attribute_assignment_node_new(node);
	case NODE_QCALL:
	  return safe_call_node_new(node);
	case NODE_SUPER:
	  return super_node_new(node);
	case NODE_ZSUPER:
	  return zero_super_node_new(node);
	case NODE_OPCALL:
	  return operator_call_node_new(node);
	case NODE_FCALL:
	  return function_call_node_new(node);
	case NODE_VCALL:
	  return variable_call_node_new(node);
	case NODE_CALL:
	  return call_node_new(node);
	case NODE_ARGS:
	  return arguments_node_new(node);
	case NODE_BLOCK:
	  return block_node_new(node);
	case NODE_LASGN:
	  return local_assignment_node_new(node);
	case NODE_IASGN:
	  return instance_assignment_node_new(node);
	case NODE_CVASGN:
	  return class_variable_assignment_node_new(node);
	case NODE_GASGN:
	  return global_assignment_node_new(node);
	case NODE_LVAR:
	  return local_variable_node_new(node);
	case NODE_DVAR:
	  return dynamic_variable_node_new(node);
	case NODE_IF:
	  return if_statement_node_new(node);
	case NODE_UNLESS:
	  return unless_statement_node_new(node);
	case NODE_WHILE:
	  return while_node_new(node);
	case NODE_UNTIL:
	  return until_node_new(node);
	case NODE_CASE:
	  return case_node_new(node);
	case NODE_CASE2:
	  return case2_node_new(node);
	case NODE_CASE3:
	  return case3_node_new(node);
	case NODE_WHEN:
	  return when_node_new(node);
	case NODE_ITER:
	  return iter_node_new(node);
	case NODE_FOR:
	  return for_node_new(node);
	case NODE_ALIAS:
	  return alias_node_new(node);
	case NODE_VALIAS:
	  return valias_node_new(node);
	case NODE_UNDEF:
	  return undef_node_new(node);
	case NODE_RETURN:
	  return return_node_new(node);
	case NODE_RETRY:
	  return retry_node_new(node);
	case NODE_REDO:
	  return redo_node_new(node);
	case NODE_BREAK:
	  return break_node_new(node);
	case NODE_NEXT:
	  return next_node_new(node);
	case NODE_DEFINED:
	  return defined_node_new(node);
	case NODE_OR:
	  return or_node_new(node);
	case NODE_AND:
	  return and_node_new(node);
	case NODE_LIST:
	  return list_node_new(node);
	case NODE_HASH:
	  return hash_node_new(node);
	case NODE_CONST:
	  return constant_node_new(node);
	case NODE_CDECL:
	  return constant_declaration_node_new(node);
	case NODE_COLON2:
	  return colon2_node_new(node);
	case NODE_COLON3:
	  return colon3_node_new(node);
	case NODE_BEGIN:
	  return begin_node_new(node);
	case NODE_RESCUE:
	  return rescue_node_new(node);
	case NODE_RESBODY:
	  return resbody_node_new(node);
	case NODE_ENSURE:
	  return ensure_node_new(node);
	case NODE_IVAR:
	  return instance_variable_node_new(node);
	case NODE_CVAR:
	  return class_variable_node_new(node);
	case NODE_GVAR:
	  return global_variable_node_new(node);
	case NODE_NTH_REF:
	  return nth_ref_node_new(node);
	case NODE_BACK_REF:
	  return back_ref_node_new(node);
	case NODE_OP_ASGN1:
	  return operator_assignment1_node_new(node);
	case NODE_OP_ASGN2:
	  return operator_assignment2_node_new(node);
	case NODE_OP_ASGN_AND:
	  return operator_assignment_and_node_new(node);
	case NODE_OP_ASGN_OR:
	  return operator_assignment_or_node_new(node);
	case NODE_OP_CDECL:
	  return operator_constant_declaration_node_new(node);
	case NODE_YIELD:
	  return yield_node_new(node);
	case NODE_LAMBDA:
	  return lambda_node_new(node);
	case NODE_SPLAT:
	  return splat_node_new(node);
	case NODE_BLOCK_PASS:
	  return block_pass_node_new(node);
	case NODE_ARGS_AUX:
	  return args_aux_node_new(node);
	case NODE_OPT_ARG:
	  return opt_arg_node_new(node);
	case NODE_KW_ARG:
	  return kw_arg_node_new(node);
	case NODE_POSTARG:
	  return post_arg_node_new(node);
	case NODE_ARGSCAT:
	  return args_cat_node_new(node);
	case NODE_ARGSPUSH:
	  return args_push_node_new(node);
	case NODE_FOR_MASGN:
	  return for_masgn_node_new(node);
	case NODE_MASGN:
	  return masgn_node_new(node);
	case NODE_DASGN:
	  return dasgn_node_new(node);
	case NODE_ONCE:
	  return once_node_new(node);
	case NODE_ERRINFO:
	  return errinfo_node_new(node);
	case NODE_POSTEXE:
	  return postexe_node_new(node);
	case NODE_ERROR:
	  return error_node_new(node);
	case NODE_SELF:
	  return self_node_new(node);
	case NODE_DOT2:
	  return range_node_new(node);
	case NODE_DOT3:
	  return exclusive_range_node_new(node);
	case NODE_FLIP2:
	  return flip_flop_node_new(node);
	case NODE_FLIP3:
	  return exclusive_flip_flop_node_new(node);
	case NODE_DSTR:
	  return dynamic_string_node_new(node);
	case NODE_DSYM:
	  return dynamic_symbol_node_new(node);
	case NODE_XSTR:
	  return execute_string_node_new(node);
	case NODE_DXSTR:
	  return dynamic_execute_string_node_new(node);
	case NODE_REGX:
	  return regexp_node_new(node);
	case NODE_DREGX:
	  return dynamic_regexp_node_new(node);
	case NODE_MATCH:
	  return match_node_new(node);
	case NODE_MATCH2:
	  return match2_node_new(node);
	case NODE_MATCH3:
	  return match3_node_new(node);
	case NODE_IN:
	  return in_node_new(node);
	case NODE_ARYPTN:
	  return array_pattern_node_new(node);
	case NODE_HSHPTN:
	  return hash_pattern_node_new(node);
	case NODE_FNDPTN:
	  return find_pattern_node_new(node);
	case NODE_EVSTR:
	  return embedded_expression_string_node_new(node);
	case NODE_INTEGER:
	case NODE_FLOAT:
	case NODE_RATIONAL:
	case NODE_IMAGINARY:
	case NODE_STR:
	case NODE_SYM:
	case NODE_ZLIST:
	case NODE_FILE:
	case NODE_LINE:
	case NODE_ENCODING:
	case NODE_NIL:
	case NODE_TRUE:
	case NODE_FALSE:
	  return node_literal_to_hash(node);
	default:
	  return Qfalse;
    }
}

static VALUE
kanayago_parse(VALUE self, VALUE source)
{
    struct ruby_parser *parser;
    rb_parser_t *parser_params;

    parser_params = rb_parser_params_new();
    VALUE vparser = TypedData_Make_Struct(0, struct ruby_parser,
                                         &ruby_parser_data_type, parser);
    parser->parser_params = parser_params;


    VALUE vast = rb_parser_compile_string(vparser, "main", source, 0);

    rb_ast_t *ast = rb_ruby_ast_data_get(vast);

    return ast_to_node_instance(ast->body.root);
}

RUBY_FUNC_EXPORTED void
Init_kanayago(void)
{
    rb_mKanayago = rb_define_module("Kanayago");
    rb_define_module_function(rb_mKanayago, "kanayago_parse", kanayago_parse, 1);

    // For Kanayago::ScopeNode
    Init_ScopeNode(rb_mKanayago);

    // For Literal Node(e.g. Kanayago::IntegerNode)
    Init_LiteralNode(rb_mKanayago);

    // For String Node(e.g. Kanayago::DynamicStringNode)
    Init_StringNode(rb_mKanayago);

    rb_cConstantNode = rb_define_class_under(rb_mKanayago, "ConstantNode", rb_cObject);
    rb_define_method(rb_cConstantNode, "vid", constant_node_vid_get, 0);

    rb_cConstantDeclarationNode = rb_define_class_under(rb_mKanayago, "ConstantDeclarationNode", rb_cObject);
    rb_define_method(rb_cConstantDeclarationNode, "vid", constant_declaration_node_vid_get, 0);
    rb_define_method(rb_cConstantDeclarationNode, "else", constant_declaration_node_else_get, 0);
    rb_define_method(rb_cConstantDeclarationNode, "value", constant_declaration_node_value_get, 0);

    rb_cDefinitionNode = rb_define_class_under(rb_mKanayago, "DefinitionNode", rb_cObject);
    rb_define_method(rb_cDefinitionNode, "mid", definition_node_mid_get, 0);
    rb_define_method(rb_cDefinitionNode, "defn", definition_node_defn_get, 0);

    rb_cOperatorCallNode = rb_define_class_under(rb_mKanayago, "OperatorCallNode", rb_cObject);
    rb_define_method(rb_cOperatorCallNode, "recv", operator_call_node_recv_get, 0);
    rb_define_method(rb_cOperatorCallNode, "mid", operator_call_node_mid_get, 0);
    rb_define_method(rb_cOperatorCallNode, "args", operator_call_node_args_get, 0);

    rb_cListNode = rb_define_class_under(rb_mKanayago, "ListNode", rb_cObject);

    rb_cArgumentsNode = rb_define_class_under(rb_mKanayago, "ArgumentsNode", rb_cObject);
    rb_define_method(rb_cArgumentsNode, "ainfo", arguments_node_ainfo_get, 0);

    rb_cCallNode = rb_define_class_under(rb_mKanayago, "CallNode", rb_cObject);
    rb_define_method(rb_cCallNode, "recv", call_node_recv_get, 0);
    rb_define_method(rb_cCallNode, "mid", call_node_mid_get, 0);
    rb_define_method(rb_cCallNode, "args", call_node_args_get, 0);

    rb_cFunctionCallNode = rb_define_class_under(rb_mKanayago, "FunctionCallNode", rb_cObject);
    rb_define_method(rb_cFunctionCallNode, "mid", function_call_node_mid_get, 0);
    rb_define_method(rb_cFunctionCallNode, "args", function_call_node_args_get, 0);

    rb_cVariableCallNode = rb_define_class_under(rb_mKanayago, "VariableCallNode", rb_cObject);
    rb_define_method(rb_cVariableCallNode, "mid", variable_call_node_mid_get, 0);

    // For Statement Node(e.g. Kanayago::IfStatementNode)
    Init_StatementNode(rb_mKanayago);

    rb_cBlockNode = rb_define_class_under(rb_mKanayago, "BlockNode", rb_cArray);

    rb_cBeginNode = rb_define_class_under(rb_mKanayago, "BeginNode", rb_cObject);
    rb_define_method(rb_cBeginNode, "body", begin_node_body_get, 0);

    rb_cClassNode = rb_define_class_under(rb_mKanayago, "ClassNode", rb_cObject);
    rb_define_method(rb_cClassNode, "cpath", class_node_cpath_get, 0);
    rb_define_method(rb_cClassNode, "super", class_node_super_get, 0);
    rb_define_method(rb_cClassNode, "body", class_node_body_get, 0);

    rb_cModuleNode = rb_define_class_under(rb_mKanayago, "ModuleNode", rb_cObject);

    rb_cColon2Node = rb_define_class_under(rb_mKanayago, "Colon2Node", rb_cObject);
    rb_define_method(rb_cColon2Node, "mid", colon2_node_mid_get, 0);
    rb_define_method(rb_cColon2Node, "head", colon2_node_head_get, 0);

    rb_cColon3Node = rb_define_class_under(rb_mKanayago, "Colon3Node", rb_cObject);
    rb_define_method(rb_cColon3Node, "mid", colon3_node_mid_get, 0);

    // For Variable Node(e.g. Kanayago::LocalVariableNode)
    Init_VariableNode(rb_mKanayago);

    // For Pattern Node(e.g. Kanayago::InNode)
    Init_PatternNode(rb_mKanayago);

    rb_cSelfNode = rb_define_class_under(rb_mKanayago, "SelfNode", rb_cObject);
}
