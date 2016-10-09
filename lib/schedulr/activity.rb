class Activity
  @@count = 0;
  attr_accessor :id
  attr_accessor :name
  def initialize ( name )
    self.id = @@count
    @@count = @@count+1
    self.name = name
  end


  def to_s
    "#{name}::#{id}"
  end
end