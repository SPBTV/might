module MightyFetcher
  module Sort
    module Ransackable
      # Sort scope
      class Sort
        # @param app [#call]
        def initialize(app)
          @app = app
        end

        # @param env [<ActiveRecord::Relation, <String>]
        #   * first element is a scope to be sorted
        #   * second is a array with user provided sortings
        # @return [<ActiveRecord::Relation, <String>]
        #
        def call(env)
          scope, params = env

          ransackable_query = scope.ransack
          ransackable_query.sorts = params

          app.call([ransackable_query.result, params])
        end

        private

        attr_reader :app
      end
    end
  end
end
