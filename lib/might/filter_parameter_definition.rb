require 'active_support/core_ext/hash'

# frozen_string_literal: true
module Might
  # Filtering parameter definition
  #
  class FilterParameterDefinition
    # If the property name doesn't match the name in the query string, use the :as option
    # @return [String]
    attr_reader :as

    # @return [String]
    attr_reader :name

    # Association on which this parameter is defined.
    # @return [String, nil]
    attr_reader :on

    # White-listed predicates
    # @return [<String>]
    attr_reader :predicates

    # @param [String] name of the field
    # @param [Hash] options
    # @option options [Symbol, {Symbol => String}, {Symbol => <String>}] :on (nil) filter on given relation
    # @option options [<String>] :predicates (ALL_PREDICATES) white-listed predicates
    # @option options [Proc] :coerce coercion for the value
    # @option options [Hash{Symbol => any}] :validates for the value
    #   @example
    #     validates: presence: true, length: { is: 6 }
    #
    def initialize(name, options = {})
      options.assert_valid_keys(:as, :on, :predicates, :coerce, :validates)
      @as = options.fetch(:as, name).to_s
      @name = name.to_s
      @on = options[:on]
      @predicates = Array(options.fetch(:predicates, FilterPredicates.all)).map(&:to_s)
      @coerce = options.fetch(:coerce, ->(v) { v })
      @validations = options.fetch(:validates, {})
    end

    # If two parameters have the same name, they are equal.
    delegate :hash, to: :name

    def eql?(other)
      other.is_a?(self.class) && other.name == name
    end

    def ==(other)
      other.is_a?(self.class) &&
        other.name == name &&
        other.as == as &&
        other.on == on &&
        other.predicates == predicates
    end

    # @param [any] value
    # @return [any] coerced value according the definition
    #
    def coerce(value)
      @coerce.call(value)
    end

    def validator
      FilterValueValidator.build(self)
    end

    def defined?
      true
    end

    def undefined?
      !self.defined?
    end

    # Proc with defined validations
    # @return [Proc]
    # @api private
    attr_reader :validations
  end
end
