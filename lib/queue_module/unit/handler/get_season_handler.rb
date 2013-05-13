module QueueModule
  module Unit
    module Handler
      module GetSeasonHandler
        def update(event_type, task, result, sender)
          if event_type == Task::EVENT_AFTER
            after task, result, sender.last_exception
          else
            before
          end
        end

        def after(task, result, exception)
          if exception.nil?
            result.each do |url|
              new_task = TaskQueue.new
              new_task.data[:url] = url
              new_task.data[:league] = task.data[:league]
              new_task.type = ::Task.where(:type => 2).first
              new_task.save
              task.status = TaskQueue::QUEUE_STATUS_FINISHED
              task.save
            end
          else
            Rails.logger.info exception.to_s
            Rails.logger.info exception.backtrace
          end
        end

        def before
          Rails.logger.info "BEFORE PERFORM"
        end
      end
    end
  end
end