module Strg
	def self.renderHtmlString(text)
		if text.nil?
			return text
		else
			return text.split("\n")
		end
		
	end

	def self.firstLastName(name_params)
		nama = name_params.split(" ")
		jumlah_nama = nama.count()
		nama_depan = []
		nama_belakang = []

		if jumlah_nama >= 3
			(0..jumlah_nama.to_i - 2).each do |i|
				nama_depan << nama[i]
			end
			nama_belakang << nama[jumlah_nama - 1]
		elsif jumlah_nama == 2
			nama_depan << nama[0]
			nama_belakang << nama[1]
		elsif jumlah_nama == 1
			nama_depan << nama[0]
			nama_belakang << nama[0]
		end
		nama_array = {nama_depan: nama_depan.join(' '), nama_belakang: nama_belakang.join()}
		return nama_array
	end

	def self.firstCap(text)
		text.split.map(&:capitalize).join(' ')
	end

	def firstCap(text)
		text.split.map(&:capitalize).join(' ')
	end

	def self.titleize_and_keep_dashes(text)
		text.split.map(&:capitalize).join(' ').split('-').map(&:titleize).join('-')
	end

end