require "array_enum/version"
require "array_enum/subset_validator"
require "array_enum/railtie" if defined?(Rails)

module ArrayEnum
  MISSING_VALUE_MESSAGE = "%{value} is not a valid value for %{attr}".freeze
  private_constant :MISSING_VALUE_MESSAGE

  def array_enum(definitions)
    definitions.each do |attr_name, mapping|
      attr_symbol = attr_name.to_sym

      define_singleton_method("with_#{attr_name}".to_sym) do |values|
        db_values = Array(values).map do |value|
          mapping[value.to_s] || raise(ArgumentError, MISSING_VALUE_MESSAGE % {value: value, attr: attr_name})
        end
        where("#{attr_name} @> ARRAY[:db_values]", db_values: db_values)
      end

      define_method(attr_symbol) do
        Array(self[attr_symbol]).map { |value| mapping.key(value) }
      end

      define_method("#{attr_name}=".to_sym) do |values|
        self[attr_symbol] = Array(values).map do |value|
          mapping[value.to_s] || raise(ArgumentError, MISSING_VALUE_MESSAGE % {value: value, attr: attr_name})
        end.uniq
      end
    end
  end
end
