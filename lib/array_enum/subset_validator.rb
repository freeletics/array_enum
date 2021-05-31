require "active_model/validator"

class ArrayEnum::SubsetValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    wrapped_value = [value].flatten # Handles nil value
    subset = delimiter.respond_to?(:call) ? delimiter.call(record) : delimiter

    diff = wrapped_value.reject { |element| subset.include?(element) }

    unless diff.empty?
      record.errors.add(attribute, :inclusion, **options.except(:in, :within).merge!(value: diff))
    end
  end

  private

  def delimiter
    @delimiter ||= options[:in] || options[:within]
  end
end
