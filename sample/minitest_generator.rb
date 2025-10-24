# frozen_string_literal: true

require_relative '../lib/kanayago'

class MinitestGenerator
  def initialize(code)
    @code = code
    @ast = Kanayago.parse(code)
    @current_visibility = :public
  end

  def generate
    class_infos = extract_classes(@ast)

    return '# No classes found in the code' if class_infos.empty?

    # Generate tests for all classes
    class_infos.map { |class_info| generate_minitest(class_info) }.join("\n\n")
  end

  private

  # rubocop:disable Metrics/CyclomaticComplexity
  def extract_classes(node, namespace = [])
    classes = []

    case node
    when Kanayago::ModuleNode
      # Process module and its contents
      module_name = extract_constant_name(node.cpath)
      new_namespace = namespace + [module_name]
      classes.concat(extract_classes(node.body, new_namespace)) if node.respond_to?(:body)

    when Kanayago::ClassNode
      # Process class and collect its methods
      class_name = extract_constant_name(node.cpath)
      full_name = (namespace + [class_name]).join('::')
      methods = extract_methods(node.body)

      classes << {
        name: full_name,
        simple_name: class_name,
        methods: methods
      }

      # Also look for nested classes within this class
      new_namespace = namespace + [class_name]
      classes.concat(extract_classes(node.body, new_namespace)) if node.respond_to?(:body)

    when Kanayago::ScopeNode
      classes.concat(extract_classes(node.body, namespace)) if node.respond_to?(:body)

    when Kanayago::BlockNode
      # BlockNode is an Array, iterate through its elements
      node.each do |child|
        classes.concat(extract_classes(child, namespace))
      end
    end

    classes
  end
  # rubocop:enable Metrics/CyclomaticComplexity

  def extract_constant_name(node)
    case node
    when Kanayago::Colon2Node
      # Extract the class name from mid (Symbol)
      node.mid.to_s
    else
      'UnknownClass'
    end
  end

  # rubocop:disable Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
  def extract_methods(node, visibility = :public)
    methods = []
    current_visibility = visibility

    return methods unless node

    case node
    when Kanayago::DefinitionNode
      method_info = {
        name: node.mid.to_s,
        visibility: current_visibility,
        parameters: extract_parameters(node)
      }
      methods << method_info if current_visibility == :public

    when Kanayago::ScopeNode
      # ScopeNode contains body, process it recursively
      methods.concat(extract_methods(node.body, current_visibility)) if node.respond_to?(:body)

    when Kanayago::BlockNode
      # BlockNode is an Array, iterate through its elements
      node.each do |child|
        # Check if this is a visibility modifier
        if child.is_a?(Kanayago::VariableCallNode) && child.respond_to?(:mid)
          case child.mid.to_s
          when 'private'
            current_visibility = :private
          when 'protected'
            current_visibility = :protected
          when 'public'
            current_visibility = :public
          end
        else
          # Process other nodes (including DefinitionNodes)
          methods.concat(extract_methods(child, current_visibility))
        end
      end
    end

    methods
  end
  # rubocop:enable Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity

  # rubocop:disable Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
  def extract_parameters(def_node)
    params = []
    return params unless def_node.respond_to?(:defn)

    defn = def_node.defn
    return params unless defn.respond_to?(:args)

    args = defn.args
    return params unless args.respond_to?(:ainfo)

    ainfo = args.ainfo
    return params unless ainfo.is_a?(Hash)

    # Handle required positional parameters (pre_args)
    pre_count = ainfo[:pre_args_num] || 0
    pre_count.times do |i|
      params << {
        name: "arg#{i + 1}",
        type: :required
      }
    end

    # Handle optional parameters
    if ainfo[:opt_args]
      current_opt = ainfo[:opt_args]
      while current_opt
        if current_opt.respond_to?(:body) && current_opt.body.respond_to?(:id)
          params << {
            name: current_opt.body.id.to_s,
            type: :optional
          }
        end
        current_opt = current_opt.respond_to?(:next) ? current_opt.next : nil
      end
    end

    # Handle keyword parameters
    if ainfo[:kw_args]
      current_kw = ainfo[:kw_args]
      while current_kw
        if current_kw.respond_to?(:body) && current_kw.body.respond_to?(:id)
          params << {
            name: current_kw.body.id.to_s,
            type: :keyword
          }
        end
        current_kw = current_kw.respond_to?(:next) ? current_kw.next : nil
      end
    end

    params
  end
  # rubocop:enable Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity

  def generate_minitest(class_info)
    output = []
    output << "require 'test_helper'"
    output << ''
    output << "class #{class_info[:name]}Test < Minitest::Test"

    if class_info[:methods].empty?
      output << '  # No public methods found'
    else
      class_info[:methods].each do |method|
        output << generate_method_test(method)
      end
    end

    output << 'end'
    output.join("\n")
  end

  def generate_method_test(method)
    lines = []
    method_name = method[:name]
    params = method[:parameters]

    # Convert method name to test method name
    test_base = method_name.gsub('?', '').gsub('!', '')

    if method_name.end_with?('?')
      # Boolean methods - generate true/false cases
      lines << "  def test_#{test_base}_returns_true_when_condition_is_met"
      lines << '    # TODO: implement'
      lines << '  end'
      lines << ''
      lines << "  def test_#{test_base}_returns_false_when_condition_is_not_met"
      lines << '    # TODO: implement'
      lines << '  end'
    elsif method_name == 'initialize'
      # Constructor - check for optional parameters
      lines << '  def test_initialize_creates_new_instance'
      lines << '    # TODO: implement'
      lines << '  end'

      if params.any? { |p| %i[optional keyword].include?(p[:type]) }
        lines << ''
        lines << '  def test_initialize_uses_default_values_when_optional_parameters_are_not_provided'
        lines << '    # TODO: implement'
        lines << '  end'
      end
    else
      # Regular methods
      lines << "  def test_#{test_base}_works_correctly"
      lines << '    # TODO: implement'
      lines << '  end'

      if params.any? { |p| %i[optional keyword].include?(p[:type]) }
        lines << ''
        lines << "  def test_#{test_base}_handles_optional_parameters"
        lines << '    # TODO: implement'
        lines << '  end'
      end
    end

    lines << ''
    lines.join("\n")
  end
end

# Usage example
sample_code = <<~RUBY
  class User
    class Profile
      def initialize(name, age = 20)
        @name = name
        @age = age
      end

      def adult?
        @age >= 18
      end

      def greet(message = "Hello")
        "\#{message}, \#{@name}!"
      end

      private

      def internal_method
        # This should not appear in tests
      end
    end
  end
RUBY

generator = MinitestGenerator.new(sample_code)
puts generator.generate
