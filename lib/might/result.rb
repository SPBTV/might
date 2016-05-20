module Might
  # Marker module
  module Result
  end

  # Represents fetching failure
  class Failure
    include Result

    # @param errors [<String>]
    def initialize(errors)
      @errors = errors
    end

    # @param errors [<String>]
    attr_reader :errors

    # @return [true]
    def failure?
      !success?
    end

    # @return [false]
    def success?
      false
    end

    # @raise [NotImplementedError]
    def get
      fail NotImplementedError, <<-MESSAGE.strip_heredoc
        #{self.class} does not respond to #get. You should explicitly check for
        #success? before calling #get.
      MESSAGE
    end

    # @yield given block
    def get_or_else
      yield
    end
  end

  # Represents fetching success
  class Success
    include Result

    # @param value [ActiveRecord::Relation]
    def initialize(value)
      @value = value
    end

    # @return [false]
    def failure?
      !success?
    end

    # @return [true]
    def success?
      true
    end

    # @return [ActiveRecord::Relation]
    def get
      @value
    end

    # @return [ActiveRecord::Relation]
    def get_or_else
      @value
    end
  end
end
