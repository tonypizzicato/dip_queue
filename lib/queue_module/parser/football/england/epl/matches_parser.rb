module QueueModule
  module Parser
    module Football
      module England
        module EPL
          class MatchesParser < QueueModule::Parser::Parser
            register self.name

            def parse page, domain = nil
              result = {
                  :stats => [],
                  :lineups => []
              }
              page.search("td.score a").each do |link|
                result[:stats].push(domain + link[:href].gsub(/(match-preview)|(match-report)/, "match-stats"))
                result[:lineups].push(domain + link[:href].gsub(/(match-preview)/, "teams"))
              end
              result[:teams] = get_teams page, domain
              result
            end

            def get_teams page, domain
              teams = {}
              page.search(".clubs.rHome a").each do |link|
                teams[link.text] = domain + link[:href].gsub(/(overview)/, "squads")
              end
              teams.each do |_, url|
                url.gsub /(overview)/, "squads"
              end
            end

          end
        end
      end
    end
  end
end