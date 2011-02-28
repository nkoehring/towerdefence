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


    # Create event hooks in the easiest way.
    make_magic_hooks(
      # Send ClockTicked events to #update()
      ClockTicked => :update
    )
  end


  private

  # Update the tower state. Called once per frame.
  def update event
  end
end

