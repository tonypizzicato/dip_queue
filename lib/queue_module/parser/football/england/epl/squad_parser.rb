module QueueModule
  module Parser
    module Football
      module England
        module EPL
          class SquadParser < QueueModule::Parser::Parser
            register self.name

            def parse page, domain = nil
              result = {
                  :club  => page.search(".clubheader .noborder").text,
                  :squad => []
              }
              table  = page.search ".clubsquadlists .contentTable tbody"
              table.search("tr").each do |tr|
                name     = tr.search("td.player-squadno a")
                name     = name.size > 0 ? name : tr.search("td.player-squadno")
                position = tr.search("td.player-position").text
                link     = name.search('a').size > 0 ? (domain + name[0][:href]) : nil
                name     = name.text.gsub(/\s+[\d\r\t\n\.]+\s+/, "")

                result[:squad].push({
                                        :name     => name,
                                        :position => position,
                                        :link     => link,
                                        :number   => tr.search("td.player-squadno span").text.to_i
                                    })
              end
              result
            end

          end
        end
      end
    end
  end
end