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
            set_ready player.team, :GetMatchInfo
            set_ready player.team, :GetMatchLineups
            task.delete
            p "Player " + player.name + " grabbed for " + player.team.name
          else
            task.status = TaskQueue::QUEUE_STATUS_DELAYED
            task.save
            Rails.logger.info "Exception raised: " + exception.to_s
            Rails.logger.info "Exception backtrace: " + exception.backtrace.to_s
          end
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