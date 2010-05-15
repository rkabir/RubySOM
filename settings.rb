# Country-specific settings
# select country in ann.rb

module Sahara
  Country = 'sahara'
  Optimal = 27603.0
  Neurons = 30
  NeighborRadius = 10.0
  LearningRate = 0.8
end

module Djibouti
  Country = 'djibouti'
  Optimal = 6656.0
  Neurons = 45
  NeighborRadius = 20.0
  LearningRate = 0.8
end

module Qatar
  Country = 'qatar'
  Optimal = 9352.0
  Neurons = 200
  NeighborRadius = 10.0
  LearningRate = 0.9
end

module Luxembourg
  Country = 'luxembourg'
  Optimal = 11340.0
  Neurons = 1000
  NeighborRadius = 10.0
  LearningRate = 0.8
end

module Nicaragua
  Country = 'nicaragua'
  Optimal = 
  Neurons = 3500
  NeighborRadius = 10.0
  LearningRate = 0.8
end

module Sweden
  Country = 'sweden'
  Optimal = 855597.0
  Neurons = 25500
  NeighborRadius = 10.0
  LearningRate = 0.8
end


# General settings

module Settings
  include eval(Country.capitalize)
  
  # Learning algorithm settings
  Learning = {
    :epochs => 50,
    :rate => LearningRate,
    :neighborhood_radius => (NeighborRadius*Neurons.to_f) / 100.0
  }
  
  # Which iterations to add extra nodes
  AddNeurons = [20,30]
  
  # Which iterations to draw
  Draw = 1..51
  
  # Create route length graph?
  Graph = true
  
end
