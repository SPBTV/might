# frozen_string_literal: true
module Might
  # Build singleton validation class for specified attribute name
  # @example you need a nice validator for a first_name
  #   validator_klass = ValueValidator.build('first_name', presence: true, length: { minimum: 3 })
  #   validator = validator_klass.new('Bo')
  #   validator.valid? #=> false
  #   validator.errors.full_messages #=> ['First name is too short (minimum is 3 characters)']
  #
  module FilterValueValidator
    module_function

    # Validates if Parameter is undefined or not
    class DefinedValidator < ActiveModel::EachValidator
      def validate_each(record, attribute, _value)
        record.errors.add(attribute, :undefined_filter) if record.undefined?
      end
    end

    def build(definition)
      Struct.new(definition.as.to_sym) do
        include ActiveModel::Validations

        validates(definition.as, definition.validations) if definition.validations.present?
        validates(definition.as, 'might/filter_value_validator/defined': true)

        define_method(:undefined?) { definition.undefined? }

        define_singleton_method :model_name do
          ActiveModel::Name.new(Might, nil, 'Might')
        end
      end
    end
  end
end
