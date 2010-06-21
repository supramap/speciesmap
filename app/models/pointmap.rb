class Pointmap < ActiveRecord::Base
	belongs_to :user
	validates_presence_of :name
	validates_presence_of :csv
	validates_presence_of :kml

	def validate
		if self.csv
		self.csv.gsub!("\r\n|\n\r|\r", "\n")
		locations = []
		lineNum = 0

		self.csv.each_line do |curLine|
			lineNum += 1
			fields = curLine.split(",")
			if fields.size < 3
				errors.add :csv, "Line #{lineNum}: does not contain the minimum 3 fields."
			else
				if fields[0] == "label" #If the file includes a header
					next
				end
				locations << fields[0]

				#Check latitude
				begin
					latitude = fields[1].to_f
					if latitude > 90 || latitude < -90
						errors.add :csv, "Line #{lineNum}: latitude is out of bounds"
					end
				rescue
					errors.add :csv, "Line #{lineNum}: latitude is not in the correct format"
				end

				#Check longitude
				begin
					longitude = fields[2].to_f
					if longitude > 180 || longitude < -180
						errors.add :csv, "Line #{lineNum}: longitude is out of bounds"
					end
				rescue
					errors.add :csv, "Line #{lineNum}: longitude is not in the correct format"
				end

				#Check altitude
				if fields[3]
					begin
						latitude = fields[3].to_f
					rescue
						errors.add :csv, "Line #{lineNum}: altitude is not in the correct format"
					end
				end

				#Check date
				if fields[4]
					date = fields[4]
					if !(date =~ /\d{4}-\d{2}-\d{2}/)
						errors.add :csv, "Line #{lineNum}: date is not in the correct format"
					end
				end

				#Check color
				if fields[5]
					color = fields[5]
					if !(color =~ /[A-F,a-f,0-9]{8}/)
						errors.add :csv, "Line #{lineNum}: color is not in the correct format"
					end
				end
			end
		end

		#Check for conflicting names
		locations.each_with_index do |location, locIndex|
			locations.each_with_index do |compare, comIndex|
				if location == compare && comIndex > locIndex
					errors.add :csv, "Location #{locIndex} and #{comIndex} have the same name"
				end
			end
		end
		end
	end

	def writeKml
		self.kml = ""
		self.kml << "<?xml version=\"1.0\" "
		self.kml << "encoding=\"utf-8\"?>\r\n"
        self.kml << "<kml xmlns=\"http://earth.google.com/kml/2.2\">\r\n"
        self.kml << "\t<Document>\r\n"
        self.kml << "\t\t<Name>Transmissions</Name><open>1</open>\r\n"

        self.csv.each_line do |curLine|
			fields = curLine.split(",")
			label = fields[0]
			latitude = fields[1]
			longitude = fields[2]
			altitude = fields[3]
			date = fields[4]
			color = fields[5]

			self.kml << "\t\t\t<Placemark>\r\n"
            self.kml << "\t\t\t\t<name>#{label}</name>\r\n"
            if color
            	self.kml << "\t\t\t\t<Style><IconStyle><Icon><href>http://maps.google.com/mapfiles/kml/pushpin/wht-pushpin.png</href></Icon><color>#{color}</color></IconStyle></Style>\r\n"
            end
            if date
            	self.kml << "\t\t\t\t<TimeStamp><when>#{date}</when></TimeStamp>\r\n"
            end
            self.kml << "\t\t\t\t<Point>\r\n"
            self.kml << "\t\t\t\t\t<coordinates>#{longitude},#{latitude}"
            if altitude
            	self.kml << ",#{altitude}</coordinates>\r\n"
            	self.kml << "\t\t\t\t\t<altitudeMode>absolute</altitudeMode>\r\n"
            else
            	self.kml << "</coordinates>\r\n"
            end
            self.kml << "\t\t\t\t</Point>\r\n"
            self.kml << "\t\t\t</Placemark>\r\n"
        end

        self.kml << "\t</Document>\r\n"
        self.kml << "</kml>"
	end
end
