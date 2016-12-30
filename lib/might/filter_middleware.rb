# frozen_string_literal: true
module Might
  # Filter scope using ransack gem
  #
  class FilterMiddleware
    # @param app [#call, Proc]
    #
    def initialize(app)
      @app = app
    end

    def call(env)
      scope, = ::Middleware::Builder.new do |b|
        b.use RansackableFilterParametersAdapter
        b.use RansackableFilter
      end.call(env)

      app.call([scope, env[1]])
    end

    private

    attr_reader :app
  end
end
