class Neuron
  attr_reader :w
  
  def initialize
    @w = Array.new(2).map { rand }
  end
  
  def update!(c,a)
    @w[0] += a * (c[0] - @w[0])
    @w[1] += a * (c[1] - @w[1])
  end
  
  def move_close_to(n)
    @w[0] = n.w[0] + (0.01 * (rand-0.5))
    @w[1] = n.w[1] + (0.01 * (rand-0.5))
  end
  
end
