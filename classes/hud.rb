class Hud

  # construct the HUD
  def initialize
    # TTF.setup must be called before any font object is created
    TTF.setup

    # point to the TTF file
    filename = File.join(File.dirname(__FILE__), '..', 'resources', 'fonts', 'SF Cosmic Age Condensed.ttf')

    # creates the font object, which is used for drawing text
    @cosmic_font = TTF.new filename, 24

    # initialize options that are displayed, here time
    @time = "-"

  end

  # called from the game class in each loop. updates options that are displayed
  def update secs
    @time = secs
  end

  # called from the game class in the draw method. render any options 
  # and blit the surface on the screen
  def draw surface
    timer = @cosmic_font.render "#{@time}FPS", true, [123,123,123]
    timer.blit surface, [surface.w - timer.w - 6, 6]                # blit to upper right corner
  end

end
