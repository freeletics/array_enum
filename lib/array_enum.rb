require "array_enum/version"
require "array_enum/subset_validator"
require "array_enum/railtie" if defined?(Rails)

module ArrayEnum
  def array_enum(definitions)
    definitions.each do |attr_name, mapping|
      attr_symbol = attr_name.to_sym

      define_singleton_method("with_#{attr_name}".to_sym) do |values|
        db_values = Array(values).map { |value| mapping.fetch(value.to_s) }
        where("#{attr_name} @> ARRAY[:db_values]", db_values: db_values)
      end

      define_method(attr_symbol) do
        Array(self[attr_symbol]).map { |value| mapping.key(value) }
      end

      define_method("#{attr_name}=".to_sym) do |values|
        self[attr_symbol] = Array(values).map { |value| mapping.fetch(value.to_s) }.uniq
      end
    end
  end
end
