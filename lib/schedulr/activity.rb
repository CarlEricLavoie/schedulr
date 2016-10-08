class Activity
  @@count = 0;
  attr_accessor :id
  def initialize ( name )
    self.id = @@count
    @@count = @@count+1
    @name = name
  end


  def to_s
    "#{@name}::#{id}"
  end
end