#!/usr/bin/env ruby

require "daemons"

root = File.expand_path(File.dirname(__FILE__))
root = File.dirname(root) until File.exists?(File.join(root, 'config'))
Dir.chdir(root)

require File.join(root, "config", "environment.rb")

running = true

SIGNAL = (RUBY_PLATFORM =~ /win32/ ? 'KILL' : 'TERM')

trap(SIGNAL) {
  running = false
}

threads_count    = 10
tasks_for_thread = 2
while running do
  Rails.logger.info "This daemon is still running at #{Time.now}.\n"
  Rails.logger.info "Start parsing"
  threads = []
  threads_count.times do
    tasks = TaskQueue.deque tasks_for_thread
    threads << Thread.new(tasks) do |tasks_to_run|
      tasks_to_run.each do |task|
        if task
          begin
            unit = QueueModule::Manager::get_unit task
            Rails.logger.info "Unit type: #{unit.class.name}"
            handler = QueueModule::Manager::get_handler task
            unit.add_observer handler
            result = unit.perform
            Rails.logger.info "Result: " + result.to_s
          rescue Exception => e
            Rails.logger.error "Exception raised: " + e.message
            Rails.logger.error "Exception backtrace: " + e.backtrace.to_s
            task.set_ready
          end
        else
          Rails.logger.info "No task found"
          sleep 3
        end
      end
    end
  end
  threads.each { |thr| thr.join }
  Rails.logger.info "End parsing"
  sleep 3
end