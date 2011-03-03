class Tower
  include Sprites::Sprite
  include EventHandler::HasEventHandler
  include Algorithms


  def initialize pos, enemies
    super()
    # The tower's appearance. A white square for demonstration.
    @image = Surface.new([20,20])
    @image.fill(:white)
    @rect = @image.make_rect
    @rect.center = pos

    # gameplay
    @enemies = enemies
    @target = nil
    @reload_timer = 0
  end

  # Update the tower state. Called once per frame.
  def update
    enemy_in_range?
    attack! unless @target.nil?
  end


  private
  def enemy_in_range?
    if @target.nil?
      @enemies.each_with_index do |e,i|
        distance = Grid.distance_between(e.rect.center, rect.center)
        @target = e if distance <= 5
      end
    else
      distance = Grid.distance_between(@target.rect.center, rect.center)
      @target = nil if distance > 5
    end
  end

  def attack!
    if @reload_timer == 0
      @reload_timer = 15

      puts "Attack #{@target.object_id}!"
      @target.damage_by 5
      @target = nil unless @target.alive?
    else
      @reload_timer -= 1
    end
  end
end

