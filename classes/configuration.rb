module Configuration
  def self.setup options={}
    @@theme = (options[:theme] or 'default')
    @@grid  = (options[:grid]  or { :size => [32, 24],
                                   :path_color => :gray,
                                   :path_image => false,
                                   :path => [
                                     [2,0], [2,21],
                                     [8,21], [8,2],
                                     [22,2], [22,10],
                                     [14,10]
                                    ]})
  end

  def self.theme
    @@theme
  end

  def self.grid
    @@grid
  end
end

