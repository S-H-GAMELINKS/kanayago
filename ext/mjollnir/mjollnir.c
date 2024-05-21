#include "mjollnir.h"

VALUE rb_mMjollnir;

RUBY_FUNC_EXPORTED void
Init_mjollnir(void)
{
  rb_mMjollnir = rb_define_module("Mjollnir");
}
