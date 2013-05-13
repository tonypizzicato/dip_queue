module QueueModule
  module Unit
    module Handler
      module GetMatchInfoHandler
        def update(event_type, task, result, sender)
          if event_type == Task::EVENT_AFTER
            after task, result, sender.last_exception
          else
            before
          end
        end

        def after(task, result, exception)
          Rails.logger.info "AFTER PERFORM"
          if exception.nil?
          else
            Rails.logger.info "Handler. Exception: " + exception.to_s
            Rails.logger.info "Handler. Backtrace: " + exception.backtrace.to_s
          end
        end

        def before
          Rails.logger.info "BEFORE PERFORM"
        end
      end
    end
  end
end