/*
 * Kanayago - Ruby Parser Extension
 *
 * This file contains code derived from CRuby (https://www.ruby-lang.org/).
 *
 * The following functions are based on ruby_parser.c:
 *   - kanayago_zalloc
 *   - kanayago_memmove
 *   - kanayago_nonempty_memcpy
 *   - kanayago_is_local_id
 *   - kanayago_is_attrset_id
 *   - kanayago_is_notop_id
 *   - kanayago_enc_str_new
 *   - kanayago_enc_isalnum
 *   - kanayago_enc_precise_mbclen
 *   - kanayago_mbclen_charfound_p
 *   - kanayago_mbclen_charfound_len
 *   - kanayago_enc_name
 *   - kanayago_enc_prev_char
 *   - kanayago_enc_get
 *   - kanayago_enc_asciicompat
 *   - kanayago_utf8_encoding
 *   - kanayago_ascii8bit_encoding
 *   - kanayago_enc_codelen
 *   - kanayago_enc_mbcput
 *   - kanayago_enc_from_index
 *   - kanayago_enc_isspace
 *   - kanayago_intern3
 *   - kanayago_enc_symname_type
 *   - kanayago_is_usascii_enc
 *   - kanayago_local_defined
 *   - kanayago_dvar_defined
 *   - kanayago_rtest
 *   - kanayago_nil_p
 *   - kanayago_syntax_error_new
 *   - kanayago_ruby_verbose
 *   - kanayago_errno_ptr
 *   - kanayago_gc_guard
 *   - kanayago_arg_error
 *   - kanayago_static_id2sym
 *   - kanayago_str_coderange_scan_restartable
 *   - kanayago_enc_mbminlen
 *   - kanayago_enc_isascii
 *   - kanayago_enc_mbc_to_codepoint
 *   - kanayago_reg_named_capture_assign
 *   - kanayago_reg_named_capture_assign_iter
 *
 * The following functions are based on error.c:
 *   - kanayago_err_vcatf
 *   - kanayago_syntax_error_with_path
 *   - kanayago_syntax_error_append
 *
 * Ruby is copyrighted free software by Yukihiro Matsumoto <matz@netlab.jp>.
 * Ruby is available under the terms of the 2-clause BSD License:
 *
 *   Redistribution and use in source and binary forms, with or without
 *   modification, are permitted provided that the following conditions are met:
 *
 *   1. Redistributions of source code must retain the above copyright notice,
 *      this list of conditions and the following disclaimer.
 *   2. Redistributions in binary form must reproduce the above copyright notice,
 *      this list of conditions and the following disclaimer in the documentation
 *      and/or other materials provided with the distribution.
 *
 *   THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 *   AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 *   IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 *   ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
 *   LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
 *   CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 *   SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 *   INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
 *   CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 *   ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
 *   POSSIBILITY OF SUCH DAMAGE.
 *
 * See https://www.ruby-lang.org/en/about/license.txt for the full Ruby license.
 */

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

#include <unistd.h>
#include "internal.h"
#include "internal/array.h"
#include "internal/bignum.h"
#include "internal/compile.h"
#include "internal/complex.h"
#include "internal/gc.h"
#include "internal/hash.h"
#include "internal/io.h"
#include "internal/rational.h"
#include "internal/re.h"
#include "internal/string.h"
#include "internal/symbol.h"
#include "internal/thread.h"
#include "ruby/ractor.h"
#include "ruby/util.h"
#include "vm_core.h"
#include "symbol.h"

#define parser_encoding const void

/*
 * Kanayago's own adapter implementation
 * To eliminate dependency on Universal Parser's rb_global_parser_config,
 * we define our own kanayago_parser_config.
 */

/* Memory allocation with overflow check */
static void *
kanayago_xmalloc_mul_add(size_t x, size_t y, size_t z)
{
    size_t size;
    if (y != 0 && x > (SIZE_MAX - z) / y) {
        rb_raise(rb_eArgError, "allocation size overflow");
    }
    size = x * y + z;
    return ruby_xmalloc(size);
}

/* Temporary ID generation */
static size_t kanayago_tmp_id_counter = 0;

static ID
kanayago_make_temporary_id(size_t n)
{
    char buf[64];
    snprintf(buf, sizeof(buf), "@kanayago_tmp_%zu_%zu", n, kanayago_tmp_id_counter++);
    return rb_intern(buf);
}

/* TTY detection */
static int
kanayago_stderr_tty_p(void)
{
    return isatty(fileno(stderr));
}

/* Regex compilation */
static VALUE
kanayago_reg_compile(VALUE str, int options, const char *sourcefile, int sourceline)
{
    return rb_reg_new_str(str, options);
}

/* Regex preprocessing */
static VALUE
kanayago_reg_check_preprocess(VALUE val)
{
    return Qnil;
}

/* Tracing suppression */
static VALUE
kanayago_suppress_tracing(VALUE (*func)(VALUE), VALUE arg)
{
    return func(arg);
}

/* Helper functions (ported from ruby_parser.c) */
static void *
kanayago_zalloc(size_t elemsiz)
{
    return ruby_xcalloc(1, elemsiz);
}

static void *
kanayago_memmove(void *dest, const void *src, size_t t, size_t n)
{
    return memmove(dest, src, rbimpl_size_mul_or_raise(t, n));
}

static void *
kanayago_nonempty_memcpy(void *dest, const void *src, size_t t, size_t n)
{
    return ruby_nonempty_memcpy(dest, src, rbimpl_size_mul_or_raise(t, n));
}

static int
kanayago_is_local_id(ID id)
{
    return is_local_id(id);
}

static int
kanayago_is_attrset_id(ID id)
{
    return is_attrset_id(id);
}

static int
kanayago_is_notop_id(ID id)
{
    return is_notop_id(id);
}

static VALUE
kanayago_enc_str_new(const char *ptr, long len, parser_encoding *enc)
{
    return rb_enc_str_new(ptr, len, enc);
}

static int
kanayago_enc_isalnum(OnigCodePoint c, parser_encoding *enc)
{
    return rb_enc_isalnum(c, enc);
}

static int
kanayago_enc_precise_mbclen(const char *p, const char *e, parser_encoding *enc)
{
    return rb_enc_precise_mbclen(p, e, enc);
}

static int
kanayago_mbclen_charfound_p(int len)
{
    return MBCLEN_CHARFOUND_P(len);
}

static int
kanayago_mbclen_charfound_len(int len)
{
    return MBCLEN_CHARFOUND_LEN(len);
}

static const char *
kanayago_enc_name(parser_encoding *enc)
{
    return rb_enc_name(enc);
}

static char *
kanayago_enc_prev_char(const char *s, const char *p, const char *e, parser_encoding *enc)
{
    return rb_enc_prev_char(s, p, e, enc);
}

static parser_encoding *
kanayago_enc_get(VALUE obj)
{
    return rb_enc_get(obj);
}

static int
kanayago_enc_asciicompat(parser_encoding *enc)
{
    return rb_enc_asciicompat(enc);
}

static parser_encoding *
kanayago_utf8_encoding(void)
{
    return rb_utf8_encoding();
}

static parser_encoding *
kanayago_ascii8bit_encoding(void)
{
    return rb_ascii8bit_encoding();
}

static int
kanayago_enc_codelen(int c, parser_encoding *enc)
{
    return rb_enc_codelen(c, enc);
}

static int
kanayago_enc_mbcput(unsigned int c, void *buf, parser_encoding *enc)
{
    return rb_enc_mbcput(c, buf, enc);
}

static parser_encoding *
kanayago_enc_from_index(int idx)
{
    return rb_enc_from_index(idx);
}

static int
kanayago_enc_isspace(OnigCodePoint c, parser_encoding *enc)
{
    return rb_enc_isspace(c, enc);
}

static ID
kanayago_intern3(const char *name, long len, parser_encoding *enc)
{
    return rb_intern3(name, len, enc);
}

static int
kanayago_enc_symname_type(const char *name, long len, parser_encoding *enc, unsigned int allowed_attrset)
{
    return rb_enc_symname_type(name, len, enc, allowed_attrset);
}

static int
kanayago_is_usascii_enc(parser_encoding *enc)
{
    return rb_is_usascii_enc(enc);
}

static int
kanayago_local_defined(ID id, const void *p)
{
    // Kanayago doesn't have external ISEQ context
    // parent_iseq is always NULL, so always return 0
    (void)id;
    (void)p;
    return 0;
}

static int
kanayago_dvar_defined(ID id, const void *p)
{
    // Kanayago doesn't have external ISEQ context
    // parent_iseq is always NULL, so always return 0
    (void)id;
    (void)p;
    return 0;
}

static int
kanayago_rtest(VALUE obj)
{
    return (int)RB_TEST(obj);
}

static int
kanayago_nil_p(VALUE obj)
{
    return (int)NIL_P(obj);
}

static VALUE
kanayago_syntax_error_new(void)
{
    return rb_class_new_instance(0, 0, rb_eSyntaxError);
}

static VALUE
kanayago_ruby_verbose(void)
{
    return ruby_verbose;
}

static int *
kanayago_errno_ptr(void)
{
    return rb_errno_ptr();
}

static void
kanayago_gc_guard(VALUE obj)
{
    RB_GC_GUARD(obj);
}

static VALUE
kanayago_arg_error(void)
{
    return rb_eArgError;
}

static VALUE
kanayago_static_id2sym(ID id)
{
    return (((VALUE)(id)<<RUBY_SPECIAL_SHIFT)|SYMBOL_FLAG);
}

static long
kanayago_str_coderange_scan_restartable(const char *s, const char *e, parser_encoding *enc, int *cr)
{
    return rb_str_coderange_scan_restartable(s, e, enc, cr);
}

static int
kanayago_enc_mbminlen(parser_encoding *enc)
{
    return rb_enc_mbminlen(enc);
}

static bool
kanayago_enc_isascii(OnigCodePoint c, parser_encoding *enc)
{
    return rb_enc_isascii(c, enc);
}

static OnigCodePoint
kanayago_enc_mbc_to_codepoint(const char *p, const char *e, parser_encoding *enc)
{
    const OnigUChar *up = RBIMPL_CAST((const OnigUChar *)p);
    const OnigUChar *ue = RBIMPL_CAST((const OnigUChar *)e);

    return ONIGENC_MBC_TO_CODE((rb_encoding *)enc, up, ue);
}

/* Syntax Error Append (ported from error.c) */
static VALUE
kanayago_err_vcatf(VALUE str, const char *pre, const char *file, int line,
          const char *fmt, va_list args)
{
    if (file) {
        rb_str_cat_cstr(str, file);
        if (line) rb_str_catf(str, ":%d", line);
        rb_str_cat_cstr(str, ": ");
    }
    if (pre) rb_str_cat_cstr(str, pre);
    rb_str_vcatf(str, fmt, args);
    return str;
}

static VALUE
kanayago_syntax_error_with_path(VALUE exc, VALUE file, VALUE *mesg, rb_encoding *enc)
{
    if (NIL_P(exc) || exc == Qfalse) {
        exc = rb_class_new_instance(0, 0, rb_eSyntaxError);
    }
    *mesg = rb_attr_get(exc, rb_intern("mesg"));
    if (NIL_P(*mesg) || OBJ_FROZEN(*mesg)) {
        *mesg = rb_enc_str_new(0, 0, enc);
        rb_ivar_set(exc, rb_intern("mesg"), *mesg);
    }
    return exc;
}

RBIMPL_ATTR_FORMAT(RBIMPL_PRINTF_FORMAT, 6, 0)
static VALUE
kanayago_syntax_error_append(VALUE exc, VALUE file, int line, int column,
                       parser_encoding *enc, const char *fmt, va_list args)
{
    const char *fn = NIL_P(file) ? NULL : RSTRING_PTR(file);
    if (!exc) {
        exc = rb_class_new_instance(0, 0, rb_eSyntaxError);
        VALUE mesg = rb_attr_get(exc, rb_intern("mesg"));
        if (NIL_P(mesg) || OBJ_FROZEN(mesg)) {
            mesg = rb_enc_str_new(0, 0, enc);
            rb_ivar_set(exc, rb_intern("mesg"), mesg);
        }
        kanayago_err_vcatf(mesg, NULL, fn, line, fmt, args);
        VALUE err_mesg = rb_str_dup(mesg);
        rb_str_cat_cstr(err_mesg, "\n");
        rb_write_error_str(err_mesg);
    }
    else {
        VALUE mesg;
        exc = kanayago_syntax_error_with_path(exc, file, &mesg, enc);
        kanayago_err_vcatf(mesg, NULL, fn, line, fmt, args);
    }

    return exc;
}

/* reg_named_capture_assign (ported from ruby_parser.c) */
typedef struct {
    struct parser_params *parser;
    rb_encoding *enc;
    NODE *succ_block;
    const rb_code_location_t *loc;
    rb_parser_assignable_func assignable;
} kanayago_reg_named_capture_assign_t;

static int
kanayago_reg_named_capture_assign_iter(const OnigUChar *name, const OnigUChar *name_end,
          int back_num, int *back_refs, OnigRegex regex, void *arg0)
{
    kanayago_reg_named_capture_assign_t *arg = (kanayago_reg_named_capture_assign_t*)arg0;
    struct parser_params* p = arg->parser;
    rb_encoding *enc = arg->enc;
    const rb_code_location_t *loc = arg->loc;
    long len = name_end - name;
    const char *s = (const char *)name;

    return rb_reg_named_capture_assign_iter_impl(p, s, len, enc, &arg->succ_block, loc, arg->assignable);
}

static NODE *
kanayago_reg_named_capture_assign(struct parser_params* p, VALUE regexp, const rb_code_location_t *loc,
                         rb_parser_assignable_func assignable)
{
    kanayago_reg_named_capture_assign_t arg;

    arg.parser = p;
    arg.enc = rb_enc_get(regexp);
    arg.succ_block = 0;
    arg.loc = loc;
    arg.assignable = assignable;
    onig_foreach_name(RREGEXP_PTR(regexp), kanayago_reg_named_capture_assign_iter, &arg);

    if (!arg.succ_block) return 0;
    return RNODE_BLOCK(arg.succ_block)->nd_next;
}

/* Kanayago's own parser config */
static const rb_parser_config_t kanayago_parser_config = {
    .malloc = ruby_xmalloc,
    .calloc = ruby_xcalloc,
    .realloc = ruby_xrealloc,
    .free = ruby_xfree,
    .alloc_n = ruby_xmalloc2,
    .alloc = ruby_xmalloc,
    .realloc_n = ruby_xrealloc2,
    .zalloc = kanayago_zalloc,
    .rb_memmove = kanayago_memmove,
    .nonempty_memcpy = kanayago_nonempty_memcpy,
    .xmalloc_mul_add = kanayago_xmalloc_mul_add,

    .compile_callback = kanayago_suppress_tracing,
    .reg_named_capture_assign = kanayago_reg_named_capture_assign,

    .attr_get = rb_attr_get,

    .ary_new_from_args = rb_ary_new_from_args,
    .ary_unshift = rb_ary_unshift,

    .make_temporary_id = kanayago_make_temporary_id,
    .is_local_id = kanayago_is_local_id,
    .is_attrset_id = kanayago_is_attrset_id,
    .is_global_name_punct = is_global_name_punct,
    .id_type = id_type,
    .id_attrset = rb_id_attrset,
    .intern = rb_intern,
    .intern2 = rb_intern2,
    .intern3 = kanayago_intern3,
    .intern_str = rb_intern_str,
    .is_notop_id = kanayago_is_notop_id,
    .enc_symname_type = kanayago_enc_symname_type,
    .id2name = rb_id2name,
    .id2str = rb_id2str,
    .id2sym = rb_id2sym,

    .str_catf = rb_str_catf,
    .str_cat_cstr = rb_str_cat_cstr,
    .str_resize = rb_str_resize,
    .str_new = rb_str_new,
    .str_new_cstr = rb_str_new_cstr,
    .str_to_interned_str = rb_str_to_interned_str,
    .enc_str_new = kanayago_enc_str_new,
    .str_vcatf = rb_str_vcatf,
    .rb_sprintf = rb_sprintf,
    .rstring_ptr = RSTRING_PTR,
    .rstring_len = RSTRING_LEN,

    .int2num = rb_int2num_inline,

    .stderr_tty_p = kanayago_stderr_tty_p,
    .write_error_str = rb_write_error_str,
    .io_write = rb_io_write,
    .io_flush = rb_io_flush,
    .io_puts = rb_io_puts,

    .debug_output_stdout = rb_ractor_stdout,
    .debug_output_stderr = rb_ractor_stderr,

    .is_usascii_enc = kanayago_is_usascii_enc,
    .enc_isalnum = kanayago_enc_isalnum,
    .enc_precise_mbclen = kanayago_enc_precise_mbclen,
    .mbclen_charfound_p = kanayago_mbclen_charfound_p,
    .mbclen_charfound_len = kanayago_mbclen_charfound_len,
    .enc_name = kanayago_enc_name,
    .enc_prev_char = kanayago_enc_prev_char,
    .enc_get = kanayago_enc_get,
    .enc_asciicompat = kanayago_enc_asciicompat,
    .utf8_encoding = kanayago_utf8_encoding,
    .ascii8bit_encoding = kanayago_ascii8bit_encoding,
    .enc_codelen = kanayago_enc_codelen,
    .enc_mbcput = kanayago_enc_mbcput,
    .enc_find_index = rb_enc_find_index,
    .enc_from_index = kanayago_enc_from_index,
    .enc_isspace = kanayago_enc_isspace,
    .enc_coderange_7bit = ENC_CODERANGE_7BIT,
    .enc_coderange_unknown = ENC_CODERANGE_UNKNOWN,
    .enc_mbminlen = kanayago_enc_mbminlen,
    .enc_isascii = kanayago_enc_isascii,
    .enc_mbc_to_codepoint = kanayago_enc_mbc_to_codepoint,

    .local_defined = kanayago_local_defined,
    .dvar_defined = kanayago_dvar_defined,

    .syntax_error_append = kanayago_syntax_error_append,
    .raise = rb_raise,
    .syntax_error_new = kanayago_syntax_error_new,

    .errinfo = rb_errinfo,
    .set_errinfo = rb_set_errinfo,
    .make_exception = rb_make_exception,

    .sized_xfree = ruby_sized_xfree,
    .sized_realloc_n = ruby_sized_realloc_n,
    .gc_guard = kanayago_gc_guard,
    .gc_mark = rb_gc_mark,

    .reg_compile = kanayago_reg_compile,
    .reg_check_preprocess = kanayago_reg_check_preprocess,
    .memcicmp = rb_memcicmp,

    .compile_warn = rb_compile_warn,
    .compile_warning = rb_compile_warning,
    .bug = rb_bug,
    .fatal = rb_fatal,
    .verbose = kanayago_ruby_verbose,
    .errno_ptr = kanayago_errno_ptr,

    .make_backtrace = rb_make_backtrace,

    .scan_hex = ruby_scan_hex,
    .scan_oct = ruby_scan_oct,
    .scan_digits = ruby_scan_digits,
    .strtod = ruby_strtod,

    .rtest = kanayago_rtest,
    .nil_p = kanayago_nil_p,
    .qnil = Qnil,
    .qfalse = Qfalse,
    .eArgError = kanayago_arg_error,
    .long2int = rb_long2int,

    /* For Ripper */
    .static_id2sym = kanayago_static_id2sym,
    .str_coderange_scan_restartable = kanayago_str_coderange_scan_restartable,
};

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

    rb_ivar_set(obj, rb_intern("@recv"), ast_to_node_instance(RNODE_OPCALL(node)->nd_recv));
    rb_ivar_set(obj, rb_intern("@mid"), ID2SYM(RNODE_OPCALL(node)->nd_mid));
    rb_ivar_set(obj, rb_intern("@args"), ast_to_node_instance(RNODE_OPCALL(node)->nd_args));

    return obj;
}

static VALUE
call_node_new(const NODE *node)
{
    VALUE result = rb_class_new_instance(0, 0, rb_cCallNode);

    rb_ivar_set(result, rb_intern("@recv"), ast_to_node_instance(RNODE_OPCALL(node)->nd_recv));
    rb_ivar_set(result, rb_intern("@mid"), ID2SYM(RNODE_CALL(node)->nd_mid));
    rb_ivar_set(result, rb_intern("@args"), ast_to_node_instance(RNODE_CALL(node)->nd_args));

    return result;
}

static VALUE
function_call_node_new(const NODE *node)
{
    VALUE obj = rb_class_new_instance(0, 0, rb_cFunctionCallNode);

    rb_ivar_set(obj, rb_intern("@mid"), ID2SYM(RNODE_FCALL(node)->nd_mid));
    rb_ivar_set(obj, rb_intern("@args"), ast_to_node_instance(RNODE_FCALL(node)->nd_args));

    return obj;
}

static VALUE
variable_call_node_new(const NODE *node)
{
    VALUE obj = rb_class_new_instance(0, 0, rb_cVariableCallNode);

    rb_ivar_set(obj, rb_intern("@mid"), ID2SYM(RNODE_VCALL(node)->nd_mid));

    return obj;
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

    rb_ivar_set(obj, rb_intern("@mid"), ID2SYM(RNODE_DEFN(node)->nd_mid));
    rb_ivar_set(obj, rb_intern("@defn"), ast_to_node_instance(RNODE_DEFN(node)->nd_defn));

    return obj;
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

    rb_ivar_set(obj, rb_intern("@vid"), ID2SYM(RNODE_CONST(node)->nd_vid));

    return obj;
}

static VALUE
constant_declaration_node_new(const NODE *node)
{
    VALUE obj = rb_class_new_instance(0, 0, rb_cConstantDeclarationNode);

    rb_ivar_set(obj, rb_intern("@vid"), ID2SYM(RNODE_CDECL(node)->nd_vid));
    rb_ivar_set(obj, rb_intern("@else"), ast_to_node_instance(RNODE_CDECL(node)->nd_else));
    rb_ivar_set(obj, rb_intern("@value"), ast_to_node_instance(RNODE_CDECL(node)->nd_value));

    return obj;
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

    rb_ivar_set(obj, rb_intern("@cpath"), ast_to_node_instance(RNODE_CLASS(node)->nd_cpath));
    rb_ivar_set(obj, rb_intern("@super"), ast_to_node_instance(RNODE_CLASS(node)->nd_super));
    rb_ivar_set(obj, rb_intern("@body"), ast_to_node_instance(RNODE_CLASS(node)->nd_body));

    return obj;
}

static VALUE
module_node_new(const NODE *node)
{
    VALUE obj = rb_class_new_instance(0, 0, rb_cModuleNode);

    rb_ivar_set(obj, rb_intern("@cpath"), ast_to_node_instance(RNODE_MODULE(node)->nd_cpath));
    rb_ivar_set(obj, rb_intern("@body"), ast_to_node_instance(RNODE_MODULE(node)->nd_body));

    return obj;
}

static VALUE
colon2_node_new(const NODE *node)
{
    VALUE obj = rb_class_new_instance(0, 0, rb_cColon2Node);

    rb_ivar_set(obj, rb_intern("@mid"), ID2SYM(RNODE_COLON2(node)->nd_mid));
    rb_ivar_set(obj, rb_intern("@head"), ast_to_node_instance(RNODE_COLON2(node)->nd_head));

    return obj;
}

static VALUE
colon3_node_new(const NODE *node)
{
    VALUE obj = rb_class_new_instance(0, 0, rb_cColon3Node);

    rb_ivar_set(obj, rb_intern("@mid"), ID2SYM(RNODE_COLON3(node)->nd_mid));

    return obj;
}

static VALUE
begin_node_new(const NODE *node)
{
    VALUE obj = rb_class_new_instance(0, 0, rb_cBeginNode);

    rb_ivar_set(obj, rb_intern("@body"), ast_to_node_instance(RNODE_BEGIN(node)->nd_body));

    return obj;
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

    rb_ivar_set(obj, rb_intern("@ainfo"), ainfo_hash);

    return obj;
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

    /* Use Kanayago's own parser config */
    parser_params = rb_ruby_parser_new(&kanayago_parser_config);
    VALUE vparser = TypedData_Make_Struct(0, struct ruby_parser,
                                         &ruby_parser_data_type, parser);
    parser->parser_params = parser_params;

    // Enable error tolerant parser
    rb_ruby_parser_error_tolerant(parser_params);

    // Enable script_lines to get source lines from AST
    rb_ruby_parser_set_script_lines(parser_params);

    VALUE vast = rb_parser_compile_string(vparser, "main", source, 0);

    rb_ast_t *ast = rb_ruby_ast_data_get(vast);
    VALUE ast_node = ast_to_node_instance(ast->body.root);

    /* Ensure vast and vparser are not garbage collected during AST processing.
     * The AST data (ast->body.root) is owned by vast, so we need to
     * keep vast alive until we're done traversing the AST. */
    RB_GC_GUARD(vast);
    RB_GC_GUARD(vparser);

    // Get error_buffer from parser_params using accessor function
    VALUE error_buffer = rb_ruby_parser_error_buffer_get(parser_params);

    // Get script_lines from AST and convert to Ruby array
    VALUE script_lines = rb_parser_build_script_lines_from(ast->body.script_lines);

    VALUE result = rb_hash_new();
    rb_hash_aset(result, ID2SYM(rb_intern("ast")), ast_node);
    rb_hash_aset(result, ID2SYM(rb_intern("error")), error_buffer);
    rb_hash_aset(result, ID2SYM(rb_intern("script_lines")), script_lines);

    return result;
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

    rb_cConstantDeclarationNode = rb_define_class_under(rb_mKanayago, "ConstantDeclarationNode", rb_cObject);

    rb_cDefinitionNode = rb_define_class_under(rb_mKanayago, "DefinitionNode", rb_cObject);

    rb_cOperatorCallNode = rb_define_class_under(rb_mKanayago, "OperatorCallNode", rb_cObject);

    rb_cListNode = rb_define_class_under(rb_mKanayago, "ListNode", rb_cObject);

    rb_cArgumentsNode = rb_define_class_under(rb_mKanayago, "ArgumentsNode", rb_cObject);

    rb_cCallNode = rb_define_class_under(rb_mKanayago, "CallNode", rb_cObject);

    rb_cFunctionCallNode = rb_define_class_under(rb_mKanayago, "FunctionCallNode", rb_cObject);

    rb_cVariableCallNode = rb_define_class_under(rb_mKanayago, "VariableCallNode", rb_cObject);

    // For Statement Node(e.g. Kanayago::IfStatementNode)
    Init_StatementNode(rb_mKanayago);

    rb_cBlockNode = rb_define_class_under(rb_mKanayago, "BlockNode", rb_cArray);

    rb_cBeginNode = rb_define_class_under(rb_mKanayago, "BeginNode", rb_cObject);

    rb_cClassNode = rb_define_class_under(rb_mKanayago, "ClassNode", rb_cObject);

    rb_cModuleNode = rb_define_class_under(rb_mKanayago, "ModuleNode", rb_cObject);

    rb_cColon2Node = rb_define_class_under(rb_mKanayago, "Colon2Node", rb_cObject);

    rb_cColon3Node = rb_define_class_under(rb_mKanayago, "Colon3Node", rb_cObject);

    // For Variable Node(e.g. Kanayago::LocalVariableNode)
    Init_VariableNode(rb_mKanayago);

    // For Pattern Node(e.g. Kanayago::InNode)
    Init_PatternNode(rb_mKanayago);

    rb_cSelfNode = rb_define_class_under(rb_mKanayago, "SelfNode", rb_cObject);
}
