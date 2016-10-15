require 'schedulr/event'
class Calendar
  def event(startTime, endTime, activity)
    events = Event.create(startTime, endTime, activity)
    events.map {|x| addEvent(x)}
  end

  def addEvent(event)
    eventDay = Time.new(event.startTime.year, event.startTime.month, event.startTime.day)
    day = @days.find {|x| x.time == eventDay}
    if day.nil?
      day = Day.new(eventDay)
      @days << day
    end

    day.addEvent(event)
  end

  def getDay(time)
    @days.find {|x| x.time == time}
  end

  def initialize
    @days = []
  end
end