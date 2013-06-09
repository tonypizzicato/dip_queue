module QueueModule
  module Parser
    module Football
      module England
        module EPL
          class PlayerParser < QueueModule::Parser::Parser
            register self.name

            def parse page, domain = nil
              result = nil
              name   = page.search(".hero-name .name").text
              profile = page.search('.playerprofileoverview')
              unless profile.empty?
                begin
                  birth = Date.parse profile.search('table tr:eq(2) td:eq(2)').text
                rescue
                  birth = nil
                end
                height  = profile.search('table tr:eq(2) td:eq(4)').text.chomp "m"
                age     = profile.search('table tr:eq(3) td:eq(2)').text
                weight  = profile.search('table tr:eq(3) td:eq(4)').text.chomp "kg"
                country = profile.search('table tr:eq(4) td:eq(2)').text
                result  = {
                    :name    => name,
                    :birth   => birth,
                    :height  => height.to_f > 0 ? height.to_f : nil,
                    :age     => age.to_i > 0 ? age.to_i : nil,
                    :weight  => weight.to_i > 0 ? weight.to_i : nil,
                    :country => country.length > 1 ? country : nil
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