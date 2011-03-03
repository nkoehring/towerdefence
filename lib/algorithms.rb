module Algorithms
  # The line from the origin(0,0)  
  # (0,0)->(dx,dy)  0 <= dy <= dx (The angle range from 0 to 45 degrees)  
  def bresenham_0(dx, dy)  
    dy = dy * 2  
    y  = 1  
    err = 0  
    pos = []  
    for x in 0..dx  
      pos << [x, y/2]  
      err += dy  
      while err > dx  
        y += 1  
        err -= dx  
      end  
    end  
    pos  
  end  
    
  # A straight line between two given points.  
  # (x0,y0) -> (x1,y1)  
  def bresenham(x0, y0, x1, y1)  
    dx, dy = x1 - x0, y1 - y0  
    sx, sy = dx<=>0, dy<=>0       # sign flag (-1,0 or 1)  
    ax, ay = dx.abs, dy.abs  
    if ax >= ay  
      bresenham_0(ax, ay).map! {|x,y| [x0 + x * sx, y0 + y * sy]}  
    else  
      bresenham_0(ay, ax).map! {|y,x| [x0 + x * sx, y0 + y * sy]}  
    end  
  end  

  def distance x1, y1, x2, y2
    distance = ((x2 - x1).abs**2 + (y2 - y1).abs**2)**0.5
  end
end

