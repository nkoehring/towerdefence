module TowerDefence
  class Game
    include EventHandler::HasEventHandler
    include TowerDefence

    def initialize()
      Configuration.setup
      make_screen
      make_clock
      make_event_hooks

      # basics
      Grid.setup @screen.size
      @grid_highlighter = Grid::GridHighlighter.new
      @the_path = Grid::GridPath.new
      @enemies = Sprites::Group.new
      @towers = Sprites::Group.new
      @hud = Hud.new

      # gameplay
      @restock_enemies = 0
      @round = 0
      @round_timer = 0
      @ticks = 0
      @lives = Configuration.rounds[:lives] - 1
      @bounty = Configuration.enemy[:bounty]
      @tower_price = Configuration.tower[:price]
      @money = Configuration.rounds[:money]

      # gameplay works as following:
      # round_timer will be resetted at first and the game loop does:
      # update_timer
      # -> next_round!
      # ---> reset_timer
      # ---> create_enemy_wave
      # -----> restock_enemies!
      reset_timer
    end


    # The "main loop". Repeat the #step method
    # over and over and over until the user quits.
    def go
      catch(:quit) do
        loop do
          step
        end
      end
    end


    private
    def game_over!
      @game_over = true
      @enemies.clear
      @towers.clear
      @screen.fill :black
      @hud.draw_score @screen
    end

    def tower_upgrade event
      if @money >= event.price
        @money -= event.price
        event.tower.upgrade!
      else
        puts "Insufficien money (#{@money}/#{event.price})."
      end
    end

    def count_survivors
      if @lives > 0
        @lives += (@lives * Configuration.rounds[:lives_round_multiplier])
      end
    end

    def enemy_defeated event
      @money += @bounty
      @enemies.delete event.dead
    end

    def enemy_missed event
      if @lives > 0
        @lives -= 1
      else
        game_over!
      end
    end

    def next_round!
      @round += 1
      @bounty += (@bounty * Configuration.enemy[:bounty_round_multiplier]).ceil
      count_survivors
      reset_timer
      create_enemy_wave
    end

    def reset_timer
      @round_timer = Configuration.rounds[:secs]
      mul = Configuration.rounds[:secs_round_multiplier]
      (@round-1).times { |r| @round_timer += (@round_timer*mul).ceil }
    end

    def update_timer
      @ticks += 1
      if @ticks % 30 == 0 and @enemies.length == 0  # around every second
        @round_timer -= 1
        next_round! if @round_timer == 0 
      end
    end

    def restock_enemies!
      # calculate hitpoints for this round
      hp = Configuration.enemy[:hitpoints]
      mul = Configuration.enemy[:hitpoints_round_multiplier]
      @round.times {|r| hp += (hp*mul).ceil }

      if @clock.lifetime() % 20 < 3
        @enemies << Enemy.new( @event_handler, hp )
        @restock_enemies -= 1
      end
    end

    def create_enemy_wave
      if @enemies.empty?
        @restock_enemies = Configuration.rounds[:enemies]
        mul = Configuration.rounds[:enemies_round_multiplier]
        @round.times {|r| @restock_enemies += (@restock_enemies*mul).ceil }
        puts " >>> A NEW ENEMY WAVE COMES! (#{@restock_enemies}) <<< "
        restock_enemies!
      end
    end

    # Checks for collision with other towers or the path
    def nice_place_for_tower? ghost
      @towers.collide_sprite(ghost).empty? and @the_path.collide_sprite(ghost).empty?
    end


    # Create a tower at the click position
    def create_tower event
      if @money >= @tower_price
        tower = Tower.new(@event_handler, Grid.screenp_to_elementp(event.pos), @enemies)
        if nice_place_for_tower?(tower) 
          @money -= @tower_price
          @towers << tower
        end
      end
    end


    # Catch the mouse_moved event to set the grid highlighter
    # below the mouse pointer and check for collision with
    # towers and the path
    def mouse_moved event
      pos = Grid.screenp_to_elementp(event.pos)

      @grid_highlighter.rect.center = pos
      if nice_place_for_tower? @grid_highlighter
        @grid_highlighter.green!
      else
        @grid_highlighter.red!
      end
    end


    # Create a new Clock to manage the game framerate
    # so it doesn't use 100% of the CPU
    def make_clock
      @clock = Clock.new()
      @clock.target_framerate = 30
      @clock.calibrate
    end


    # Set up the event hooks to perform actions in
    # response to certain events.
    def make_event_hooks
      @event_handler = GlobalEventHandler.new @clock
      
      hooks = {
        MouseMoveTrigger.new( :none ) => :mouse_moved,
        InstanceOfTrigger.new(InvadingEvent) => :enemy_missed,
        InstanceOfTrigger.new(DeadEvent) => :enemy_defeated,
        InstanceOfTrigger.new(UpgradeEvent) => :tower_upgrade,
        :mouse_left => :create_tower,
        :escape => :quit,
        :q => :quit,
        QuitRequested => :quit
      }

      make_magic_hooks( hooks )
    end


    # Create the Rubygame window.
    def make_screen
      @screen = Screen.new(Configuration.screen[:size], 32, [HWSURFACE, DOUBLEBUF])

      @screen.title = "Towerdefence!"
    end

    # Quit the game
    def quit
      puts "Quitting!"
      throw :quit
    end


    # Do everything needed for one frame.
    def step
      if @game_over
        game_over!
        @event_handler.update
      else
        # background for playing field and hud
        @screen.fill :black
        @screen.fill [50,50,50], Rect.new(Configuration.screen[:hud_rect])

        @event_handler.update
        @hud.update @clock.framerate.ceil, @round, @enemies.length, @money, @lives+1, @round_timer

        update_timer
        restock_enemies! if @restock_enemies > 0

        @the_path.draw @screen      # Draw the enemy path.
        @enemies.draw @screen       # Draw the enemies.
        @towers.draw @screen        # Draw all set towers.
        @grid_highlighter.draw @screen  # Draw the nifty semi-transparent highlighter below the mouse.
        @hud.draw @screen           # draw the HUD
      end

      @screen.update()            # Refresh the screen.
    end
  end
end
