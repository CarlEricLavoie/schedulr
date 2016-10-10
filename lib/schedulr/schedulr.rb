require 'schedulr/log_entry'

module Schedulr

  attr_accessor :time_now

  def self.load(name)
    @name = name
    open(name, 'a')
    open(name, 'r+') do |f|
      f.each_line do |line|
        load_line(line)
      end
    end
    nil
  end

  def self.load_between(name, t_begin, t_end)
    @name = name
    @activities = []

    open(name, 'a')
    open(name, 'r+') do |f|
      f.each_line do |line|
        log = LogEntry.from(line)

        load_line line if log.date > t_begin && log.date < t_end
      end
    end
    nil
  end

  def self.load_line(line)
    log = LogEntry.from(line)

    @time_now = Proc.new { log.date }
    send(log.cmd, *log.args, false)
  end

  def self.rename(activity_id, activity_name, save)
    activity_id = activity_id.to_i

    save ("rename", [activity_id, activity_name]) if save
    activity = @activities.find do |activity|
      activity.id == activity_id
    end
    activity.name = activity_name
  end

  def self.save(command, args)
    open(@name, 'a') do |f|
      f.puts "{{#{Time.now.to_i}}}{{#{command}}}{{#{args}}}"
    end
  end

  def self.add(activity, save)
    save ("add", [activity]) if save
    @activities = Array.new if @activities.nil?
    @activities << Activity.new(activity)
  end

  def self.list()
    puts @activities
  end

  def self.day(name)
    now = Time.now
    d_end = Time.new(now.year, now.month, now.day)
    d_begin = Time.new(now.year-200, now.month, now.day)
    @current_day = Day.new(d_end)
    load_between(name, d_begin, d_end)

    d_begin = d_end
    d_end += (24*60*60)
    @current_day = Day.new(d_begin)
    load_between(name, d_begin, d_end)
    @current_day.p_print if @current_day
  end

  def self.get (activity_id)
    activity_id = activity_id.to_i
    @activities.find do |activity|
      activity.id == activity_id
    end
  end

  def self.computeTime()
    if !@current.nil?
      event = Event.new
      event.startTime = Time.at(@latest_timestamp)
      event.endTime = @time_now.call
      event.activity = @current
      @current_day.events << event
    end
    @latest_timestamp = @time_now.call
  end

  def self.start(save)
    save("start", []) if save
    @timer_running = true if !@current.nil?
    @latest_timestamp = @time_now.call
  end

  def self.stop(save)
    save("stop", []) if save
    computeTime()
    # puts @time_now.call - @latest_timestamp if @timer_running
    @timer_running = false
  end

  def self.current()
    puts @current
  end

  def self.set (activity_id, save)
    save("set", [activity_id]) if save
    computeTime()
    @current = get(activity_id)
  end

  def self.remove(activity_id, save)
    activity_id = activity_id.to_i

    save ("remove", [activity_id]) if save
    @activities.delete_if do |activity|
      activity.id == activity_id
    end
  end
end
