class Drawer
    
  def initialize
    @Width  = 500
    @Height = 500
    return unless defined?(Magick)
    reset
  end
  
  def plot(i, coords, neurons, current_path)
    puts " Plotting ##{i}"
    draw_neuron_path(neurons)
    draw_neurons(neurons)
    draw_city_path(current_path, coords)
    draw_cities(coords)
    save(i)
    reset
  end
  
  
  private
  
  def reset
    @w = @Width
    @h = @Height
    @points = []
    @lines  = []
    @draw = Magick::Draw.new    
    @point_color = 'red'
    @line_color = 'black'
  end
  
  def draw_cities(coords)
    draw_points(coords, 'red')
  end
  
  def draw_neurons(neurons)
    x = neurons.map { |e| e.w[0] }
    y = neurons.map { |e| e.w[1] }
    coords = []
    x.each_index { |i| coords << [x[i], y[i]] }
    draw_points(coords, 'blue')
  end
  
  def draw_points(coords, color)
    x = coords.map { |e| e[0] }
    y = coords.map { |e| e[1] } 
    xmax, ymax = x.max, y.max
    xmin, ymin = x.min, y.min
    
    coords.each do |c|
      x = (c[0] - xmin) * @h / (xmax - xmin)
      y = (c[1] - ymin) * @w / (ymax - ymin)
      x = @h - x + 50
      y = @w - y + 50
      point(y,x)
    end
    @point_color = color
    plot_points
    @points = []
  end
  
  def draw_city_path(route, coords)
    draw_path(route, coords, 'black', true)
  end
  
  def draw_neuron_path(neurons)
    route  = []
    coords = []
    neurons.each_with_index do |n,i|
      route  << i
      coords << [n.w[0], n.w[1]]
    end
    draw_path(route, coords, 'grey')
  end
  
  def draw_path(route, coords, color, save_distance=false)
    @route_length = 0.0 if save_distance
    
    x = coords.map { |e| e[0] }
    y = coords.map { |e| e[1] }
    xmax, ymax = x.max, y.max
    xmin, ymin = x.min, y.min
    
    route.each_with_index do |city_index, route_index|
      current_i = route[route_index]
      next_i = route[(route_index+1) % route.size]
      pos = coords[current_i]
      
      x = (pos[0] - xmin) * @h / (xmax - xmin)
      y = (pos[1] - ymin) * @w / (ymax - ymin)
      x = @h-x+50
      y = @w-y+50
      
      pos2 = coords[next_i]
      x2 = (pos2[0] - xmin) * @h / (xmax - xmin)
      y2 = (pos2[1] - ymin) * @w / (ymax - ymin)
      x2 = @h-x2+50
      y2 = @w-y2+50
      
      line(y, x, y2, x2)
      
      @route_length += Math.euclidean_distance(pos,pos2) if save_distance
    end
    @line_color = color
    plot_lines
    @lines = []
  end
  
  def save(n)
    return unless defined?(Magick)    
    @h += 100
    @w += 100
    @canvas = Magick::Image.new(@w, @h)
    
    optimal = Settings::Optimal
    @difference = ((@route_length - optimal) / optimal) * 100
    
    @draw.stroke = 'none'
    @draw.pointsize = 16
    @draw.annotate(@canvas, 0, 0, 20, 30, 
      "Iteration: #{n}    Length: #{@route_length.round_to(2)} (+#{@difference.round_to(2)}%)")
    
    @draw.draw(@canvas)
    
    if n
      digits = "#{Settings::Learning[:epochs]}".length
      num = "%0#{digits}d" % n
      @canvas.write("output/tsp-#{num}.png")
    else
      @canvas.write("output/tsp.png")
    end
  end
  
  def point(x, y)
    @points << [x,y]
  end
  
  def line(x1, y1, x2, y2)
    @lines << [[x1,y1], [x2,y2]]
  end
  
  def plot_points
    @draw.fill(@point_color)
    @points.each do |p|
      @draw.circle(p[0], p[1], p[0]+2, p[1]+2)
    end
  end
  
  def plot_lines
    @draw.fill(@line_color)
    @lines.each do |l|
      @draw.line(l[0][0], l[0][1], l[1][0], l[1][1])
    end
  end
  
end
