require "active_model/validator"

class ArrayEnum::SubsetValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    wrapped_value = [value].flatten # Handles nil value
    diff = wrapped_value.reject { |element| delimiter.include?(element) }

    unless diff.empty?
      record.errors.add(attribute, :inclusion, options.except(:in, :within).merge!(value: diff))
    end
  end

  private

  def delimiter
    @delimiter ||= options[:in] || options[:within]
  end
end
