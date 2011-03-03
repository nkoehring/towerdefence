module Grid
  require './lib/algorithms'

  def self.setup screen_size
    @@screen_size = screen_size
    @@element_size = [
      screen_size[0] / Configuration.grid[:size][0],
      screen_size[1] / Configuration.grid[:size][1]]

    @@path_color = Configuration.grid[:path_color]
    # TODO handle grid[:path_image]
    @@path = nil
  end

  def self.width
    @@element_size[0]
  end

  def self.height
    @@element_size[1]
  end

  def self.element_size
    @@element_size
  end

  def self.distance_between p1, p2
    x1, y1 = p1
    x2, y2 = p2
    pixel_distance = ((x2 - x1).abs**2 + (y2 - y1).abs**2)**0.5
    distance = (pixel_distance / ((width + height)/2)).floor
  end

  def self.elementp_to_screenp pos
    pos = [
      pos[0] * Grid.element_size[0] + Grid.element_size[0]/2,
      pos[1] * Grid.element_size[1] + Grid.element_size[1]/2
    ]
  end

  def self.screenp_to_elementp pos
    element_position = [
      pos[0] / Grid.element_size[0] * Grid.element_size[0] + Grid.element_size[0]/2,
      pos[1] / Grid.element_size[1] * Grid.element_size[1] + Grid.element_size[1]/2
    ]
  end

  def self.path_color
    @@path_color
  end

  def self.path
    Configuration.grid[:path]
  end

  def self.screen_path
    Configuration.grid[:path].collect { |p| elementp_to_screenp(p) }
  end


  class GridElement
    include ::Sprites::Sprite
    def initialize pos
      super()
      @image = Surface.new( Grid.element_size )
      @image.fill(:gray)
      @image.alpha = 255
      @rect = @image.make_rect
      @rect.center = Grid.elementp_to_screenp pos
    end
  end


  class PathElement < GridElement
    def initialize pos
      super(pos)
      @image = @image.zoom(2)
      @rect = @image.make_rect
      @rect.center = Grid.elementp_to_screenp pos
    end
  end


  class GridHighlighter < GridElement
    def initialize
      super([0,0])
      @image.fill(:green)
      @image.alpha = 100
    end

    def green!
      @image.fill(:green)
    end

    def red!
      @image.fill(:red)
    end
  end


  class GridPath < Sprites::Group
    def initialize
      data = Grid.path
      last = data[0]

      self << PathElement.new(last)

      data[1..data.length].each do |p|

        x,y = p

        l2r = x > last[0]
        r2l = x < last[0]

        t2d = y > last[1]
        d2t = y < last[1]

        self << PathElement.new(p)

        while x > last[0]
          x-=1
          self << PathElement.new([x,y])
        end if l2r

        while x < last[0]
          x+=1
          self << PathElement.new([x,y])
        end if r2l

        while y > last[1]
          y-=1
          self << PathElement.new([x,y])
        end if t2d

        while y < last[1]
          y+=1
          self << PathElement.new([x,y])
        end if d2t

        last = p
      end
    end
  end


end

