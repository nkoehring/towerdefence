class Game
  include EventHandler::HasEventHandler

  def initialize()
    make_screen
    make_clock
    make_queue
    make_event_hooks

    Configuration.setup
    Grid.setup @screen.size
    @grid_highlighter = Grid::GridHighlighter.new
    @the_path = Grid::GridPath.new
    @enemies = Sprites::Group.new
    @towers = Sprites::Group.new
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


  # Checks for collision with other towers or the path
  def nice_place_for_tower? ghost
    @towers.collide_sprite(ghost).empty? and @the_path.collide_sprite(ghost).empty?
  end


  # Create a tower at the click position
  def create_tower event
    tower = Tower.new(Grid.screenp_to_elementp(event.pos))
    @towers << tower if nice_place_for_tower?(tower)
  end


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
    @screen = Screen.open( [640, 480] )
    @screen.title = "Towerdefence!"
  end


  # Quit the game
  def quit
    puts "Quitting!"
    throw :quit
  end


  # Do everything needed for one frame.
  def step
    # Clear the screen.
    @screen.fill( :black )

    # Fetch input events, etc. from SDL, and add them to the queue.
    @queue.fetch_sdl_events

    # Tick the clock and add the TickEvent to the queue.
    @queue << @clock.tick

    # Process all the events on the queue.
    @queue.each do |event|
      handle( event )
    end

    # Draw the tower in its new position.
    
    @the_path.draw @screen
    @enemies.draw @screen
    @towers.draw @screen
    @grid_highlighter.draw @screen

    # Refresh the screen.
    @screen.update()
  end
end

