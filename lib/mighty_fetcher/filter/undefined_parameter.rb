require_relative 'parameter_definition'

module MightyFetcher
  module Filter
    # Null object for ParameterDefinition
    #
    class UndefinedParameter < ParameterDefinition
      def required?
        false
      end

      def defined?
        false
      end
    end
  end
end
