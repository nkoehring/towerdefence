module TowerDefence
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
      @font  = TTF.new filename, 48
      @color = [123,123,123]
      @background = [10,10,10]

      # initialize options that are displayed
      @fps  = "-"
      @round = "-"
      @enemies_alive = "-"
      @round_timer = "-"
    end

    # called from the game class in each loop. updates options that are displayed
    def update fps, round, enemies_alive, money, lives, round_timer
      @fps = fps
      @round = round
      @enemies_alive = enemies_alive
      @money = money
      @lives = lives
      @round_timer = round_timer
    end

    # called from the game class in the draw method. render any options 
    # and blit the surface on the screen
    def draw surface
      # FPS
      display = @title_font.render "#{@fps}FPS", true, @color
      display.blit surface, [surface.w - display.w - 6, 6]                # blit to upper right corner

      # Wave Counter
      display = @font.render "##{@round}", true, @color
      display.blit surface, [surface.w - display.w - 6, 16]

      # Enemy Counter
      draw_entitled "enemies alive", @enemies_alive, 64, surface

      # Round Timer
      draw_entitled "next wave in", @round_timer, 122, surface

      # money
      draw_entitled "money", @money, 170, surface

      #lives
      draw_entitled "lives", @lives, surface.h-60, surface
    end

    def draw_score surface    # oh noes? already game over?!
      w = surface.w
      h = surface.h
      x,y = [w/2 - 50, h/2 - 25]
      border_rect = Rect.new(x-10,y-5,120,60)
      rect = Rect.new(x,y,100,50)

      surface.fill :gray, border_rect
      surface.fill :black, rect

      title = @title_font.render "Your score:", true, :red
      score = @font.render "#{@round}", true, :red

      title.blit surface, [rect.center[0] - title.w/2, y]
      score.blit surface, [rect.center[0] - score.w/2, rect.center[1] - score.h/2]
    end

    private
    def draw_entitled title, value, height, surface
      display = @title_font.render title, true, @color
      display.blit surface, [surface.w - display.w - 6, height]
      display = @font.render "#{value}", true, @color
      display.blit surface, [surface.w - display.w - 6, height+10]
    end
  end
end
