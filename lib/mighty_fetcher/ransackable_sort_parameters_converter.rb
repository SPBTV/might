module MightyFetcher
  # Converts array of parameters to hash familiar to ransack gem
  #
  class RansackableSortParametersConverter
    def initialize(app)
      @app = app
    end

    def call(env)
      scope, parameters = env

      ransackable_parameters = Array(parameters).map do |parameter|
        "#{parameter.name} #{parameter.direction}"
      end

      app.call([scope, ransackable_parameters])
    end

    private

    attr_reader :app
  end
end
