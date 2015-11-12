require_relative 'value_validator'

module MightyFetcher
  module Sort
    # Sorting parameter definition
    #
    class ParameterDefinition
      # @return [String]
      attr_reader :name

      # If the property name doesn't match the name in the query string, use the :as option
      # @return [String]
      attr_reader :as

      # @return [Boolean]
      attr_reader :reverse_direction

      # @param [String] name of the field
      # @param [String] as (#name) alias for the property
      # @param [Boolean] reverse_direction (false) default sorting direction
      #
      def initialize(name, as: name, reverse_direction: false)
        @name = name.to_s
        @as = as.to_s
        @reverse_direction = reverse_direction
      end

      # If two parameters have the same name, they are equal.
      delegate :hash, to: :name

      def eql?(other)
        other.is_a?(self.class) && other.name == name
      end

      def ==(other)
        other.is_a?(self.class) &&
          other.name == name &&
          other.as == as
      end

      def reverse_direction?
        @reverse_direction
      end

      def validator
        ValueValidator.build(self).new
      end

      def defined?
        true
      end

      def undefined?
        !self.defined?
      end
    end
  end
end
