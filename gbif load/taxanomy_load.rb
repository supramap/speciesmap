#!/usr/bin/ruby
require 'rubygems'
require 'mysql'
require 'httparty'
require 'xmlsimple'
require 'rexml/document'
require 'net/http'
require 'open-uri'

#@db= Mysql.real_connect("localhost", "root", "password", "gisbank")
#@db = Mysql.real_connect("140.254.80.125", "depthmap", "depthmap$", "depthmap")
@db = Mysql.real_connect("140.254.80.125", "jacob", "password", "depthmap")



def getname id
      url = "http://data.gbif.org/species/#{id}"
      xml_data =  open(url, "Cookie"=> "GbifTermsAndConditions=accepted")
            str =  File.open(xml_data).read

        name = str.match(/<title>.*<\/title>/m)
       nameparts = name.to_s.gsub('\t','').split(' ')
      name = nameparts[1] +' '+nameparts[2]
end


def get_kids gbif_key
  url = "http://data.gbif.org/ws/rest/taxon/get/#{gbif_key}"
  xml_data = Net::HTTP.get_response(URI.parse(url)).body

  doc = REXML::Document.new(xml_data)

  fish =[];
  kids = 	REXML::XPath.each(doc,"//tc:Relationship[tc:relationshipCategory/@rdf:resource='http://rs.tdwg.org/ontology/voc/TaxonConcept#IsParentTaxonOf']")
  kids.each{|x|
    id = x.to_s().match(/[0-9][0-9][0-9]*/)
    name= getname(id)
    @db.query("INSERT INTO depthmap.species(genus_id,name,gbif_key) VALUES(#{@genus_id},'#{name}',#{id})")
    }

  end

pClass = ARGV[0]
Order =''
Family =''
Genus =''

#@db.query("truncate table depthmap.class")
#@db.query("truncate table depthmap.family")
#@db.query("truncate table depthmap.genus")
#@db.query("truncate table `order`")
#@db.query("truncate table depthmap.species;")

@db.query("INSERT INTO depthmap.class(name) VALUES('#{ARGV[0]}')")
class_id = @db.query("SELECT @@IDENTITY").fetch_row()[0]

file = File.open(ARGV[1])do |infile|
  infile.gets
  while (line = infile.gets)
    col = line.strip.split(",")
	#puts col
	#if(col.count > 13)
	#then

    out = @db.query("select id from `order` where name = '#{col[10].strip}'").fetch_row()
    if(out)
       order_id = out[0]
    else
       @db.query("INSERT INTO `order`(class_id,name) VALUES(#{class_id},'#{col[10].strip}')")
       order_id = @db.query("SELECT @@IDENTITY").fetch_row()[0]
    end
    #if(Order != col[10].strip)
    #then
    #Order = col[10].strip
    #   @db.query("INSERT INTO depthmap.order(class_id,name) VALUES(#{class_id},'#{Order}')")
    #   order_id = @db.query("SELECT @@IDENTITY").fetch_row()[0]
    #end


    out = @db.query("select id from depthmap.family where name = '#{col[11].strip}'").fetch_row()
    if(out)
       family_id = out[0]
    else
       @db.query("INSERT INTO depthmap.family(order_id,name) VALUES(#{order_id},'#{col[11].strip}')")
       family_id = @db.query("SELECT @@IDENTITY").fetch_row()[0]
    end

    #if(Family != col[11].strip)
    #then
    #Family = col[11].strip
    #   @db.query("INSERT INTO depthmap.family(order_id,name) VALUES(#{order_id},'#{Family}')")
    #   family_id = @db.query("SELECT @@IDENTITY").fetch_row()[0]
    #end
    #
    Genus =  col[12].strip
    @db.query("INSERT INTO depthmap.genus(family_id,name) VALUES(#{family_id},'#{col[12].strip}')")
    @genus_id = @db.query("SELECT @@IDENTITY").fetch_row()[0]


    #query_string = "INSERT INTO depthmap.species(Kingdom,Phylum,Class,`Order`,Family,Genus,Species,gbif_id ) VALUES('#{col[7]}','#{col[8]}','#{col[9]}','#{col[10]}','#{col[11]}','#{col[12]}','#{col[13]}','#{col[14]}')"

    results = get_kids(col[14])
    #results2 = GbifService.get_items(col[14])

    1+1


  end
end