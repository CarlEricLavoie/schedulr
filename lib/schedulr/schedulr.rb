require 'schedulr/log_entry'
require 'schedulr/calendar'

module Schedulr

  @time_now = Proc.new { Time.now }
  @calendar = Calendar.new

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
    activity = Activity.new(activity)
    @activities << activity
    return activity
  end

  def self.list()
    @activities = Array.new if @activities.nil?
    @activities
  end

  def self.day(name)
    now = Time.now
    d_end = Time.new(now.year, now.month, now.day)
    @calendar.getDay(d_end)
  end

  def self.get (activity_id)
    activity_id = activity_id.to_i
    @activities.find do |activity|
      activity.id == activity_id
    end
  end

  def self.computeTime()
    if !@current.nil?
      @calendar.event(Time.at(@latest_timestamp), @time_now.call, @current)
    end
    @latest_timestamp = @time_now.call
  end

  #Adds an event to the right day


  def self.start(save)
    save("start", []) if save
    @timer_running = true if !@current.nil?
    @latest_timestamp = @time_now.call
  end

  def self.stop(save)
    @temp =true
    save("stop", []) if save
    computeTime()
    @timer_running = false
  end

  def self.current()
    @current
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
