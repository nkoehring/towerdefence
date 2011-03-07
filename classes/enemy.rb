module TowerDefence
  class DeadEvent < Event
    attr_reader :dead

    def initialize dead
      super()
      @dead = dead
    end
  end

  class InvadingEvent < Event
  end


  class Enemy
    require './lib/algorithms'
    include Sprites::Sprite
    include EventHandler::HasEventHandler
    include Algorithms


    def initialize evthdlr, hitpoints
      super()
      @event_handler = evthdlr

      # The enemy's appearance. A red circle for demonstration.
      @image = Surface.new([22,22], 32)
      @image.fill(Grid.path_color)
      @image.draw_circle_s([10,10], 10, :red)
      @rect = @image.make_rect

      # enemy's properties
      @initial_hp = hitpoints
      @hitpoints = hitpoints
      @damage = 0
      @got_hit = false

      # enemy's movement
      @path = Grid.screen_path.flatten
      @last_position = 0
      @current_line = bresenham(*@path.take(4))
      @speed = Configuration.enemy[:speed]
      @movement_delta = @speed * Grid.width / 1000.0

      # set the initial position
      @rect.center = @current_line[0]

      make_magic_hooks :tick => :update
    end

    def damage_by damage
      @damage += damage
      @got_hit = true
    end

    # Update the enemy state. Called once per frame.
    def update event
      if alive?
        hit! if @got_hit
        move_by(@movement_delta * event.milliseconds)
      end
    end

    private
    def move_by distance
      if @last_position < (@current_line.length - distance)
        @last_position += distance
      else

        if @path.length > 5
          @path.slice!(0,2)
          @current_line = bresenham(*@path.take(4))
          @last_position = 0
        else
          kill
        @event_handler.fire InvadingEvent.new
        end
      end

      @rect.center = @current_line[@last_position]
    end

    def hit!
      @got_hit = false
      if (hp = @hitpoints - @damage) > 0
        @image.alpha = hp * 255 / @hitpoints
      else
        kill
        @event_handler.fire DeadEvent.new(self)
      end
    end
  end
end
