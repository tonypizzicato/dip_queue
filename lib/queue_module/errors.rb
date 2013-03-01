module QueueModule
  module Errors

    exceptions = %w[ PageHasNoTargetError ]

    exceptions.each { |e| const_set(e, Class.new(StandardError)) }

  end
end