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
    # @yieldparam name [String]
    #   block value will be returned if no `FilterParameter` found with specified name
    # @return [Might::FilterParameter]
    # @raise FilterError
    #
    def fetch(name)
      if (filter = self[name])
        filter
      elsif block_given?
        yield(name)
      else
        fail FilterError, "filter not found: #{name.inspect}"
      end
    end

    def map(&block)
      dup.map!(&block)
    end
  end
end
