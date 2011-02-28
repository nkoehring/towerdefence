class Tower
  include Sprites::Sprite
  include EventHandler::HasEventHandler


  def initialize pos
    super()
    # The tower's appearance. A white square for demonstration.
    @image = Surface.new([20,20])
    @image.fill(:white)
    @rect = @image.make_rect
    @rect.center = pos
  end

  # Update the tower state. Called once per frame.
  def update
  end
end

