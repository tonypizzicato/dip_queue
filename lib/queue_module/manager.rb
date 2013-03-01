module QueueModule
  class Manager
    def initialize(types)
      @task_types = types
    end

    def get_unit(task)
      unit_name = @task_types[task.type] + "Task"
      class_object = QueueModule::Unit.const_get unit_name
      QueueModule::Unit::Task.new task, class_object
    end

    def get_handler(task)
      handler_name = @task_types[task.type] + "Handler"
      class_object = QueueModule::Unit::Handler::Base.const_get handler_name
      QueueModule::Unit::Handler::Base.new class_object
    end
  end
end