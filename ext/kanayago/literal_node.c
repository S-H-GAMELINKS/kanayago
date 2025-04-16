#include "internal/ruby_parser.h"
#include "kanayago.h"
#include "internal/encoding.h"

VALUE rb_cIntegerNode;
VALUE rb_cFloatNode;
VALUE rb_cRationalNode;
VALUE rb_cImaginaryNode;
VALUE rb_cStringNode;
VALUE rb_cSymbolNode;
VALUE rb_cFileNode;

VALUE
integer_node_new(const NODE *node)
{
    VALUE result = rb_class_new_instance(0, 0, rb_cIntegerNode);

    rb_ivar_set(result, symbol("val"), rb_node_integer_literal_val(node));
    rb_ivar_set(result, symbol("minus"), RNODE_INTEGER(node)->minus == TRUE ? Qtrue : Qfalse);
    rb_ivar_set(result, symbol("base"), INT2FIX(RNODE_INTEGER(node)->base));

    return result;
}

static VALUE
integer_node_val_get(VALUE self)
{
    return rb_ivar_get(self, symbol("val"));
}

static VALUE
integer_node_minus_get(VALUE self)
{
    return rb_ivar_get(self, symbol("minus"));
}

static VALUE
integer_node_base_get(VALUE self)
{
    return rb_ivar_get(self, symbol("base"));
}

VALUE
float_node_new(const NODE *node)
{
    VALUE result = rb_class_new_instance(0, 0, rb_cFloatNode);

    rb_ivar_set(result, symbol("val"), rb_node_float_literal_val(node));
    rb_ivar_set(result, symbol("minus"), RNODE_FLOAT(node)->minus == TRUE ? Qtrue : Qfalse);

    return result;
}

static VALUE
float_node_val_get(VALUE self)
{
    return rb_ivar_get(self, symbol("val"));
}

static VALUE
float_node_minus_get(VALUE self)
{
    return rb_ivar_get(self, symbol("minus"));
}

VALUE
rational_node_new(const NODE *node)
{
    VALUE obj = rb_class_new_instance(0, 0, rb_cRationalNode);

    rb_ivar_set(obj, symbol("val"), rb_node_rational_literal_val(node));
    rb_ivar_set(obj, symbol("minus"), RNODE_RATIONAL(node)->minus == TRUE ? Qtrue : Qfalse);
    rb_ivar_set(obj, symbol("base"), INT2FIX(RNODE_RATIONAL(node)->base));
    rb_ivar_set(obj, symbol("seen_point"), INT2FIX(RNODE_RATIONAL(node)->seen_point));

    return obj;
}

static VALUE
rational_node_val_get(VALUE self)
{
    return rb_ivar_get(self, symbol("val"));
}

static VALUE
rational_node_minus_get(VALUE self)
{
    return rb_ivar_get(self, symbol("minus"));
}

static VALUE
rational_node_base_get(VALUE self)
{
    return rb_ivar_get(self, symbol("base"));
}

static VALUE
rational_node_seen_point_get(VALUE self)
{
    return rb_ivar_get(self, symbol("seen_point"));
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

    rb_ivar_set(obj, symbol("val"), rb_node_imaginary_literal_val(node));
    rb_ivar_set(obj, symbol("minus"), RNODE_IMAGINARY(node)->minus == TRUE ? Qtrue : Qfalse);
    rb_ivar_set(obj, symbol("base"), INT2FIX(RNODE_IMAGINARY(node)->base));
    rb_ivar_set(obj, symbol("seen_point"), INT2FIX(RNODE_IMAGINARY(node)->seen_point));
    rb_ivar_set(obj, symbol("type"), numeric_type_to_str(type));

    return obj;
}

static VALUE
imaginary_node_val_get(VALUE self)
{
    return rb_ivar_get(self, symbol("val"));
}

static VALUE
imaginary_node_minus_get(VALUE self)
{
    return rb_ivar_get(self, symbol("minus"));
}

static VALUE
imaginary_node_base_get(VALUE self)
{
    return rb_ivar_get(self, symbol("base"));
}

static VALUE
imaginary_node_seen_point_get(VALUE self)
{
    return rb_ivar_get(self, symbol("seen_point"));
}

static VALUE
imaginary_node_type_get(VALUE self)
{
    return rb_ivar_get(self, symbol("type"));
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

    rb_ivar_set(result, symbol("ptr"), rb_enc_str_new(ptr, len, enc));
    rb_ivar_set(result, symbol("len"), LONG2FIX(len));
    rb_ivar_set(result, symbol("enc"), rb_enc_from_encoding(enc));
    rb_ivar_set(result, symbol("coderange"), parser_string_coderange_type_to_str(conderange));

    return result;
}

static VALUE
string_node_ptr_get(VALUE self)
{
    return rb_ivar_get(self, symbol("ptr"));
}

static VALUE
string_node_len_get(VALUE self)
{
    return rb_ivar_get(self, symbol("len"));
}

static VALUE
string_node_enc_get(VALUE self)
{
    return rb_ivar_get(self, symbol("enc"));
}

static VALUE
string_node_coderange_get(VALUE self)
{
    return rb_ivar_get(self, symbol("coderange"));
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

    rb_ivar_set(obj, symbol("ptr"), rb_enc_str_new(ptr, len, enc));
    rb_ivar_set(obj, symbol("len"), LONG2FIX(len));
    rb_ivar_set(obj, symbol("enc"), rb_enc_from_encoding(enc));
    rb_ivar_set(obj, symbol("coderange"), parser_string_coderange_type_to_str(conderange));

    return obj;
}

static VALUE
symbol_node_ptr_get(VALUE self)
{
    return rb_ivar_get(self, symbol("ptr"));
}

static VALUE
symbol_node_len_get(VALUE self)
{
    return rb_ivar_get(self, symbol("len"));
}

static VALUE
symbol_node_enc_get(VALUE self)
{
    return rb_ivar_get(self, symbol("enc"));
}

static VALUE
symbol_node_coderange_get(VALUE self)
{
    return rb_ivar_get(self, symbol("coderange"));
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

    rb_ivar_set(obj, symbol("ptr"), rb_enc_str_new(ptr, len, enc));
    rb_ivar_set(obj, symbol("len"), LONG2FIX(len));
    rb_ivar_set(obj, symbol("enc"), rb_enc_from_encoding(enc));
    rb_ivar_set(obj, symbol("coderange"), parser_string_coderange_type_to_str(conderange));

    return obj;
}

static VALUE
file_node_ptr_get(VALUE self)
{
    return rb_ivar_get(self, symbol("ptr"));
}

static VALUE
file_node_len_get(VALUE self)
{
    return rb_ivar_get(self, symbol("len"));
}

static VALUE
file_node_enc_get(VALUE self)
{
    return rb_ivar_get(self, symbol("enc"));
}

static VALUE
file_node_coderange_get(VALUE self)
{
    return rb_ivar_get(self, symbol("coderange"));
}

void
Init_LiteralNode(VALUE module)
{
    rb_cIntegerNode = rb_define_class_under(module, "IntegerNode", rb_cObject);
    rb_define_method(rb_cIntegerNode, "val", integer_node_val_get, 0);
    rb_define_method(rb_cIntegerNode, "minus", integer_node_minus_get, 0);
    rb_define_method(rb_cIntegerNode, "base", integer_node_base_get, 0);

    rb_cFloatNode = rb_define_class_under(module, "FloatNode", rb_cObject);
    rb_define_method(rb_cFloatNode, "val", float_node_val_get, 0);
    rb_define_method(rb_cFloatNode, "minus", float_node_minus_get, 0);

    rb_cRationalNode = rb_define_class_under(module, "RationalNode", rb_cObject);
    rb_define_method(rb_cRationalNode, "val", rational_node_val_get, 0);
    rb_define_method(rb_cRationalNode, "minus", rational_node_minus_get, 0);
    rb_define_method(rb_cRationalNode, "base", rational_node_base_get, 0);
    rb_define_method(rb_cRationalNode, "seen_point", rational_node_seen_point_get, 0);

    rb_cImaginaryNode = rb_define_class_under(module, "ImaginaryNode", rb_cObject);
    rb_define_method(rb_cImaginaryNode, "val", imaginary_node_val_get, 0);
    rb_define_method(rb_cImaginaryNode, "minus", imaginary_node_minus_get, 0);
    rb_define_method(rb_cImaginaryNode, "base", imaginary_node_base_get, 0);
    rb_define_method(rb_cImaginaryNode, "seen_point", imaginary_node_seen_point_get, 0);
    rb_define_method(rb_cImaginaryNode, "type", imaginary_node_type_get, 0);

    rb_cStringNode = rb_define_class_under(module, "StringNode", rb_cObject);
    rb_define_method(rb_cStringNode, "ptr", string_node_ptr_get, 0);
    rb_define_method(rb_cStringNode, "len", string_node_len_get, 0);
    rb_define_method(rb_cStringNode, "enc", string_node_enc_get, 0);
    rb_define_method(rb_cStringNode, "coderange", string_node_coderange_get, 0);

    rb_cSymbolNode = rb_define_class_under(module, "SymbolNode", rb_cObject);
    rb_define_method(rb_cSymbolNode, "ptr", symbol_node_ptr_get, 0);
    rb_define_method(rb_cSymbolNode, "len", symbol_node_len_get, 0);
    rb_define_method(rb_cSymbolNode, "enc", symbol_node_enc_get, 0);
    rb_define_method(rb_cSymbolNode, "coderange", symbol_node_coderange_get, 0);

    rb_cFileNode = rb_define_class_under(module, "FileNode", rb_cObject);
    rb_define_method(rb_cFileNode, "ptr", file_node_ptr_get, 0);
    rb_define_method(rb_cFileNode, "len", file_node_len_get, 0);
    rb_define_method(rb_cFileNode, "enc", file_node_enc_get, 0);
    rb_define_method(rb_cFileNode, "coderange", file_node_coderange_get, 0);
}
