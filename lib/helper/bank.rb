module Bank
	def self.kode(kode)
		if kode == "014"
			return "BCA"
		elsif kode == '536'
			return "BCA SYARIAH"

		elsif kode == "008"
			return "MANDIRI"
		elsif kode == '451'
			return 'MANDIRI SYARIAH'

		elsif kode == '009'
			return 'BNI'
		elsif kode == '009-S'
			return 'BNI SYARIAH'

		elsif kode == '002'
			return 'BRI'
		elsif kode == '422'
			return 'BRI SYARIAH'

		elsif kode == '022'
			return 'CIMB NIAGA'

		elsif kode == '426'
			return 'MEGA'

		elsif kode == '028'
			return 'OCBC NISP'

		elsif kode == '013'
			return 'PERMATA'	

		elsif kode == '200'
			return 'BTN'
		end
	end

	def self.abutours(kode)
		if /Mandiri/i =~ kode
			if /USD/ =~ kode
				bank_mandiri_usd = true
			else
				bank_mandiri = true
			end
		else
			bank_mandiri = false
		end

		if /BCA/i =~ kode
			if /USD/ =~ kode
				bank_bca_usd = true
			else
				bank_bca = true
			end
		else
			bank_bca = false
		end

		if /BRI/i =~ kode
			if /USD/ =~ kode
				bank_bri_usd = true
			else
				bank_bri = true
			end
		else
			bank_bri = false
		end

		if /BNI/i =~ kode
			if /USD/ =~ kode
				bank_bni_usd = true
			else
				bank_bni = true
			end
			
		else
			bank_bni = false
		end

		if /BUKOPIN/i =~ kode
			if /USD/ =~ kode
				bank_bukopin_usd = true
			else
				bank_bukopin = true
			end
		else
			bank_bukopin = false
		end


		if kode == 'MANDIRI-ABUTOURS-COM' || bank_mandiri == true
			data = {
				'id' => 6,
				'kdbank' => 'MANDIRI-ABUTOURS-COM',
				'norekening' => '1520077754444',
				'nama' => 'Mandiri',
				'image' => "lib/payment-icon/MANDIRI.png",
				'curr' => 'IDR'
			}
		elsif kode == 'BCA-ABUTOURS-COM' || bank_bca == true
			data = {
				'id' => 8,
				'kdbank' => 'BCA-ABUTOURS-COM',
				'norekening' => '2907774411',
				'nama' => 'BCA',
				'image' => "lib/payment-icon/BCA.png",
				'curr' => 'IDR'
			}
		elsif kode == 'BRI-ABUTOURS-COM' || bank_bri == true
			data = {
				'id' => 11,
				'kdbank' => 'BCA-ABUTOURS-COM',
				'norekening' => '34301001216307',
				'nama' => 'BRI',
				'image' => "lib/payment-icon/BRI.png",
				'curr' => 'IDR'
			}
		elsif kode == 'BNI-ABUTOURS-COM' || bank_bni == true
			data = {
				'id' => 13,
				'kdbank' => 'BNI-ABUTOURS-COM',
				'norekening' => '7811422444',
				'nama' => 'BNI',
				'image' => "lib/payment-icon/BNI.png",
				'curr' => 'IDR'
			}
		elsif kode == 'BUKOPIN-ABUTOURS' || bank_bukopin == true
			data = {
				'id' => 13,
				'kdbank' => 'BUKOPIN-ABUTOURS',
				'norekening' => '1005693086',
				'nama' => 'BUKOPIN',
				'image' => "lib/payment-icon/BUKOPIN.png",
				'curr' => 'IDR'
			}
		elsif bank_mandiri_usd == true
			data = {
				'id' => 3,
				'kdbank' => 'MANDIRI-USD',
				'norekening' => '1520014295766',
				'nama' => 'Mandiri USD',
				'image' => "lib/payment-icon/MANDIRI.png",
				'curr' => 'USD'
			}
		elsif bank_bca_usd == true
			data = {
				'id' => 9,
				'kdbank' => 'BCA-USD',
				'norekening' => '2907700000',
				'nama' => 'BCA USD',
				'image' => "lib/payment-icon/BCA.png",
				'curr' => 'USD'
			}
		else
			data = {
				'id' => 9,
				'kdbank' => 'Bank Transfer',
				'norekening' => '',
				'nama' => 'BCA USD',
				'image' => "",
				'curr' => 'USD'
			}
		end
		return data
	end
end