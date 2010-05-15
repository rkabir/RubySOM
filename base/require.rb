module Require
  
  def self.all(array)
    array.each { |f| Require.folder(f) }
  end
  
  def self.folder(folder)
    Dir[File.dirname(__FILE__) + "/../#{folder}/*.rb"].each do |file|
      require folder + '/' + File.basename(file, File.extname(file))
    end
  end
  
end
