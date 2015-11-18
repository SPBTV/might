require 'might/sort_parameter_definition'

module Might
  # Null object for ParameterDefinition
  #
  class SortUndefinedParameter < SortParameterDefinition
    def required?
      false
    end

    def defined?
      false
    end
  end
end
