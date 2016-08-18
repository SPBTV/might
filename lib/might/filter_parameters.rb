require 'set'
require 'forwardable'

module Might
  #
  class FilterParameters
    include Comparable
    include Enumerable
    extend Forwardable

    FilterError = Class.new(KeyError)

    def_delegators :parameters, :detect, :each

    # @param [<Might::FilterParameter>]
    def initialize(parameters = nil)
      @parameters = Set.new(parameters)
    end

    # Dup internal set.
    def initialize_dup(orig)
      super
      @parameters = orig.parameters.dup
    end

    # Clone internal set.
    def initialize_clone(orig)
      super
      @parameters = orig.parameters.clone
    end

    # Find filter by name
    # @param name [String]
    # @return [Might::FilterParameter, nil]
    #
    def [](name)
      parameters.detect { |filter| filter.name == name }
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

    # param value [Might::FilterParameter]
    def add(value)
      self.class.new(parameters.add(value))
    end

    alias << add

    def map(&block)
      self.class.new(parameters.map(&block))
    end

    # param other [Might::FilterParameters]
    def -(other)
      self.class.new(parameters - other.parameters)
    end

    # param other [Might::FilterParameters]
    def +(other)
      self.class.new(parameters.merge(other.parameters))
    end

    # Delete filter by name
    # @param name [String]
    # @return [Might::FilterParameter, nil]
    def delete(name)
      filter_parameter = self[name]
      parameters.delete(filter_parameter) if filter_parameter
      filter_parameter
    end

    def <=>(other)
      parameters <=> other.parameters
    end

    protected

    attr_reader :parameters
  end
end
