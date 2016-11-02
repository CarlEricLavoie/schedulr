require 'schedulr/log_entry'
require 'schedulr/calendar'
require 'schedulr/activity'

module Schedulr

  def self.initialize_state()
    # Value of current time. will be changed when reconstructing state.
    @time_now = Time.now
    #name of the instance to load
    @instance_name = nil
    #list of all activities
    @activities = Array.new
    #timestamp of the latest event. used to calculate time diff between events.
    @latest_timestamp = nil
    #Identifies if the timer is currently running
    @timer_running = false

    @current_activity = nil
    @calendar = Calendar.new
  end

  def self.load(name)
    initialize_state()
    @instance_name = "#{name}.timesheet"
    open(@instance_name, 'a+') do |f|
      f.each_line do |line|
        load_line(line)
      end
    end
    nil
  end


  def self.load_line(line)
    log = LogEntry.from(line)
    @time_now = log.date
    send(log.cmd, *log.args, false)
  end

  def self.rename(activity_id, activity_name, save = true)
    activity_id = activity_id.to_i

    save ("rename", [activity_id, activity_name]) if save
    activity = @activities.find do |activity|
      activity.id == activity_id
    end
    activity.name = activity_name
  end

  def self.save(command, args)
    log_entry = LogEntry.new(Time.now.to_i, command, args)
    open(@instance_name, 'a') do |f|
      f.puts log_entry.to_log
    end
  end

  def self.add(activity, save = true)
    save ("add", [activity]) if save
    activity = Activity.new(activity)
    @activities << activity
    return activity
  end

  def self.list()
    @activities
  end

  def self.day(offset = 0)
    @time_now = Time.now
    stop(false) if @timer_running
    now = Time.now
    d_end = Time.new(now.year, now.month, now.day)
    d_end = d_end - (1*24*60*60*offset.to_i)
    @calendar.day_of(d_end)
  end

  def self.get (activity_id)
    activity_id = activity_id.to_i
    @activities.find do |activity|
      activity.id == activity_id
    end
  end

  def self.computeTime()
    if !@current_activity.nil?
      @calendar.event(Time.at(@latest_timestamp), @time_now, @current_activity)
    end
    @latest_timestamp = @time_now
  end

  #Adds an event to the right day


  def self.start(save = true)
    save("start", []) if save
    @timer_running = true if !@current_activity.nil?
    @latest_timestamp = @time_now
  end

  def self.stop(save = true)
    save("stop", []) if save
    computeTime()
    @timer_running = false
  end

  def self.current()
    @current_activity
  end

  def self.set (activity_id, save = true)
    save("set", [activity_id]) if save
    computeTime()
    @current_activity = get(activity_id)
  end

  def self.remove(activity_id, save = true)
    activity_id = activity_id.to_i

    save ("remove", [activity_id]) if save
    @activities.delete_if do |activity|
      activity.id == activity_id
    end
  end
end
