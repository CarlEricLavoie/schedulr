module Schedulr
  def self.load(name)
    @name = name
    open(name, 'a')
    open(name, 'r+') do |f|
      f.each_line do |line|
        d = line.scan(/\{\{(.*?)\}\}+/)

        #todo add debug
        #puts "calling method #{d[1][0]} with arguments #{d[2][0]}"

        #convert string to array
        args = d[2][0].gsub(/(\[\"?|\"?\])/, '').split(/"?, "?/)

        #todo int as int not string

        #use splat operator to reconstruct function call
        send(d[1][0], *args, false)
      end
    end
    nil
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

  def self.get (activity_id)
    activity_id = activity_id.to_i
    @activities.find do |activity|
      activity.id == activity_id
    end
  end

  def self.current()
    puts @current
  end

  def self.set (activity_id, save)
    save("set", [activity_id]) if save
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
