#!/usr/bin/env ruby

# You might want to change this
ENV["RAILS_ENV"] ||= "production"

root = File.expand_path(File.dirname(__FILE__))
root = File.dirname(root) until File.exists?(File.join(root, 'config'))
Dir.chdir(root)

require File.join(root, "config", "environment")

$running = true
Signal.trap("TERM") do 
  $running = false
end

while($running) do
  
  # Replace this with your code
  Rails.logger.info "This daemon is still running at #{Time.now}.\n"

  raw = RestClient.get("http://www.premierleague.com/content/premierleague/en-gb/matchday/matches/2012-2013/epl.match-report.html/man-city-vs-liverpool")
  html = Nokogiri::HTML(raw)
  Rails.logger.info "Start parsing"
  Rails.logger.info html.css("ul.idx li.stats a")[0]["href"]

  sleep 3
end
