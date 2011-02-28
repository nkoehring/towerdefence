class ThePath
  include Sprites::Sprite

  def initialize screen_size
    super()

    data = [
      # grid x1,y1 -> x2,y2 -> x3,y3 -> ... -> xN,yN
      [2,0], [2,22], [5,22], [5,2], [20,2]
    ]

    @image = Surface.new screen_size
    @image.fill :black
    @rect = @image.make_rect
    @castle = Surface.load('resources/sprites/sprite.png')
    @collision_rects = []
  
    # arrays to cache polygon edge points
    p = []
    q = []

    # Use points as vector and move then 15px left and right to draw a 30px wide "path"
    vl = data[0] # vl => vector_last
    data[1..data.length].each_with_index do |vc,i| # vc => vector_current
      a = Ftor.new_from_to(vl, vc)    # create a vector from vl to vc
      a = a.n                         # get the vector normal (which is perpendicular to the vector)
      a.magnitude = 15                # set it to length of 15

      # create new vectors left and right side
      va1 = Ftor.new(vl[0],vl[1]) + a
      va2 = Ftor.new(vc[0],vc[1]) + a
      vb1 = Ftor.new(vl[0],vl[1]) - a
      vb2 = Ftor.new(vc[0],vc[1]) - a

      p << va1
      p << va2
      q << vb1
      q << vb2

      vl = vc
    end

    @image.draw_polygon_a(p+q.reverse, :gray) # draw a polygon aka "The Path" (antialiased border)
    @image.draw_polygon_s(p+q.reverse, :gray) # draw a polygon aka "The Path"

    

    @castle.blit @image, [500, 375]
  end

  def update
  end

  def collide_sprite sprite
    if sprite.respond_to?(:col_rect)
      return sprite.col_rect.collide_array_all @collision_rects
    elsif sprite.respond_to?(:rect)
      return sprite.rect.collide_array_all @collision_rects
    end
    []
  end
end

