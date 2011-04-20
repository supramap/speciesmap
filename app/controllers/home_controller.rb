require 'net/http'
require 'open-uri'

class HomeController < ApplicationController

  def help
  end

  def contact
  end

  def news

  end

  def oil_spill
    #@oil = Oil.find(:all)
    #@file = 'hello'
    #@fish = Fish.find(:all)
  end

  def getOrder()
   items =Array.new
   ActiveRecord::Base.connection.execute("SELECT id,name FROM `order` where class_id=#{params[:id]}").each { |c|   items << c}
    render :json  => items
  end


   def getFamily()
        items =Array.new
        ActiveRecord::Base.connection.execute("SELECT id,name FROM family where order_id=#{params[:id]}").each { |c|   items << c}
        render :json  => items
   end

   def getGenus()
      items =Array.new
      ActiveRecord::Base.connection.execute("SELECT id,name FROM genus where family_id=#{params[:id]}").each { |c|   items << c}
      render :json  => items
   end


   def getSpecies()
      items =Array.new
      ActiveRecord::Base.connection.execute("SELECT id,name,gbif_key FROM species where genus_id=#{params[:id]}").each { |c|   items << c}
      render :json  => items
   end

  

  def get_oil_fishkml()
    @kml_text = params[:date] #Oil.first(params[:date] => oil)
    #Oil.find(:first, :conditions => [ "Name = ?",params[:date]). ]find   Client.where("orders_count = #{params[:orders]}")
  end

  def getKML
      url = "http://data.gbif.org/occurrences/taxon/placemarks/taxon-placemarks-#{params[:id]}.kml"
      xml_data =  open(url, "Cookie"=> "GbifTermsAndConditions=accepted")
      str =  File.open(xml_data).read

      oil = File.open("OilSpillpart.txt", "r").read



      send_data str.gsub("</Document>",oil+"</Document>"),  :filename => "#{params[:name]}.kml", :type => "kml", :disposition => 'attachment'

  end

end
