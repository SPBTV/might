module Might
  class RansackableFilter
    # @param app [#call]
    def initialize(app)
      @app = app
    end

    # @param env [<ActiveRecord::Relation, Hash]
    #   * first element is a scope to be filtered
    #   * second is a hash with user provided filters
    # @return [<ActiveRecord::Relation, Hash]
    #
    def call(env)
      scope, params = env
      filtered_scope = scope.ransack(params[:filter]).result
      app.call([filtered_scope, params])
    end

    private

    attr_reader :app
  end
end
