
class LogEntry
  attr_accessor :date
  attr_accessor :cmd
  attr_accessor :args

  def to_log()
    "{{#{@date.to_i}}}{{#{@cmd}}}{{#{@args}}}"
  end

  def initialize(date, cmd, args)
    @date = date
    @cmd = cmd
    @args = args
  end

end

def LogEntry.from(line)
  data = line.scan(/\{\{(.*?)\}\}+/)
  date = Time.at(data[0][0].to_i)
  cmd = data[1][0]
  args = data[2][0].gsub(/(\[\"?|\"?\])/, '').split(/"?, "?/)
  LogEntry.new(date, cmd, args)
end
