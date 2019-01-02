require "rails/railtie"

class ArrayEnum::Railtie < Rails::Railtie
  initializer "array_enum.subset_validator" do
    # ActiveModel expects top level class name for validator to have syntax "validates subset: []"
    ::SubsetValidator = ArrayEnum::SubsetValidator unless defined?(::SubsetValidator)
  end
end
