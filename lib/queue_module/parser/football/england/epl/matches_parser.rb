module QueueModule
  module Parser
    module Football
      module England
        module EPL
          class MatchesParser < QueueModule::Parser::Parser
            register self.name

            def parse page, domain
              page.search("td.score a").map do |link|
                Rails.logger.info link[:href]
                domain + link[:href].gsub(/preview|report/, "stats")
              end
            end

          end
        end
      end
    end
  end
end