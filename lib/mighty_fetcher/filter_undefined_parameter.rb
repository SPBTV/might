require_relative 'filter_parameter_definition'

module MightyFetcher
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
