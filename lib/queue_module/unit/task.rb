module QueueModule
  module Unit
    class Task

      EVENT_BEFORE = 0
      EVENT_AFTER = 1

      include ::Observable

      attr_accessor :last_exception

      def initialize(task_data, unit)
        singleton = class << self;
          self
        end

        singleton.send :include, unit
        singleton.send :add_hooks, :perform
        @task = task_data
        @last_exception = nil
      end

      def set_parser parser
        @parser = parser
        self
      end

      def before_method
        changed
        notify_observers(EVENT_BEFORE, @task, nil, self)
      end

      def after_method result
        changed
        notify_observers(EVENT_AFTER, @task, result, self)
      end

      private

      def self.add_hooks name
        if self.method_defined? name
          self.send :alias_method, :sub_method, name
          self.send :undef_method, name
          self.send :define_method, name do
            before_method
            result = self.send :sub_method
            after_method result
            result
          end
        end
      end
    end
  end
end