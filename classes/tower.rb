module TowerDefence
  class UpgradeEvent < Event
    attr_reader :tower, :price
    def initialize tower, price
      @tower = tower
      @price = price
    end
  end

  class GhostTower
    include Sprites::Sprite
    attr_reader :rect
    def initialize pos
      super()
      @image = Surface.new([20,20])
      @rect = @image.make_rect
      @rect.center = pos
      #@rect = Rect.new pos[0], pos[1], 20, 20
    end
  end

  class Tower
    include Sprites::Sprite
    include EventHandler::HasEventHandler
    include Algorithms


    def initialize evthdlr, pos, enemies
      super()
      @event_handler = evthdlr

      # The tower's appearance. A white square for demonstration.
      @image = Surface.new([20,20])
      @image.fill(:white)
      @rect = @image.make_rect
      @rect.center = pos

      # gameplay - upgrades
      @level = 1
      @price = Configuration.tower[:price]
      @range = Configuration.tower[:range]
      @damage = Configuration.tower[:damage]
      @levels = Configuration.tower[:levels]
      @font = TTF.new File.join("resources", Configuration.theme, "fonts", "font.ttf"), 10

      # gameplay - targeting
      @enemies = enemies
      @target = nil
      @reload_timer = 0
      @trails = []

      make_magic_hooks({
        :tick => :update,
        :mouse_left => :try_upgrade
      })
    end

    def draw surface
      @trails.each_with_index do |(target, time), i|
        if time == 0
          @trails.delete_at i
          break
        end
        alpha = time * 255 / 10
        color = [255,255,0,alpha]
        @image.fill color
        surface.draw_line(@rect.center, target.rect.center, color)
        @trails[i][1] -= 1
      end

      @font.render(@level.to_s, true, :black).blit(@image, [12,2])
      @image.blit surface, @rect
    end

    def upgrade!
      @level += 1
      @damage += (@damage * Configuration.tower[:damage_level_multiplier])
      @price += (@price * Configuration.tower[:price_level_multiplier])
      @range += (@range * Configuration.tower[:range_level_multiplier])
    end


    private
    # Update the tower state. Called once per frame.
    def update event
      @image.fill :white
      enemy_in_range?
      attack! unless @target.nil?
    end

    def enemy_in_range?
      if @target.nil?
        @enemies.each_with_index do |e,i|
          distance = Grid.distance_between(e.rect.center, rect.center)
          @target = e if distance <= @range and e.alive?
        end
      else
        distance = Grid.distance_between(@target.rect.center, rect.center)
        @target = nil if distance > @range or (not @target.alive?)
      end
    end

    def shoot!
      @target.damage_by @damage
      @trails << [@target, 10]
      # we need this here to be able to lose dead targets
      @target = nil unless @target.alive?
    end

    def attack!
      if @reload_timer == 0
        @reload_timer = 15
        shoot!
      else
        @reload_timer -= 1
      end
    end

    def try_upgrade event
      if rect.collide_point?(*event.pos)
        @event_handler.fire(UpgradeEvent.new(self, @price)) if @level < Configuration.tower[:levels]
      end
    end
  end
end
