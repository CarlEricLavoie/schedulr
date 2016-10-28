class Day
  attr_accessor :time
  attr_accessor :name
  attr_accessor :events

  def addEvent(event)
    @events << event
  end

  def initialize(time)
    @events = []
    @name = time.strftime("%A, %d/%m/%Y")
    @time = Time.new(time.year, time.month, time.day)
  end
end