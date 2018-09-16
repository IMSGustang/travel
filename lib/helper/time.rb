module TimeFormat

	def self.now
			time = Time.new
			return time.strftime("%d/%m/%Y")
	end
	def self.month(numb)
		if numb == '1' or numb == '01'
			return 'Januari'
		elsif numb == '2' or numb == '02'
			return 'Februari'
		elsif numb == '3' or numb == '03'
			return 'Maret'
		elsif numb == '4' or numb == '04'
			return "April"
		elsif numb == '5' or numb == '05'
			return 'Mei'
		elsif numb == '6' or numb == '06'
			return "Juni"
		elsif numb == '7' or numb == '07'
			return "Juli"
		elsif numb == '8' or numb == '08'
			return "Agustus"
		elsif numb == '9' or numb == '09'
			return "September"
		elsif numb == '10' or numb == '010'
			return "Oktober"
		elsif numb == '11' or numb == '011'
			return "November"
		elsif numb == '12' or numb == '012'
			return "Desember"		
		end
	end

	# Format awal Tahun Bulan Tanggal 
	def self.indonesia(time)
		if !time.nil?
			tahun = time[0,4]
			bulan = time[5,2]
			hari = time[8,2]

			return "#{hari}-#{bulan}-#{tahun}"
		else
			return ""
		end
		# Format Akhir tanggal number-bulan tahun
	end

	def self.indonesiaCustom(time, type)
		# h = hari, b = bulan, t = tahun

		# Penggunaan
		# TimeFormat::indonesiaCustom(time, {:format => 'bht', :operator => '-', :locale => 'en'})

		if !time.nil?
			# tahun = time[6,4]
			# bulan = time[0,2]
			# hari = time[3,2]

			if type[:format] == "bht"
				bulan = time[0,2]
				hari = time[3,2]
				tahun = time[6,4]
			elsif type[:format] == "hbt"
				hari = time[0,2]
				bulan = time[3,2]
				tahun = time[6,4]
			end
			if type[:operator] == '/'
				if type[:locale] == 'en'
					return "#{tahun}/#{bulan}/#{hari}"
				else
					return "#{hari}/#{bulan}/#{tahun}"
				end
			else
				if type[:locale] == 'en'
					return "#{tahun}-#{bulan}-#{hari}"
				else
					return "#{hari}-#{bulan}-#{tahun}"
				end
			end
		else
			return "zzz"
		end
	end

	def self.indonesiaMonthAlphabet(time)

		if !time.nil?
			tahun = time[0,4]
			bulan =  self.month(time[5,2])
			hari = time[8,2]

			return "#{hari} #{bulan} #{tahun}"
		else
			return ""
		end
		# Format Akhir tanggal nama-bulan tahun
	end

	def self.system(time)
		if !time.nil?
			tahun = time[6,4]
			bulan = time[3,2]
			hari = time[0,2]

			return "#{tahun}-#{bulan}-#{hari}"
		else
			return ""
		end
	end

	def self.indonesian_day_name(date)
		y, m, d = date.split '-'
		is_date = Date.valid_date? y.to_i, m.to_i, d.to_i

		if is_date
			hari = date.to_date.wday
		else
			hari = -1
		end

		case hari
		when 1
			'Senin'
		when 2
			'Selasa'
		when 3
			'Rabu'
		when 4
			'Kamis'
		when 5
			'Jumat'
		when 6
			'Sabtu'
		when 0
			'Minggu'
		else
			'Unknown Day'
		end
	end

	def self.getUTCTime(time)
		time_only = time[11,5]
		return time_only
	end

end