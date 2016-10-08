module Schedulr
  def self.load( file )
    open(file, 'a') { |f|
      @file = file
    }
    nil
  end

  def self.save( command )
    open( @file, 'a') do |f|
      f.puts command
    end
  end

  def self.add( activity )
    save "add #{activity}"
    # @activities << activity
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
