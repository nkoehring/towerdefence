class Hud

  # construct the HUD
  def initialize
    # TTF.setup must be called before any font object is created
    TTF.setup

    # point to the TTF file
    theme = Configuration.theme
    filename = File.join(File.dirname(__FILE__), '..', 'resources', theme, 'fonts', 'font.ttf')

    # creates the font object, which is used for drawing text
    # TODO make this configurable
    @title_font = TTF.new filename, 12
    @font  = TTF.new filename, 24
    @color = [123,123,123]
    @background = [10,10,10]

    # initialize options that are displayed
    @fps  = "-"
    @round = "-"
    @enemies_alive = "-"
    @round_timer = "-"
  end

  # called from the game class in each loop. updates options that are displayed
  def update fps, round, enemies_alive, round_timer
    @fps = fps
    @round = round
    @enemies_alive = enemies_alive
    @round_timer = round_timer
  end

  # called from the game class in the draw method. render any options 
  # and blit the surface on the screen
  def draw surface
    # FPS
    display = @font.render "#{@fps}FPS", true, @color, @background
    display.blit surface, [surface.w - display.w - 6, 6]                # blit to upper right corner

    # Wave Counter
    display = @font.render "Wave ##{@round}", true, @color, @background
    display.blit surface, [surface.w - display.w - 6, 30]                # blit right below FPS

    # Enemy Counter
    display = @title_font.render "enemies left", true, @color, @background
    display.blit surface, [surface.w - display.w - 6, 54]                # blit right below FPS
    display = @font.render "#{@enemies_alive}", true, @color, @background
    display.blit surface, [surface.w - display.w - 6, 64]                # blit right below FPS

    # Round Timer
    display = @title_font.render "time to next round", true, @color, @background
    display.blit surface, [surface.w - display.w - 6, 88]                # blit right below FPS
    display = @font.render "#{@round_timer}", true, @color, @background
    display.blit surface, [surface.w - display.w - 6, 98]                # blit right below FPS
  end

end
