module MightyFetcher
  module Filter
    module Ransackable
      # Filter scope
      class Filter
        # @param app [#call]
        def initialize(app)
          @app = app
        end

        # @param env [<ActiveRecord::Relation, <MightyFetcher::Filter::Parameter>>]
        #   * first element is a scope to be filtered
        #   * second is a hash with user provided filters
        # @return [<ActiveRecord::Relation, <MightyFetcher::Filter::Parameter>]
        #
        def call(env)
          scope, filters = env
          filtered_scope = scope.ransack(filters).result
          app.call([filtered_scope, filters])
        end

        private

        attr_reader :app
      end
    end
  end
end
