module QueueModule
  module Parser
    class Parser
      @@subclasses = {}

      def self.extended(base)
        puts "extended object #{base.inspect}"
      end

      def self.create type
        c = @@subclasses[type.to_s]
        if c
          c.new
        else
          raise "Parser of type \"#{type}\" is not registered."
        end
      end

      def self.register name
        @@subclasses[name] = self
      end

      def class_name
        self.class
      end

      def parse page, domain = nil

      end
    end
  end
end