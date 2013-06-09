module QueueModule
  module Parser
    module Football
      module England
        module EPL
          class MatchInfoParser < QueueModule::Parser::Parser
            register self.name

            def parse page, domain = nil
              result = {
                  :clubs => {
                      :home => page.search(".club.home").text,
                      :away => page.search(".club.away").text
                  },
                  :stats => {
                      :home => Hash[],
                      :away => Hash[]
                  }
              }
              table = page.search(".contentTable")
              table.search("thead tr").each do |tr|
                tr.search("th:not(:first-child)").each_with_index.map do |th, j|
                  result[:stats][:home][th.text.to_sym] = tr.parent.parent.search("tbody tr:eq(1) td:eq(#{j + 1})").text.to_i
                  result[:stats][:away][th.text.to_sym] = tr.parent.parent.search("tbody tr:eq(2) td:eq(#{j + 1})").text.to_i
                end
              end
              result
            end

          end
        end
      end
    end
  end
end