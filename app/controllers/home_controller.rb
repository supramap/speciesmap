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

   # def oil_spill( fish,oil)
   # @oil = Oil.find(:all)
   # @file = 'goodby'
   # @fish = Fish.find(:all)
   #end
  

  def get_oil_fishkml()
    @kml_text = params[:date] #Oil.first(params[:date] => oil)
    #Oil.find(:first, :conditions => [ "Name = ?",params[:date]). ]find   Client.where("orders_count = #{params[:orders]}")
  end


end
