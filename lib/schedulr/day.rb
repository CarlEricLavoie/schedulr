class Day
  attr_accessor :time
  attr_accessor :name
  attr_accessor :events

  @@p_print_width = 60
  def p_print
    p_puts ""
    p_puts "#{@name}"
    @events.each do |event|
      event.p_print
    end
  end

  def addEvent(event)
    @events << event
  end

  def initialize(time)
    @events = []
    @name = time.strftime("%A, %d/%m/%Y")
    @time = Time.new(time.year, time.month, time.day)
  end
end