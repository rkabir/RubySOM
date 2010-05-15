class Plotter
  
  def initialize(name)
    # Do not plot if plotting library missing
    return unless defined?(Scruffy) 
    
    @name  = name
    @graph = Scruffy::Graph.new(
      :theme => Scruffy::Themes::Base.new({
        :background => '#ffffff',
        :colors => ['red', 'blue', 'green', 'pink', 'purple'],
        :marker => '#000000',
        :font_family => 'Helvetica'
      })
    )
    @graph.renderer = Scruffy::Renderers::Standard.new    
    @tags = {}
  end
  
  def point(tag, value)
    @tags.has_key?(tag) ? @tags[tag] << value : @tags[tag] = [value]
  end
    
  # Render and save final graph
  def save(n=false)
    return unless defined?(Scruffy)
    return unless @tags.size > 0
    
    y = y_axis_limit
    x = x_axis_limit
    m = x / 10
    m == 0 ? m = 1 : nil
    
    @graph.point_markers = (1..x).to_a.select { |i| i % m == 0 }
    @graph.value_formatter = Scruffy::Formatters::Number.new(:precision => 2)
    @tags.each_key { |tag| plot(tag) } 
    
    if n
      to = "output/tsp_#{@name}-#{n}.svg"
    else
      to = "output/tsp_#{@name}.svg"
    end
    
    @graph.render(
      :min_value => 0,
      :max_value => y,
      :width => 600, 
      :to => to
    )
  end
  
  
  private
  
  def plot(tag, style = :line)
    name = tag.gsub('_',' ').capitalize
    @graph.add(style, name, @tags[tag])
  end
  
  def x_axis_limit
    max = []
    @tags.each_value do |points|
      max << points.size
    end
    max.sort.last
  end
  
  def y_axis_limit
    max = []
    @tags.each_value do |points|
      max << points.max
    end
    max.sort.last
  end
  
end