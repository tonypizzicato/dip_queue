module QueueModule
  module Unit
    module Handler
      module GetSquadHandler
        def update(event_type, task, result, sender)
          if event_type == Task::EVENT_AFTER
            after task, result, sender.last_exception
          else
            before
          end
        end

        def after(task, result, exception)
          if exception.nil?
            team = Team.find task.data[:team]
            result[:squad].each do |player_data|
              player = Player.where(name: player_data[:name], team: team).first
              unless player
                player = Player.new name: player_data[:name], team: team, done: false
                player.save
                team.players.push({id: player._id, number: player_data[:number].to_i, position: player_data[:position]})
              end
              player_data[:player_id] = player._id
            end
            team.name = result[:club]
            team.save
            set_tasks task, result[:squad], :GetPlayer
          else
            Rails.logger.info "Exception raised: " + exception.to_s
            Rails.logger.info "Exception backtrace: " + exception.backtrace.to_s
          end
          task.status = TaskQueue::QUEUE_STATUS_DELAYED
          task.save
        end

        def set_tasks task, set, type
          tasks   = []
          type_id = ::Task.where(:unit => type).first._id
          set.each do |player|
            player_object = Player.find player[:player_id]
            unless player[:link].nil? || player_object.done
              new_task = {
                  :type_id => type_id,
                  :status  => TaskQueue::QUEUE_STATUS_READY,
                  :data    => {
                      :id     => player[:player_id],
                      :url    => player[:link],
                      :league => task.data[:league],
                      :team   => task.data[:team]
                  }
              }
              tasks << new_task
            else
              p "NO PLAYER PROFILE LINK " + player_object.name
              player_object.done = true
              player_object.save
            end
          end
          TaskQueue.create tasks if tasks.size
        end

        def before
          Rails.logger.info "BEFORE PERFORM"
        end
      end
    end
  end
end