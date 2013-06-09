module QueueModule
  module Parser
    module Football
      module England
        module EPL
          class MatchesParser < QueueModule::Parser::Parser
            register self.name

            def parse page, domain = nil
              result = {
                  :stats   => [],
                  :lineups => []
              }
              tables = page.search("[widget='fixturelistbroadcasters'] .contentTable")
              tables.each do |table|
                table.search("tr:not(:eq(1))").each do |tr|
                  unless tr.search(".score").empty?
                    link = tr.search(".score a")[0][:href]
                    result[:stats].push({
                                            :time     => tr.search(".time").text,
                                            :link     => domain + link.gsub(/(match-preview)|(match-report)/, "match-stats"),
                                            :home     => tr.search(".rHome").text.strip,
                                            :away     => tr.search(".rAway").text.strip,
                                            :location => tr.search(".location").text.strip
                                        }) unless tr.search(".score").empty?

                    result[:lineups].push({
                                              :time     => tr.search(".time").text,
                                              :link     => domain + link.gsub(/(match-preview)/, "teams"),
                                              :home     => tr.search(".rHome").text.strip,
                                              :away     => tr.search(".rAway").text.strip,
                                              :location => tr.search(".location").text.strip
                                          })
                  end
                end
                result[:teams] = get_teams page, domain
              end
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