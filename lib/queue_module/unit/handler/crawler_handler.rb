module QueueModule
  module Unit
    module Handler
      module CrawlerHandler
        def update(event_type, task, sender)
          if event_type == Task::EVENT_AFTER
            after task
          end
        end

        def after(task)

        end
      end
    end
  end
end