#!/usr/bin/env ruby

root = File.expand_path(File.dirname(__FILE__))
root = File.dirname(root) until File.exists?(File.join(root, 'config'))
Dir.chdir(root)

require File.join(root, "config", "environment.rb")

tasks_desc = Task.all
manager = QueueModule::Manager.new Hash[tasks_desc.map { |task| [task.type, task.unit] }]

loop do

  Rails.logger.info "This daemon is still running at #{Time.now}.\n"
  Rails.logger.info "Start parsing"
  begin
    task = TaskQueue.deque
    if task
      unit = manager.get_unit task
      handler = manager.get_handler task
      unit.add_observer handler
      result = unit.perform
      if task.set_ready
      end
      Rails.logger.info result
    else
      Rails.logger.info "No task found"
      #sleep 3
    end
  rescue Exception => e
    Rails.logger.error e.message
    Rails.logger.error e.backtrace
    if task
      task.set_ready
    end
  end
  Rails.logger.info "End parsing"
  sleep 3
end
