

module Math
  
  def self.logn(x, n)
    self.log(x) / self.log(n)
  end
  
  # Euclidean distance between two point in ND space.
  # Input arguments must be equal size arrays.
  def self.euclidean_distance(p1,p2)
    dist = 0.0
    p1.each_index do |i|
      dist += (p1[i] - p2[i]) ** 2
    end
    Math.sqrt(dist)
  end
  
  def self.rel_distance(c1, c2)
    #((c1[0] - c2[0])).abs + ((c1[1] - c2[1])).abs
    #Math.sqrt(Math.dot_product_e(c1,c2))
    #Math.dot_product_e(c1,c2)
    ((c1[0] - c2[0]) ** 2) + ((c1[1] - c2[1]) ** 2)
  end
  
  def self.dot_product(l1, l2)
      sum = 0.0
      for i in 0...l1.size
          sum += l1[i] * l2[i]
      end
      sum
  end
  
  def self.normalize_2d_vector(v)
    s = v[0] + v[1]
    [v[0]/s, v[1]/s]
  end
    
end