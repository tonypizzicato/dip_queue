module QueueModule
  module Unit
    module GetSeasonTask
      def perform
        begin
          agent = Mechanize.new
          agent.log = Logger.new "log/mech.log"
          page = agent.get @task.data[:url]
          Rails.logger.info page.canonical_uri
          result = @parser.parse page, domain(@task.data[:url])
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