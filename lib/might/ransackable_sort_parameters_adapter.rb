# frozen_string_literal: true
module Might
  # Converts array of parameters to hash familiar to ransack gem
  #
  class RansackableSortParametersAdapter
    def initialize(app)
      @app = app
    end

    def call(env)
      scope, params = env

      ransackable_parameters = Array(params[:sort]).map do |parameter|
        "#{parameter.name} #{parameter.direction}"
      end

      app.call([scope, params.merge(sort: ransackable_parameters)])
    end

    private

    attr_reader :app
  end
end
