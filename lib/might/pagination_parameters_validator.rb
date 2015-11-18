require 'active_support/concern'
require 'active_support/core_ext/module/delegation'
require 'active_support/callbacks'
require 'active_model/naming'
require 'active_model/validator'
require 'active_model/callbacks'
require 'active_model/translation'
require 'active_model/errors'
require 'active_model/validations'

module Might
  #
  class PaginationParametersValidator
    # Validates pagination parameters
    # @param [Hash, nil] page
    # @option page [Number, nil] :limit
    # @option page [Number, nil] :offset
    #
    Validator = Struct.new(:page) do
      include ActiveModel::Validations

      validate :page_is_a_hash
      validates :limit, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
      validates :offset, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true

      def page_is_a_hash
        return if page.is_a?(Hash) || page.nil?
        errors.add(:page, :invalid_page_type)
      end

      def limit
        page[:limit] if page.is_a?(Hash)
      end

      def offset
        page[:offset] if page.is_a?(Hash)
      end
    end

    def initialize(app)
      @app = app
    end

    def call(env)
      params, errors = env

      validator = Validator.new(params[:page]).tap(&:validate)
      messages = validator.errors.full_messages

      app.call([params, errors.concat(messages)])
    end

    attr_reader :app
  end
end
