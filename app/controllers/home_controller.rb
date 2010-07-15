class HomeController < ApplicationController

  def help
  end

  def contact
  end

  def oil_spill
  	@files = []
  	Dir.new("/home/jori/depthmap/public/files").each do |curFile|
  		@files << curFile if curFile =~ /oil.kml/
  	end
  end

end
