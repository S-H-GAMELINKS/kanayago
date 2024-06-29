#include "mjollnir.h"

VALUE rb_mMjollnir;

static VALUE
parse(VALUE source)
{
  return Qtrue;
}

RUBY_FUNC_EXPORTED void
Init_mjollnir(void)
{
  rb_mMjollnir = rb_define_module("Mjollnir");
  rb_define_singleton_method(rb_mMjollnir, "parse", parse, 1);
}
