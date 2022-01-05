require "array_enum/version"
require "array_enum/subset_validator"
require "array_enum/railtie" if defined?(Rails::Railtie)
require "active_support/hash_with_indifferent_access"
require "active_support/core_ext/string/inflections"

module ArrayEnum
  MISSING_VALUE_MESSAGE = "%{value} is not a valid value for %{attr}".freeze
  private_constant :MISSING_VALUE_MESSAGE

  def array_enum(definitions)
    definitions.each do |attr_name, mapping|
      attr_symbol = attr_name.to_sym
      mapping_hash = ActiveSupport::HashWithIndifferentAccess.new(mapping)

      define_singleton_method(attr_name.to_s.pluralize) do
        mapping_hash
      end

      {
        "with_#{attr_name}" => '@>',
        "only_with_#{attr_name}" => '=',
        "with_any_of_#{attr_name}" => '&&'
      }.each do |method_name, comparison_operator|
        define_singleton_method(method_name.to_sym) do |values|
          db_values = Array(values).map do |value|
            mapping_hash[value] || raise(ArgumentError, MISSING_VALUE_MESSAGE % {value: value, attr: attr_name})
          end
          where("#{attr_name} #{comparison_operator} ARRAY[:db_values]", db_values: db_values)
        end
      end

      define_method(attr_symbol) do
        Array(self[attr_symbol]).map { |value| mapping_hash.key(value) }
      end

      define_method("#{attr_name}=".to_sym) do |values|
        self[attr_symbol] = Array(values).map do |value|
          mapping_hash[value] || raise(ArgumentError, MISSING_VALUE_MESSAGE % {value: value, attr: attr_name})
        end.uniq
      end
    end
  end
end
