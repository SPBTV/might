require 'mighty_fetcher/sort_parameter_definition'

module MightyFetcher
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
