# frozen_string_literal: true
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
    # @param predicate [String]
    # @return [Might::FilterParameter, nil]
    #
    def [](name, predicate = nil)
      parameters.detect do |filter|
        filter.name == name && (predicate.nil? || filter.predicate == predicate)
      end
    end

    # Find filter by name or raise error
    # @param name [String]
    # @param predicate [String]
    # @yieldparam name [String]
    #   block value will be returned if no `FilterParameter` found with specified name
    # @return [Might::FilterParameter]
    # @raise FilterError
    #
    def fetch(name, predicate = nil)
      if (filter = self[name, predicate])
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

    # Delete filter by name and predicate
    # @param name [String]
    # @param predicate [String]
    # @return [Might::FilterParameter, nil]
    def delete(name, predicate = nil)
      filter_parameter = self[name, predicate]
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
