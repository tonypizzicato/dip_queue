module QueueModule
  module Parser
    module Football
      module England
        module EPL
          class MatchInfoParser < QueueModule::Parser::Parser
            register self.name

            def parse page
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
              table = page.search(".statsTable")
              table.search("thead tr").each do |tr|
                tr.search("th:not(:first-child)").each_with_index.map do |th, j|
                  result[:stats][:home][th.text.to_sym] = tr.parent.parent.search("tbody td:eq(#{j + 1})")[0].text.to_i
                  result[:stats][:away][th.text.to_sym] = tr.parent.parent.search("tbody td:eq(#{j + 1})")[1].text.to_i
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