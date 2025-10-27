# frozen_string_literal: true

require_relative '../test_helper'

class ParseArgumentsNodeTest < Minitest::Test
  def test_parse_no_arguments
    result = Kanayago.parse(<<~CODE)
      def foo
        "bar"
      end
    CODE

    args = result.body.defn.args

    assert_instance_of(Kanayago::ArgumentsNode, args)

    ainfo = args.ainfo

    assert_instance_of(Hash, ainfo)
    assert_equal(0, ainfo[:pre_args_num])
    assert_equal(0, ainfo[:post_args_num])
    assert_nil(ainfo[:first_post_arg])
    assert_nil(ainfo[:rest_arg])
    assert_nil(ainfo[:block_arg])
    assert_nil(ainfo[:opt_args])
    assert_nil(ainfo[:kw_args])
    assert_nil(ainfo[:kw_rest_arg])
  end

  def test_parse_simple_arguments
    result = Kanayago.parse(<<~CODE)
      def foo(a, b)
        a + b
      end
    CODE

    args = result.body.defn.args

    assert_instance_of(Kanayago::ArgumentsNode, args)

    ainfo = args.ainfo

    assert_equal(2, ainfo[:pre_args_num])
    assert_equal(0, ainfo[:post_args_num])
    assert_nil(ainfo[:rest_arg])
    assert_nil(ainfo[:block_arg])
  end

  def test_parse_block_argument
    result = Kanayago.parse(<<~CODE)
      def foo(&block)
        block.call
      end
    CODE

    args = result.body.defn.args

    assert_instance_of(Kanayago::ArgumentsNode, args)

    ainfo = args.ainfo

    assert_equal(0, ainfo[:pre_args_num])
    assert_equal(:block, ainfo[:block_arg])
  end

  def test_parse_rest_argument
    result = Kanayago.parse(<<~CODE)
      def foo(*args)
        args
      end
    CODE

    args = result.body.defn.args

    assert_instance_of(Kanayago::ArgumentsNode, args)

    ainfo = args.ainfo

    assert_equal(0, ainfo[:pre_args_num])
    assert_equal(:args, ainfo[:rest_arg])
    assert_nil(ainfo[:block_arg])
  end

  def test_parse_keyword_arguments
    result = Kanayago.parse(<<~CODE)
      def foo(a:, b: 1)
        a + b
      end
    CODE

    args = result.body.defn.args

    assert_instance_of(Kanayago::ArgumentsNode, args)

    ainfo = args.ainfo

    assert_equal(0, ainfo[:pre_args_num])
    refute_nil(ainfo[:kw_args])
  end

  def test_parse_keyword_rest_argument
    result = Kanayago.parse(<<~CODE)
      def foo(**kwargs)
        kwargs
      end
    CODE

    args = result.body.defn.args

    assert_instance_of(Kanayago::ArgumentsNode, args)

    ainfo = args.ainfo

    assert_equal(0, ainfo[:pre_args_num])
    assert_instance_of(Kanayago::DynamicVariableNode, ainfo[:kw_rest_arg])
  end

  def test_parse_optional_arguments
    result = Kanayago.parse(<<~CODE)
      def foo(a, b = 1)
        a + b
      end
    CODE

    args = result.body.defn.args

    assert_instance_of(Kanayago::ArgumentsNode, args)

    ainfo = args.ainfo

    assert_equal(1, ainfo[:pre_args_num])
    refute_nil(ainfo[:opt_args])
  end

  def test_parse_complex_arguments
    result = Kanayago.parse(<<~CODE)
      def foo(a, b = 1, *rest, c:, d: 2, **kwargs, &block)
        [a, b, rest, c, d, kwargs, block]
      end
    CODE

    args = result.body.defn.args

    assert_instance_of(Kanayago::ArgumentsNode, args)

    ainfo = args.ainfo

    assert_equal(1, ainfo[:pre_args_num])
    refute_nil(ainfo[:opt_args])
    assert_equal(:rest, ainfo[:rest_arg])
    refute_nil(ainfo[:kw_args])
    assert_instance_of(Kanayago::DynamicVariableNode, ainfo[:kw_rest_arg])
    assert_equal(:block, ainfo[:block_arg])
  end

  def test_parse_post_arguments
    result = Kanayago.parse(<<~CODE)
      def foo(a, *rest, b, c)
        [a, rest, b, c]
      end
    CODE

    args = result.body.defn.args

    assert_instance_of(Kanayago::ArgumentsNode, args)

    ainfo = args.ainfo

    assert_equal(1, ainfo[:pre_args_num])
    assert_equal(2, ainfo[:post_args_num])
    assert_equal(:rest, ainfo[:rest_arg])
  end
end
