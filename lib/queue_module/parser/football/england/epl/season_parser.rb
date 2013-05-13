module QueueModule
  module Parser
    module Football
      module England
        module EPL
          class SeasonParser < QueueModule::Parser::Parser
            register self.name

            def parse page, domain
              result = []
              form = page.form_with(:id => 'fixture-search')
              path = domain + form.action
              p path
              form.field("paramSeason").options.each do |option|
                result.push(path + "?paramSeason=" + option.value) if /\d{4,4}\-\d{4,4}/ =~ option.value
              end
              result
            end

          end
        end
      end
    end
  end
end