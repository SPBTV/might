# frozen_string_literal: true
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
