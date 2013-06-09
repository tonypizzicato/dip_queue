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
            team      = Team.find task.data[:team]
            team.name = result[:club]
            if result[:squad].empty?
              team.done = true
              set_ready team, :GetMatchInfo
              set_ready team, :GetMatchLineups
            else
              result[:squad].each do |player_data|
                player = Player.where(name: player_data[:name], team: team).first
                unless player
                  player = Player.new name: player_data[:name], team: team, done: false
                  player.save
                  team.players.push({id: player._id, number: player_data[:number].to_i, position: player_data[:position]})
                end
                player_data[:player_id] = player._id
              end
              set_tasks task, result[:squad], :GetPlayer
            end
            team.save
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

        def set_ready team, unit
          pla_cnt = Player.where(:done => true, :team => team).count
          p "Players for " + team.name + " grabbed " + pla_cnt.to_s + " of " + team.players.size.to_s
          if pla_cnt == team.players.size
            team.update_attribute :done, true

            p "Players for team " + team.name + " grabbed"

            teams = Team.where(:done => true).ne('_id' => team._id)
            p "Teams grabbed " + teams.size.to_s
            p "UNIT " + unit.to_s
            task = ::Task.where(:unit => unit).first
            teams.each do |against|
              TaskQueue.any_of(
                  {:type => task, 'data.home' => team.alias, 'data.away' => against.alias, :status => TaskQueue::QUEUE_STATUS_WAITING},
                  {:type => task, 'data.away' => team.alias, 'data.home' => against.alias, :status => TaskQueue::QUEUE_STATUS_WAITING}
              ).update_all :status => TaskQueue::QUEUE_STATUS_READY
            end
          else
            p "Not all players grabbed for " + team.name
          end
        end

        def before
          Rails.logger.info "BEFORE PERFORM"
        end
      end
    end
  end
end