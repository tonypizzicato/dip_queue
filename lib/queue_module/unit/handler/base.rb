module QueueModule
  module Unit
    module Handler
      class Base
        def initialize(handler)
          singleton = class << self;
            self
          end
          singleton.send :include, handler
        end
      end
    end
  end
end