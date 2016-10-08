class Activity
  @@count = 0;
  def initialize ( name )
    @id = @@count
    @@count = @@count+1
    @name = name
  end


  def to_s
    "#{@name}::#{@id}"
  end
end