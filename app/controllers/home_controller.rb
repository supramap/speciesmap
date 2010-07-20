class HomeController < ApplicationController

  def help
  end

  def contact
  end

  def oil_spill
  	@files = {}
  	with_depth = []
  	without_depth = []
  	Dir.new("/home/jori/depthmap/public/files").each do |curFile|
  	  if curFile =~ /_depth.oil.kml/
  	    with_depth << curFile
  	  elsif curFile =~ /oil.kml/
  	    without_depth << curFile
  	  end
  	end
  	@files['with_depth'] = with_depth
  	@files['without_depth'] = without_depth
  end

end
