require_relative 'filter_parameter_definition'

module Might
  # Null object for ParameterDefinition
  #
  class FilterUndefinedParameter < FilterParameterDefinition
    def required?
      false
    end

    def defined?
      false
    end
  end
end
