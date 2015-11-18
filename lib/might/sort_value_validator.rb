require 'active_support'
require 'active_support/core_ext/module/delegation'
require 'active_model/validator'
require 'active_model/validations'
require 'active_model/callbacks'
require 'active_model/naming'
require 'active_model/translation'
require 'active_model/errors'

module Might
  # Build singleton validation class for specified attribute name
  # @example you need a nice validator for a first_name
  #   validator_klass = ValueValidator.build('first_name', presence: true, length: { minimum: 3 })
  #   validator = validator_klass.new('Bo')
  #   validator.valid? #=> false
  #   validator.errors.full_messages #=> ['First name is too short (minimum is 3 characters)']
  #
  module SortValueValidator
    module_function

    # Validates if Parameter is undefined or not
    class DefinedValidator < ActiveModel::EachValidator
      def validate_each(record, attribute, _value)
        record.errors.add(attribute, :undefined_sort_order) if record.undefined?
      end
    end

    def build(definition)
      Class.new do
        include ActiveModel::Validations

        validates(definition.name, 'might/sort_value_validator/defined': true)

        define_method(:undefined?) { definition.undefined? }
        define_method(definition.name) {}

        def self.model_name
          ActiveModel::Name.new(Might, nil, 'Might')
        end
      end
    end
  end
end
