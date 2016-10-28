class Event
  attr_accessor :startTime
  attr_accessor :endTime
  attr_accessor :activity

  def initialize(startTime, endTime, activity)
    @startTime = startTime
    @endTime = endTime
    @activity = activity
  end
end

def Event.create(startTime, endTime, activity)
  events = []
  while startTime.day < endTime.day
    dayEndTime = Time.new(endTime.year, endTime.month, endTime.day+1, 23, 59, 59)
    events << Event.new(startTime, dayEndTime, activity)
    startTime = Time.new(startTime.year, startTime.month, startTime.day+1)
  end

  events << Event.new(startTime, endTime, activity)
end