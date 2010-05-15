class Array
  
  def to_f!
    self.map! { |e| e.to_f }
  end
  
  def to_f
    self.dup.to_f!
  end
  
  def sum
    self.inject(0) { |sum,e| sum+e }
  end
  
  def average
    f = self.to_f
    f.sum / f.size
  end
  
  def std_dev
    f = self.to_f
    m = f.average
    variance = f.inject(0) { |variance,x| variance += (x - m) ** 2 }
    Math.sqrt(variance / (f.size - 1))
  end
  
  def normalize!
    self.to_f!
    begin
      m = self.min { |a,b| a <=> b }
    rescue
      m = 0.0
    end
    
    if m < 0.0
      m = m.abs
      self.map! { |e| e + m }
    end
    
    s = self.sum
    self.map! { |e| e / s }
  end
  
  def normalize
    self.dup.normalize!
  end
  
  def percentages!
    self.to_f!
    m = self.max { |a,b| a <=> b }
    self.map! { |e| e / m }
  end
  
  def percentages
    self.dup.percentages!
  end
  
  def random_index
    rand(self.size)
  end
  
  def random
    self[self.random_index]
  end
  
  # Find duplicates in arrays
  def dups
    inject({}) {|h,v| h[v]=h[v].to_i+1; h}.reject{|k,v| v==1}.keys
  end
  
  def random_other_index(original_index)
    is = (0..self.size-1).map { |i| i }
    is.delete(original_index)
    is.random
  end
  
  # Crossover two arrays
  def self.crossover(a1, a2, i)
    a1[0..i], a2[0..i] = a2[0..i], a1[0..i]
    [a1, a2]
  end
  
  def swap!(i1, i2)
    self[i1], self[i2] = self[i2], self[i1]
  end
  
  def shuffle
    sort_by { rand }
  end

  def shuffle!
    self.replace shuffle
  end

  def neighbors(i)
    [self[(i-1) % self.size], self[(i+1) % self.size]]
  end
  
  def to_s
    self.join(', ')
  end
  
end
