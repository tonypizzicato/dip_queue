module QueueModule
  module Unit
    module Handler
      module GetMatchesHandler
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
            set_tasks task, result[:stats], :GetMatchInfo
            set_tasks task, result[:lineups], :GetMatchLineups
            set_teams_tasks task, result[:teams], :GetSquad
            task.status = TaskQueue::QUEUE_STATUS_DELAYED
          else
            Rails.logger.info "Handler. Exception: " + exception.to_s
            Rails.logger.info "Handler. Backtrace: " + exception.backtrace.to_s
            task.status = TaskQueue::QUEUE_STATUS_READY
          end
          task.save
        end

        def set_tasks task, set, type
          tasks   = []
          type_id = ::Task.where(:unit => type).first._id
          set.each do |match|
            new_task = {
                :type_id => type_id,
                :status  => TaskQueue::QUEUE_STATUS_WAITING,
                :data    => {
                    :url      => match[:link],
                    :time     => match[:time],
                    :home     => match[:home],
                    :away     => match[:away],
                    :location => match[:location],
                    :league   => task.data[:league]
                }
            }
            tasks << set_util_info(new_task)
          end
          p "INSER " + tasks.size.to_s + " tasks unit " + type.to_s
          TaskQueue.collection.insert tasks unless tasks.empty?
        end

        def set_teams_tasks task, teams, type
          tasks   = []
          type_id = ::Task.where(:unit => type).cache.first._id
          teams.each do |team_title, url|
            unless Team.where(alias: team_title, league: task.data[:league]).exists?
              team         = Team.new
              team.alias   = team_title
              team.league  = League.find(task.data[:league])
              team.players = []
              team.done    = false
              team.upsert

              new_task = {
                  :type_id => type_id,
                  :status  => TaskQueue::QUEUE_STATUS_READY,
                  :data    => {
                      :url    => url,
                      :league => task.data[:league],
                      :team   => Team.find_by(alias: team.alias)._id
                  }
              }
              tasks << set_util_info(new_task)
            end
          end
          p "INSERT " + tasks.size.to_s + " tasks unit " + type.to_s
          TaskQueue.collection.insert tasks unless tasks.empty?
        end

        def set_util_info task
          type              = ::Task.find(task[:type_id])
          task[:created_at] = task[:updated_at] = Time.now
          task[:attempts]   = 0
          task[:priority]   = type.priority
          task
        end

        def before
          Rails.logger.info "BEFORE PERFORM"
        end
      end
    end
  end
end