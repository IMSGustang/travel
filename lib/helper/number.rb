module Number
	def self.indonesianFormatPhone(numb)
		if numb[0] == '+'
			return numb.gsub('+62', '0') 
		elsif numb[0,2] == '62'
			return numb.gsub('62', '0') 
		elsif numb[0] =='8'
			return numb.gsub('0', '08') 
		else
			return numb		
		end
	end
end