module Configuration
  def self.setup options={}
    @@rounds  = (options[:rounds] or { :secs => 5,
                                       :secs_round_multiplier => 0,
                                       :enemies => 8,
                                       :enemies_round_multiplier => 0
                                     })
    @@theme   = (options[:theme]  or 'default')
    @@grid    = (options[:grid]   or { :size => [32, 24],
                                       :path_color => :gray,
                                       :path_image => false,
                                       :path => [
                                         [2,0], [2,21],
                                         [8,21], [8,2],
                                         [22,2], [22,10],
                                         [14,10]]
                                     })
    @@enemy   = (options[:enemy]  or { :hitpoints => 5,
                                       :hitpoints_round_multiplier => 0.25
                                     })
    @@tower   = (options[:tower]  or [{ :damage => 5,
                                        :range => 100,
                                        :color => :green
                                      },
                                      { :damage => 5,
                                        :range => 100,
                                        :color => :brown
                                      },
                                      { :damage => 5,
                                        :range => 100,
                                        :color => :blue
                                      }])
  end

  def self.theme
    @@theme
  end

  def self.grid
    @@grid
  end

  def self.enemy
    @@enemy
  end
  
  def self.rounds
    @@rounds
  end
end

