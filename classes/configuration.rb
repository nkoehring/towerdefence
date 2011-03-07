module Configuration
  def self.setup options={}
    @@rounds  = (options[:rounds] or { :secs => 1,
                                       :secs_round_multiplier => 0,
                                       :enemies => 8,
                                       :enemies_round_multiplier => 0,
                                       :lives => 10,
                                       :lives_round_multiplier => 0,
                                       :money => 50,
                                       :money_round_multiplier => 0
                                     })
    @@theme   = (options[:theme]  or 'default')
    @@screen  = (options[:screen] or { :size => [800, 600],
                                       :hud_rect => [700, 0, 100, 600]})
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
                                       :hitpoints_round_multiplier => 0.25,
                                       :bounty => 5,
                                       :bounty_round_multiplier => 0.1,
                                       :speed => 5, # in grid fields per second
                                       :speed_round_multiplier => 0   # TODO: use this multiplier
                                     })
    @@tower   = (options[:tower]  or { :damage => 5,
                                       :range => 5,
                                       :price => 15,
                                       :levels => 99,
                                       :damage_level_multiplier => 5,
                                       :price_level_multiplier => 2,
                                       :range_level_multiplier => 0.2
                                     })
  end

  def self.theme;   @@theme;  end
  def self.grid;    @@grid;   end
  def self.enemy;   @@enemy;  end
  def self.tower;   @@tower;  end
  def self.rounds;  @@rounds; end
  def self.screen;  @@screen; end

  #def self.money;
end

