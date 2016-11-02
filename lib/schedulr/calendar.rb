require 'schedulr/event'
class Calendar
  def event(startTime, endTime, activity)
    events = Event.create(startTime, endTime, activity)
    events.map {|x| add_event(x)}
  end

  def add_event(event)
    eventDay = Time.new(event.startTime.year, event.startTime.month, event.startTime.day)
    day = @days.find {|x| x.time == eventDay}
    if day.nil?
      day = Day.new(eventDay)
      @days << day
    end

    day.add_event(event)
  end

  def day_of(time)
    day = @days.find {|x| x.time == time}
    if day then day else Day.new(time) end
  end

  def initialize
    @days = []
  end
end