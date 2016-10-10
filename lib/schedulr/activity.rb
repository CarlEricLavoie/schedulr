class Activity
  @@count = 0;
  attr_accessor :id
  attr_accessor :name
  attr_accessor :time
  def initialize ( name )
    self.id = @@count
    @@count = @@count+1
    self.name = name
    self.time = 0;
  end


  def to_s
    "#{name}::#{id}::#{time}"
  end
end