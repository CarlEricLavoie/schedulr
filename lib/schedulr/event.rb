require 'schedulr/pretty_print'

class Event
  attr_accessor :startTime
  attr_accessor :endTime
  attr_accessor :activity

  def p_print
    p_puts "", '.'
    p_puts ""
    p_puts "#{activity.name.capitalize}"
    p_puts "from #{startTime.strftime("%H:%M")} to #{endTime.strftime("%H:%M")}"
    p_puts ""
  end

  def initialize(startTime, endTime, activity)
    @startTime = startTime
    @endTime = endTime
    @activity = activity
  end
end

def Event.create(startTime, endTime, activity)
  events = []
  while startTime.day < endTime.day
    events << Event.new(startTime, endTime, activity)
    startTime = Time.new(startTime.year, startTime.month, startTime.day+1)
  end

  events << Event.new(startTime, endTime, activity)
end