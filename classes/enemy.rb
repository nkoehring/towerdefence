class Enemy
  require './lib/algorithms'
  include Sprites::Sprite
  include EventHandler::HasEventHandler
  include Algorithms


  def initialize hitpoints
    super()
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

    # set the initial position
    @rect.center = @current_line[0]
  end

  def damage_by damage
    @damage += damage
    @got_hit = true
  end

  # Update the enemy state. Called once per frame.
  def update
    hit! if @got_hit
    move!
  end

  private
  def move!
    if @last_position < (@current_line.length-2)
      @last_position += 2
    else

      if @path.length > 5
        @path.slice!(0,2)
        @current_line = bresenham(*@path.take(4))
        @last_position = 0
      else
        kill and return
      end
    end

    @rect.center = @current_line[@last_position]
  end

  def hit!
    @got_hit = false
    puts "Enemy #{object_id}: Outch! (#{@hitpoints - @damage} hp left)"
    if (hp = @hitpoints - @damage) > 0
      @image.alpha = hp * 255 / @hitpoints
    else
      kill
    end
  end
end

