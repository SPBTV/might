# frozen_string_literal: true
module Might
  # Sorting parameter definition
  #
  class SortParameterDefinition
    # If the property name doesn't match the name in the query string, use the :as option
    # @return [String]
    attr_reader :as

    # @return [Boolean]
    attr_reader :reverse_direction

    # @param [String, Proc] name of the field
    # @param [String] as (#name) alias for the property
    # @param [Boolean] reverse_direction (false) default sorting direction
    #
    def initialize(name, as: nil, reverse_direction: false)
      @name = name
      fail ArgumentError, 'as: parameter must be given if name is a Proc' if name.is_a?(Proc) && as.nil?
      @as = (as || name).to_s
      @reverse_direction = reverse_direction
    end

    # If two parameters have the same name, they are equal.
    delegate :hash, to: :as

    def eql?(other)
      other.is_a?(self.class) && other.as == as
    end

    # @param params [{}]
    # @return [String]
    def name(params)
      if @name.is_a?(Proc)
        @name.call(params)
      else
        @name
      end
    end

    def ==(other)
      other.is_a?(self.class) && other.as == as
    end

    alias reverse_direction? reverse_direction

    def validator
      SortValueValidator.build(self).new
    end

    def defined?
      true
    end

    def undefined?
      !self.defined?
    end
  end
end
