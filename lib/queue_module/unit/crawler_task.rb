module QueueModule
  module Unit
    module CrawlerTask
      def perform
        begin
          agent = Mechanize.new
          agent.log = Logger.new "mech.log"
          page = agent.get @task.data[:url]
          link = page.search "div[widget='fixturelistbroadcasters']"
          if link.first
            link.first[:href]
          else
            raise Errors::PageHasNoTargetError.new "No match stats link found"
          end
        rescue
          #  delay task
        end
      end
    end
  end
end