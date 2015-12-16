require 'set'

module Might
  #
  class FilterParameters < Set
    FilterError = Class.new(KeyError)

    # Find filter by name
    # @param name [String]
    # @return [Might::FilterParameter, nil]
    #
    def [](name)
      detect { |filter| filter.name == name }
    end

    # Find filter by name or raise error
    # @param name [String]
    # @return [Might::FilterParameter]
    # @raise FilterError
    #
    def fetch(name)
      if (filter = self[name])
        filter
      else
        fail FilterError, "filter not found: #{name.inspect}"
      end
    end
  end
end
