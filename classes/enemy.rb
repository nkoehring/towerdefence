class Enemy
  include Sprites::Sprite
  include EventHandler::HasEventHandler


  def initialize pos, hitpoints
    super()
    # The enemy's appearance. A red circle for demonstration.
    @image = Surface.new([22,22])
    @image.fill(Grid.path_color)
    @image.draw_circle_s([10,10], 10, :red)
    @rect = @image.make_rect
    @rect.center = pos

    # enemy's properties
    @initial_hp = hitpoints
    @hitpoints = hitpoints
    @damage = 0
  end

  def hit_with damage
    @damage += damage
  end

  # Update the enemy state. Called once per frame.
  def update
    if (hp = @hitpoints - @damage) > 0
      @image.alpha = hp * 255 / @hitpoints
    else
      kill
    end
  end
end

