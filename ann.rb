Country = ARGV[0] ||= 'sahara' 

require 'base/require'
require 'settings'
Require.folder('base')
Require.folder('som')
begin
  require 'rubygems'
  require 'RMagick'
  require 'scruffy'
rescue
end


class ANN
  attr_reader :som
  
  def initialize
    @coords = load(Settings::Country)
    @som    = SOM.new(Settings::Neurons || @coords.size)
    @drawer = Drawer.new
    @norm   = normalize_coords(@coords)
  end
  
  def run
    a = Settings::Learning[:rate].to_f
    d = Settings::Learning[:neighborhood_radius].to_f
    n = Settings::Learning[:epochs].to_f
    a_diff = a / n
    d_diff = (d - 1.0) / (n * 0.65)
    
    do_plot = defined?(Scruffy) and Settings::Graph
    @plotter = Plotter.new('path') if do_plot
    
    (1..n.to_i).each do |i|
      puts "Epoch ##{i}"
      
      if do_plot or Settings::Draw.include?(i) or Settings::AddNeurons.include?(i)
        cp = @som.current_path(@norm, i)
        draw(i, cp) if Settings::Draw.include?(i)
        plot(i, cp) if do_plot
      end
      
      @norm.each { |c| @som.train(c,d,a) }
      a -= a_diff
      d = [1, d-d_diff].max
    end
  end
  
  private
  
  def draw(i, cp)
    @drawer.plot(i, @coords, @som.neurons, cp)
  end
  
  def plot(index, cp)
    dist = 0.0
    cp.each_index do |index|
      p1 = @coords[cp[index]]
      p2 = @coords[cp[(index+1) % cp.size]]
      dist += Math.euclidean_distance(p1,p2)
    end
    @plotter.point('length', dist)
    @plotter.save if index == Settings::Learning[:epochs]    
  end
  
  def load(country)
    coords = []
    File.open("input/#{country}.txt").each do |l|
      if l =~ /^[0-9]+ ([0-9|\.]+) ([0-9|\.]+)/  
        coords << [$1.to_f, $2.to_f]
      end
    end
    coords
  end
  
  def normalize_coords(coords)
    x = coords.map { |e| e[0] }
    y = coords.map { |e| e[1] }
    xmax, ymax = x.max, y.max
    xmin, ymin = x.min, y.min
    coords.map do |e|
      [(e[0] - xmin) / (xmax - xmin),
       (e[1] - ymin) / (ymax - ymin)]
    end
  end
  
end

ANN.new.run
