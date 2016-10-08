module Schedulr
  def self.load( name )
    @name = name
    open(name, 'a')
    open(name, 'r+') do |f|
      f.each_line do |line|
        d = line.scan(/\{\{(.*?)\}\}+/)

        puts "calling method #{d[1][0]} with arguments #{d[2][0]}"

        #convert string to array
        args = d[2][0].gsub(/(\[\"|\"\])/, '').split('", "')

        #use splat operator to reconstruct function call
        send(d[1][0], *args, false)
      end
    end
    nil
  end

  def self.save( command, args )
    open( @name, 'a') do |f|
      f.puts "{{#{Time.now.to_i}}}{{#{command}}}{{#{args}}}"
    end
  end

  def self.add( activity, save )
    if save
      save ("add", [activity])
    end
    @activities = Array.new if @activities.nil?

    @activities << Activity.new( activity )
  end

  def self.print( quiet, motif, lignes )
    # A COMPLETER.#
    return [] if lignes == []
  end
  def self.substitute( quiet, motif, remplacement, global, lignes )
    return [] if quiet

    lignes.map do |ligne|
      if /#{motif}/ =~ ligne
        ligne.send (global ? :gsub : :sub), /#{motif}/, remplacement
      else
        ligne
      end
    end
  end
end
