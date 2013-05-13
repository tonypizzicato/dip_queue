module QueueModule
  class Manager

    class << self
      def get_unit(task)
        unit_name = task.type.unit + "Task"
        class_object = QueueModule::Unit.const_get unit_name
        unit = QueueModule::Unit::Task.new task, class_object
        unit.set_parser parser(unit_name, task)
      end

      def get_handler(task)
        handler_name = task.type.unit + "Handler"
        class_object = QueueModule::Unit::Handler.const_get handler_name
        QueueModule::Unit::Handler::Base.new class_object
      end

      def parser(unit_name, task)
        league = League.find(task.data[:league])
        name = unit_name.match(/Get(\w+)Task/).captures.first + "Parser"
        const = QueueModule::Parser.const_get(league.sport.title).const_get(league.country.title).const_get(league.alias.upcase).const_get(name)
        Parser::Parser.create const
      end
    end
  end
end