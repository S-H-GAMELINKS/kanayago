#include "internal/ruby_parser.h"
#include "kanayago.h"
#include "internal/encoding.h"
#include "rubyparser.h"

VALUE rb_cIntegerNode;
VALUE rb_cFloatNode;
VALUE rb_cRationalNode;
VALUE rb_cImaginaryNode;
VALUE rb_cStringNode;
VALUE rb_cSymbolNode;
VALUE rb_cZeroListNode;
VALUE rb_cFileNode;
VALUE rb_cLineNode;
VALUE rb_cEncodingNode;

VALUE
integer_node_new(const NODE *node)
{
    VALUE result = rb_class_new_instance(0, 0, rb_cIntegerNode);

    rb_ivar_set(result, rb_intern("@val"), rb_node_integer_literal_val(node));
    rb_ivar_set(result, rb_intern("@minus"), RNODE_INTEGER(node)->minus == TRUE ? Qtrue : Qfalse);
    rb_ivar_set(result, rb_intern("@base"), INT2FIX(RNODE_INTEGER(node)->base));

    return result;
}

VALUE
float_node_new(const NODE *node)
{
    VALUE result = rb_class_new_instance(0, 0, rb_cFloatNode);

    rb_ivar_set(result, rb_intern("@val"), rb_node_float_literal_val(node));
    rb_ivar_set(result, rb_intern("@minus"), RNODE_FLOAT(node)->minus == TRUE ? Qtrue : Qfalse);

    return result;
}

VALUE
rational_node_new(const NODE *node)
{
    VALUE obj = rb_class_new_instance(0, 0, rb_cRationalNode);

    rb_ivar_set(obj, rb_intern("@val"), rb_node_rational_literal_val(node));
    rb_ivar_set(obj, rb_intern("@minus"), RNODE_RATIONAL(node)->minus == TRUE ? Qtrue : Qfalse);
    rb_ivar_set(obj, rb_intern("@base"), INT2FIX(RNODE_RATIONAL(node)->base));
    rb_ivar_set(obj, rb_intern("@seen_point"), INT2FIX(RNODE_RATIONAL(node)->seen_point));

    return obj;
}

static VALUE
parser_string_coderange_type_to_str(enum rb_parser_string_coderange_type coderange)
{
    switch (coderange) {
      case RB_PARSER_ENC_CODERANGE_UNKNOWN:
        return rb_str_new_cstr("RB_PARSER_ENC_CODERANGE_UNKNOWN");
      case RB_PARSER_ENC_CODERANGE_7BIT:
	return rb_str_new_cstr("RB_PARSER_ENC_CODERANGE_7BIT");
      case RB_PARSER_ENC_CODERANGE_VALID:
	return rb_str_new_cstr("RB_PARSER_ENC_CODERANGE_VALID");
      case RB_PARSER_ENC_CODERANGE_BROKEN:
	return rb_str_new_cstr("RB_PARSER_ENC_CODERANGE_BROKEN");
    }
    return Qnil;
}

static VALUE
numeric_type_to_str(enum rb_numeric_type type)
{
    switch (type) {
      case integer_literal:
        return rb_str_new_cstr("integer_literal");
      case float_literal:
	return rb_str_new_cstr("float_literal");
      case rational_literal:
	return rb_str_new_cstr("rational_literal");
    }
    return Qnil;
}

VALUE
imaginary_node_new(const NODE *node)
{
    VALUE obj = rb_class_new_instance(0, 0, rb_cImaginaryNode);
    enum rb_numeric_type type = RNODE_IMAGINARY(node)->type;

    rb_ivar_set(obj, rb_intern("@val"), rb_node_imaginary_literal_val(node));
    rb_ivar_set(obj, rb_intern("@minus"), RNODE_IMAGINARY(node)->minus == TRUE ? Qtrue : Qfalse);
    rb_ivar_set(obj, rb_intern("@base"), INT2FIX(RNODE_IMAGINARY(node)->base));
    rb_ivar_set(obj, rb_intern("@seen_point"), INT2FIX(RNODE_IMAGINARY(node)->seen_point));
    rb_ivar_set(obj, rb_intern("@type"), numeric_type_to_str(type));

    return obj;
}

VALUE
string_node_new(const NODE *node)
{
    VALUE result = rb_class_new_instance(0, 0, rb_cStringNode);
    rb_parser_string_t *str = RNODE_STR(node)->string;
    rb_encoding *enc = str->enc;
    char *ptr = str->ptr;
    long len = str->len;
    enum rb_parser_string_coderange_type conderange = str->coderange;

    rb_ivar_set(result, rb_intern("@ptr"), rb_enc_str_new(ptr, len, enc));
    rb_ivar_set(result, rb_intern("@len"), LONG2FIX(len));
    rb_ivar_set(result, rb_intern("@enc"), rb_enc_from_encoding(enc));
    rb_ivar_set(result, rb_intern("@coderange"), parser_string_coderange_type_to_str(conderange));

    return result;
}

VALUE
symbol_node_new(const NODE *node)
{
    VALUE obj = rb_class_new_instance(0, 0, rb_cSymbolNode);

    rb_parser_string_t *str = RNODE_SYM(node)->string;
    rb_encoding *enc = str->enc;
    char *ptr = str->ptr;
    long len = str->len;
    enum rb_parser_string_coderange_type conderange = str->coderange;

    rb_ivar_set(obj, rb_intern("@ptr"), rb_enc_str_new(ptr, len, enc));
    rb_ivar_set(obj, rb_intern("@len"), LONG2FIX(len));
    rb_ivar_set(obj, rb_intern("@enc"), rb_enc_from_encoding(enc));
    rb_ivar_set(obj, rb_intern("@coderange"), parser_string_coderange_type_to_str(conderange));

    return obj;
}

VALUE
zero_list_node_new(const NODE *node)
{
    VALUE obj = rb_class_new_instance(0, 0, rb_cZeroListNode);

    rb_ivar_set(obj, rb_intern("@len"), INT2FIX(0));
    rb_ivar_set(obj, rb_intern("@val"), rb_ary_new());

    return obj;
}

VALUE
file_node_new(const NODE *node)
{
    VALUE obj = rb_class_new_instance(0, 0, rb_cFileNode);

    rb_parser_string_t *str = RNODE_FILE(node)->path;
    rb_encoding *enc = str->enc;
    char *ptr = str->ptr;
    long len = str->len;
    enum rb_parser_string_coderange_type conderange = str->coderange;

    rb_ivar_set(obj, rb_intern("@ptr"), rb_enc_str_new(ptr, len, enc));
    rb_ivar_set(obj, rb_intern("@len"), LONG2FIX(len));
    rb_ivar_set(obj, rb_intern("@enc"), rb_enc_from_encoding(enc));
    rb_ivar_set(obj, rb_intern("@coderange"), parser_string_coderange_type_to_str(conderange));

    return obj;
}

VALUE
line_node_new(const NODE *node)
{
    VALUE obj = rb_class_new_instance(0, 0, rb_cLineNode);

    rb_ivar_set(obj, rb_intern("@lineno"), INT2FIX(node->nd_loc.beg_pos.lineno));

    return obj;
}

VALUE
encoding_node_new(const NODE *node)
{
    VALUE obj = rb_class_new_instance(0, 0, rb_cEncodingNode);

    rb_ivar_set(obj, rb_intern("@val"), rb_enc_from_encoding(RNODE_ENCODING(node)->enc));

    return obj;
}

void
Init_LiteralNode(VALUE module)
{
    rb_cIntegerNode = rb_define_class_under(module, "IntegerNode", rb_cObject);

    rb_cFloatNode = rb_define_class_under(module, "FloatNode", rb_cObject);

    rb_cRationalNode = rb_define_class_under(module, "RationalNode", rb_cObject);

    rb_cImaginaryNode = rb_define_class_under(module, "ImaginaryNode", rb_cObject);

    rb_cStringNode = rb_define_class_under(module, "StringNode", rb_cObject);

    rb_cSymbolNode = rb_define_class_under(module, "SymbolNode", rb_cObject);

    rb_cZeroListNode = rb_define_class_under(module, "ZeroListNode", rb_cObject);

    rb_cFileNode = rb_define_class_under(module, "FileNode", rb_cObject);

    rb_cLineNode = rb_define_class_under(module, "LineNode", rb_cObject);

    rb_cEncodingNode = rb_define_class_under(module, "EncodingNode", rb_cObject);
}
