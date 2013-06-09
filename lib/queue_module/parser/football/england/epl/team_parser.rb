module QueueModule
  module Parser
    module Football
      module England
        module EPL
          class TeamParser < QueueModule::Parser::Parser
            register self.name

            def parse page, domain = nil
              result = {}
              table  = page.search ".contentTable tbody"
              table.search("tr").each do |tr|
                name     = tr.search("td.player-squadno a")
                position = tr.search("td.player-position").text

                result[tr.search("td.player-squadno span").text.to_i] = {
                    :name     => name.text,
                    :position => position,
                    :link     => domain + name[0][:href]
                }
              end
              result
            end

          end
        end
      end
    end
  end
end