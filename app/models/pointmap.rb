class Pointmap < ActiveRecord::Base
	belongs_to :user
	validates_presence_of :name, :csv, :kml

	def validate
		if self.csv
		self.csv.gsub!("\r\n|\n\r|\r", "\n")
		self.csv.gsub!(/"/, "")
		locations = []
		lineNum = 0

		self.csv.each_line do |curLine|
			lineNum += 1
			fields = curLine.split(",")
			if fields[1] && fields.size < 3
				errors.add :csv, "Line #{lineNum}: does not contain the minimum 3 fields."
			else
				if fields[0] =~ /label/ #If the file includes a header
					next
				end
				locations << fields[0]

				#Check latitude
				begin
					latitude = fields[1].to_f
					if latitude > 90 or latitude < -90
						errors.add :csv, "Line #{lineNum}: latitude is out of bounds"
					end
				rescue
					errors.add :csv, "Line #{lineNum}: latitude is not in the correct format"
				end

				#Check longitude
				begin
					longitude = fields[2].to_f
					if longitude > 180 or longitude < -180
						errors.add :csv, "Line #{lineNum}: longitude is out of bounds"
					end
				rescue
					errors.add :csv, "Line #{lineNum}: longitude is not in the correct format"
				end

				#Check altitude
				if not fields[3].blank?
					begin
						latitude = fields[3].to_f
					rescue
						errors.add :csv, "Line #{lineNum}: altitude is not in the correct format"
					end
				end

				#Check date
				if not fields[4].blank?
					date = fields[4]
					if !(date =~ /\d{4}-\d{2}-\d{2}/)
						errors.add :csv, "Line #{lineNum}: date is not in the correct format"
					end
				end

				#Check icon
				if not fields[5].blank?
				  icon = fields[5]
				  if not (icon =~ /[A-F,a-f,0-9]{8}/)
		 	        begin
				      uri = URI.parse(fields[5])
				      if uri.class != URI::HTTP
					    errors.add(:url, 'Line #{lineNum}: the icon field is neither a valid color or a valid url')
				      end
				    rescue URI::InvalidURIError
				      errors.add(:url, 'Line #{lineNum}: the icon field is neither a valid color or a valid url')
				    end
				  end
			    end
			end
		end

		#Check for conflicting names
		locations.each_with_index do |location, locIndex|
			locations.each_with_index do |compare, comIndex|
				if location == compare && comIndex > locIndex
					errors.add :csv, "Location #{locIndex+1} and #{comIndex+1} have the same name"
				end
			end
		end
		end
	end

	def writeKml
		self.kml = ""
		self.kml << "<?xml version=\"1.0\" "
		self.kml << "encoding=\"utf-8\"?>\n"
        self.kml << "<kml xmlns=\"http://earth.google.com/kml/2.2\">\n"
        self.kml << "\t<Document>\n"
        if self.oil_spill
        	self.kml << "\t\t<NetworkLink>\n"
        	self.kml << "\t\t\t<open>1</open><name>NOAA Spill Extent</name>\n"
			self.kml << "\t\t\t<Link><href>http://mw1.google.com/mw-earth-vectordb/disaster/gulf_oil_spill/kml/noaa/nesdis_anomaly_rs2.kml</href></Link>\n"
			self.kml << "\t\t</NetworkLink>\n"
		end
        self.kml << "\t\t<Name>Points</Name><open>1</open>\n"

        self.csv.each_line do |curLine|
			fields = curLine.chomp.split(",")

			if fields[0] =~ /label/ #If the file includes a header
				next
			end

			label = fields[0]
			latitude = fields[1]
			longitude = fields[2]
			altitude = fields[3]
			date = fields[4]
			icon = "http://maps.google.com/mapfiles/kml/pushpin/wht-pushpin.png"
			color = ""
			if not fields[5].blank?
			  icon = fields[5] if !(fields[5] =~ /[A-F,a-f,0-9]{8}/)
			  color = fields[5] if fields[5] =~ /[A-F,a-f,0-9]{8}/
			end
			description = fields[6]

			self.kml << "\t\t\t<Placemark>\n"
            self.kml << "\t\t\t\t<name>#{label}</name>\n"
            if not description.blank?
              self.kml << "\t\t\t\t<description>#{description}</description>\n"
            end
            self.kml << "\t\t\t\t<Style><IconStyle><Icon><href>#{icon}</href></Icon>"
            if not color.blank?
            	self.kml << "<color>#{color}</color>"
            end
           	self.kml << "</IconStyle></Style>\n"
            if not date.blank?
            	self.kml << "\t\t\t\t<TimeStamp><when>#{date}</when></TimeStamp>\n"
            end
            self.kml << "\t\t\t\t<Point>\n"
            self.kml << "\t\t\t\t\t<coordinates>#{longitude},#{latitude}"
            if not altitude.blank?
            	self.kml << ",#{altitude}</coordinates>\n"
            	self.kml << "\t\t\t\t\t<altitudeMode>absolute</altitudeMode>\n"
            else
            	self.kml << "</coordinates>\n"
            end
            self.kml << "\t\t\t\t</Point>\n"
            self.kml << "\t\t\t</Placemark>\n"
        end

        self.kml << "\t</Document>\n"
        self.kml << "</kml>"
	end
end
