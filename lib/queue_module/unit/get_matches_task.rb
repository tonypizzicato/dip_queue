module QueueModule
  module Unit
    module GetMatchesTask
      def perform
        begin
          agent = Mechanize.new do |a|
            a.log = Logger.new "log/mech.log"
            a.user_agent_alias = "Mac Safari"
            a.read_timeout = 5
            a.open_timeout = 5
            a.idle_timeout = 1
            a.keep_alive = false
            a.pre_connect_hooks << Proc.new { Rails.logger.info "pre connect"; p "pre connect" }
            a.post_connect_hooks << Proc.new { Rails.logger.info "post connect"; p "post connect" }
          end
          Rails.logger.info @task.data[:url]
          page = agent.get @task.data[:url]
          Rails.logger.info "Got page"
          domain = domain @task.data[:url]
          result = @parser.parse page, domain
        rescue Exception => e
          @last_exception = e
          result = false
        end
        result
      end

      private

      def domain page
        parsed = URI.parse(page)
        scheme = (parsed.scheme.nil? ? "http" : parsed.scheme) + "://"
        scheme + parsed.host.downcase
      end
    end
  end
end