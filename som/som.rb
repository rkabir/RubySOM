class SOM
  attr_reader :neurons
  
  def initialize(n)
    @neurons = Array.new(n).map { Neuron.new }
  end
  
  def train(c, d, a)
    neuron = closest(c)
    neuron.update!(c,a)
    ns = neighbors(neuron, d.ceil)
    ns.each do |n|
      a -= a / (ns.size.to_f + 1.0)
      n[0].update!(c,a)
      n[1].update!(c,a)
    end
  end

  def current_path(norm, iteration)
    map = Array.new(@neurons.size, [])
    norm.each_with_index do |city_coords, city_index|
      nearest = nil
      dist = nil
      @neurons.each_with_index do |neuron, neuron_index|
        d = Math.rel_distance(city_coords, neuron.w)
        if nearest.nil? or d < dist
          nearest = neuron_index
          dist = d
        end
      end 
      map[nearest] += [city_index]
    end
    
    if Settings::AddNeurons.include?(iteration)
      map.each_with_index do |cities, neuron_index|
        next if cities.size <= 1
        neuron = Neuron.new
        neuron.move_close_to(@neurons[neuron_index])
        @neurons.insert(neuron_index, neuron)
      end
      puts " New neuron count: #{@neurons.size}"
    end
    
    map.flatten
  end
  
  
  private
  
  def closest(city)
    closest = nil
    closest_dist = nil
    @neurons.each do |n|
      d = Math.rel_distance(city, n.w)
      
      #d = Math.dot_product(
      #  Math.normalize_2d_vector(city), 
      #  Math.normalize_2d_vector(n.w))
      
      if closest.nil? or d < closest_dist
        closest = n
        closest_dist = d
      end
    end
    closest
  end
  
  def neighbors(i,n=1)
    i = @neurons.index(i) if i.is_a?(Neuron)
    s = @neurons.size
    (1..n).map do |x|
      [@neurons[(i+x) % s],
       @neurons[(i-x) % s]]
    end
  end

end
