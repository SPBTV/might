require_relative 'fetcher_error'

module Might
  # Common validation error
  #
  class ValidationError < FetcherError
    require 'active_support/core_ext/array/wrap'

    # @param messages [String, <String>]
    def initialize(messages)
      @messages = Array.wrap(messages)
    end

    def message
      @messages.join(', ')
    end
  end

  PaginationValidationFailed = Class.new(ValidationError)
end
