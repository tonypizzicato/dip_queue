module QueueModule
  module Unit
    module Handler
      module GetPlayerHandler
        def update(event_type, task, result, sender)
          if event_type == Task::EVENT_AFTER
            after task, result, sender.last_exception
          else
            before
          end
        end

        def after(task, result, exception)
          if exception.nil?
            player = Player.find task.data[:id]
            unless result.nil?
              country        = Country.where(:title => result[:country]).first
              player.name    = result[:name]
              player.birth   = result[:birth]
              player.height  = result[:height]
              player.age     = result[:age]
              player.weight  = result[:weight]
              player.country = country.nil? ? Country.create(:title => result[:country]) : country
              player.team    = Team.find task.data[:team]
            else
              p "PLAYER PROFILE REDIRECTED " + player.name
            end
            player.done = true
            player.save
            task.delete
          else
            task.status = TaskQueue::QUEUE_STATUS_DELAYED
            task.save
            Rails.logger.info "Exception raised: " + exception.to_s
            Rails.logger.info "Exception backtrace: " + exception.backtrace.to_s
          end
        end

        def before
          Rails.logger.info "BEFORE PERFORM"
        end
      end
    end
  end
end