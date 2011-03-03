class Game
  include EventHandler::HasEventHandler

  def initialize()
    make_screen
    make_clock
    make_queue
    make_event_hooks

    # basics
    Configuration.setup
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

  def next_round!
    puts "Round #{@round}."

    @round += 1
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
      puts "#{@round_timer} seconds until next round! (#{@ticks})"
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
      @enemies << Enemy.new( hp )
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
    tower = Tower.new(Grid.screenp_to_elementp(event.pos), @enemies)
    @towers << tower if nice_place_for_tower?(tower)

    # TODO let the towers do this!
    # @enemies[0].hit_with(1) if @enemies[0].rect.collide_point?(*(event.pos))
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
    @clock.enable_tick_events
  end


  # Set up the event hooks to perform actions in
  # response to certain events.
  def make_event_hooks
    hooks = {
      MouseMoveTrigger.new( :none ) => :mouse_moved,
      :mouse_left => :create_tower,
      :escape => :quit,
      :q => :quit,
      QuitRequested => :quit
    }

    make_magic_hooks( hooks )
  end


  # Create an EventQueue to take events from the keyboard, etc.
  # The events are taken from the queue and passed to objects
  # as part of the main loop.
  def make_queue
    # Create EventQueue with new-style events (added in Rubygame 2.4)
    @queue = EventQueue.new()
    @queue.enable_new_style_events
  end


  # Create the Rubygame window.
  def make_screen
    @screen = Screen.new([640, 480], 32, [HWSURFACE,SRCCOLORKEY,SRCALPHA])
    @screen.title = "Towerdefence!"
  end


  # Quit the game
  def quit
    puts "Quitting!"
    throw :quit
  end


  # Do everything needed for one frame.
  def step
    @screen.fill( :black )      # Clear the screen.
    @queue.fetch_sdl_events     # Fetch input events, etc. from SDL, and add them to the queue.
    @queue << @clock.tick       # Tick the clock and add the TickEvent to the queue.
    @queue.each {|e| handle(e)} # Process all the events on the queue.

    @enemies.update
    @towers.update
    @hud.update @clock.framerate.ceil, @round, @enemies.length, @round_timer

    update_timer
    restock_enemies! if @restock_enemies > 0

    @the_path.draw @screen      # Draw the enemy path.
    @enemies.draw @screen       # Draw the enemies.
    @towers.draw @screen        # Draw all set towers.
    @grid_highlighter.draw @screen  # Draw the nifty semi-transparent highlighter below the mouse.
    @hud.draw @screen           # draw the HUD

    @screen.update()            # Refresh the screen.
  end
end

