require 'schedulr/pretty_print'

class Event
  attr_accessor :startTime
  attr_accessor :endTime
  attr_accessor :activity

  def p_print
    p_puts ""
    p_puts "start:#{startTime.strftime("%H:%M:%S")}"
    p_puts "end:#{endTime.strftime("%H:%M:%S")}"
    p_puts "activity:#{activity.name}"
  end
end