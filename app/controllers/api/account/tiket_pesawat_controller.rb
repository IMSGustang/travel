class Api::Account::TiketPesawatController < ApplicationController
	skip_before_action :verify_authenticity_token
	before_action :Authentication, except: [:check_updated_flights]
  	include VariableHelper
  	require 'helper/strg'
  	require 'helper/time'
  	@api = VariableHelper.api_url

	def self.bandara(app_token, tiket_token)
		begin
			@res = RestClient.get @api + "/ppob/pesawat/list-airport?token=#{tiket_token}",{
				'Authorization' => "Bearer #{app_token}"
			}
			return JSON.parse(@res)['all_airport']['airport']
		rescue RestClient::ExceptionWithResponse => err
			@err = JSON.parse(err.response)
      		return @err
		end
	end

	def self.bandaraTerdekat(app_token, tiket_token)
		begin
			myIp = Net::HTTP.get(URI.parse('http://checkip.amazonaws.com/')).squish
			@res = RestClient.get @api + "/ppob/pesawat/get-nearest-airport?ip=#{myIp}", {
				'Authorization' => "Bearer #{app_token}"
			}
			return JSON.parse(@res)
		rescue RestClient::ExceptionWithResponse => err
			@err = JSON.parse(err.response)
      		return @err
		end
	end

	def self.pencarianMaskapai(app_token, tiket_token, keberangkatan, tujuan, tanggal_berangkat, dewasa = 0, anak = 0, balita = 0, tanggal_pulang = nil)
		begin
			@res = RestClient.get @api + "/ppob/pesawat/search-flight?token=#{tiket_token}&d=#{keberangkatan}&a=#{tujuan}&date=#{tanggal_berangkat}&ret_date=#{tanggal_pulang}&adult=#{dewasa}&child=#{anak}&infant=#{balita}", {
				'Authorization' => "Bearer #{app_token}"
			}
			@res = JSON.parse(@res)
			return @res
		rescue RestClient::ExceptionWithResponse => err
			return err.response
		end
	end

	def self.infoPenumpang(app_token, tiket_token, flightid, ret_flightid = nil)

		begin
			@res = RestClient.get @api + "/ppob/pesawat/get-flight-data?token=#{tiket_token}&flight_id=#{flightid}&ret_flight_id=#{ret_flightid}", {
				'Authorization' => "Bearer #{app_token}"
			}
			return JSON.parse(@res)
		rescue RestClient::ExceptionWithResponse => err
			return err.response
		end	
	end

	def self.listCountry(app_token, tiket_token)
		begin
			@res = RestClient.get @api + "/ppob/pesawat/list-country?token=#{tiket_token}", {
				'Authorization' => "Bearer #{app_token}"
			}
			return JSON.parse(@res)
		rescue RestClient::ExceptionWithResponse => err
			return err.response
		end
	end

	def self.listCountryForRenderToHtml(app_token, tiket_token)
		begin
			@res = RestClient.get @api + "/ppob/pesawat/list-country?token=#{tiket_token}", {
				'Authorization' => "Bearer #{app_token}"
			}
			json = JSON.parse(@res)

			data = []
			json['listCountry'].each do |item|
				data << {'id' => item['country_id'], 'name' => item['country_name']}
			end
			return data
		rescue RestClient::ExceptionWithResponse => err
			return err.response
		end
		
	end

	def XHRinfoPenumpang
		tiket_token = session[:tiket]
		app_token = session[:acc_token]
		flightid = params[:flightid]
		begin
			@res = RestClient.get api_url + "/ppob/pesawat/get-flight-data?token=#{tiket_token}&flight_id=#{flightid}", {
				'Authorization' => "Bearer #{app_token}"
			}
			render json: @res
		rescue RestClient::ExceptionWithResponse => err
			render json: err.response
		end	
	end

	def registrasiPenumpang
		
		begin
			# Jumlah penumpang
			penumpang = params[:penumpang]

			# Cek Data Order
			data_penumpang = Api::Account::TiketPesawatController.infoPenumpang(session[:acc_token], session[:tiket], params[:fi], params[:rfi])

			# Data Jumlah Penumpang
			data_penumpang_dewasa = data_penumpang['departures']['count_adult'].to_i
			data_penumpang_anak = data_penumpang['departures']['count_child'].to_i
			data_penumpang_balita = data_penumpang['departures']['count_infant'].to_i

			@url = []
			# Informasi Pemumpang
			if params['rfi'] != ""
				@url << URI.encode("/two?token=#{session[:tiket]}&flight_id=#{params[:fi]}&ret_flight_id=#{params[:rfi]}&adult=#{data_penumpang_dewasa}&child=#{data_penumpang_anak}&infant=#{data_penumpang_balita}")
			else
				@url << URI.encode("?token=#{session[:tiket]}&flight_id=#{params[:fi]}&adult=#{data_penumpang_dewasa}&child=#{data_penumpang_anak}&infant=#{data_penumpang_balita}")
			end

			# Data tambahan diambil langsung dari API

			# mengambil array dari params
			params_array = params.except('controller', 'action', 'rfi', 'fi').keys

			#mengambil array dari data tiket
			info_flight = Api::Account::TiketPesawatController.infoPenumpang(session[:acc_token], session[:tiket], params['fi'], params['rfi'])
			# Hasil filter array (mengeluarkan data yang tidak ada pada params array)
			params_array_same = params_array - info_flight['required'].keys
			params_result = params_array - params_array_same

			@array_to_url = []
			params_result.each do |item|
				if params[item] =~ /^\d{1,2}\/\d{1,2}\/\d{4}$/
					@array_to_url << {"#{item}" => TimeFormat::system(params[item])}
				else
					@array_to_url << {"#{item}" => params[item]}
				end
				
			end

			replacment_finder = [
				{:finder => '{', :replacement => ''},
				{:finder => '}', :replacement => ''},
				{:finder => '[', :replacement => ''},
				{:finder => ']', :replacement => ''},
				{:finder => ']', :replacement => ''},
				{:finder => '"', :replacement => ''},
				{:finder => '=>', :replacement => '='},
				{:finder => ', ', :replacement => '&'},
			]
			@array_url = @array_to_url
			replacment_finder.each do |replace|
				@array_url = @array_url.to_s.gsub(replace[:finder], replace[:replacement])
			end
			@url << "&"+@array_url

			# Data Pemesan
			conNamaLF = Strg::firstLastName(params[:connama])
			@url << URI.encode("&conSalutation=#{params[:contitle]}&conFirstName=#{conNamaLF[:nama_depan]}&conLastName=#{conNamaLF[:nama_belakang]}&conPhone=#{params[:conphone]}&conEmailAddress=#{params[:conemail]}")
			(1..data_penumpang_dewasa.to_i).each do |dewasa|
				dtitle = "dtitle#{dewasa}"
				dnama = "dnama#{dewasa}"
				dbday = "dbday#{dewasa}"
				dpassport = "dpassport#{dewasa}"
				dpassportno = "dpassportno#{dewasa}"
				dpassportExpiryDate = "dpassportExpiryDate#{dewasa}"
				dpassportissuing = "dpassportissuing#{dewasa}"
				nama = Strg::firstLastName(params[dnama])
				@url << URI.encode("&separator_adult#{dewasa}=&titlea#{dewasa}=#{params[dtitle]}&firstnamea#{dewasa}=#{nama[:nama_depan]}&lastnamea#{dewasa}=#{nama[:nama_belakang]}&birthdatea#{dewasa}=#{TimeFormat::system(params[dbday])}&passportnationalitya#{dewasa}=#{params[dpassport]}&passportnoa#{dewasa}=#{params[dpassportno]}&passportExpiryDatea#{dewasa}=#{TimeFormat::system(params[dpassportExpiryDate])}&passportissuinga#{dewasa}=#{params[dpassportissuing]}")
			end

			(1..data_penumpang_anak.to_i).each do |anak|
				atitle = "atitle#{anak}"
				anama = "anama#{anak}"
				abday = "abday#{anak}"
				apassport = "apassport#{anak}"
				apassportno = "apassportno#{anak}"
				apassportExpiryDate = "apassportExpiryDate#{anak}"
				apassportissuing = "apassportissuing#{anak}"
				nama = Strg::firstLastName(params[anama])
				@url << URI.encode("&separator_child#{anak}=&titlec#{anak}=#{params[atitle]}&firstnamec#{anak}=#{nama[:nama_depan]}&lastnamec#{anak}=#{nama[:nama_belakang]}&birthdatec#{anak}=#{TimeFormat::system(params[abday])}&passportnationalityc#{anak}=#{params[apassport]}&passportnoc#{anak}=#{params[apassportno]}&passportExpiryDatec#{anak}=#{TimeFormat::system(params[apassportExpiryDate])}&passportissuingc#{anak}=#{params[apassportissuing]}")
			end

			(1..data_penumpang_balita.to_i).each do |balita|
				btitle = "btitle#{balita}"
				bnama = "bnama#{balita}"
				bbday = "bbday#{balita}"
				bpassport = "bpassport#{balita}"
				bpassportno = "bpassportno#{balita}"
				bpassportExpiryDate = "bpassportExpiryDate#{balita}"
				bpassportissuing = "bpassportissuing#{balita}"
				nama = Strg::firstLastName(params[bnama])
				@url << URI.encode("&separator_infant#{balita}=&titlei#{balita}=#{params[btitle]}&firstnamei#{balita}=#{nama[:nama_depan]}&lastnamei#{balita}=#{nama[:nama_belakang]}&birthdatei#{balita}=#{TimeFormat::system(params[bbday])}&passportnationalityi#{balita}=#{params[bpassport]}&passportnoi#{balita}=#{params[bpassportno]}&passportExpiryDatei#{balita}=#{TimeFormat::system(params[bpassportExpiryDate])}&passportissuingi#{balita}=#{params[bpassportissuing]}")
			end

			

			# Request API
			@res = RestClient.get api_url + "/ppob/pesawat/add-order#{@url.join.to_s.squish}", {
				'Authorization' => "Bearer #{session[:acc_token]}"
			}
			err_validation = JSON.parse(@res)

			if err_validation['diagnostic']['status'] == 200 || err_validation['diagnostic']['status'] == "200"
				if !err_validation['dataTransaksiDetail'].to_a[1].nil?
					two_flight = err_validation['dataTransaksiDetail'][1]['flight_id']
				else
					two_flight = ""
				end
				redirect_to "/pilih-metode-pembayaran/tiket?fi=#{err_validation['dataTransaksiDetail'][0]['flight_id']}&rfi=#{two_flight}&kt=#{err_validation['dataTransaksi']['kode_transaksi']}"
			else
				redirect_to request.referer + "&res=fails", :flash => { :message => err_validation['diagnostic']['error_msgs'], :status => "true"}
			end
			#-----------------------------
			# render json: err_validation
			#-----------------------------
		rescue RestClient::ExceptionWithResponse => err
			if err.response.code == 500
				render '/errors/500', layout: 'application_errors'
			else
				render json: err.response
			end
			# render json: err.response
		end
	end

	def invoiceTiket
		begin
			@data = Api::Account::TransaksiController.metodePembayaranTiketDetail(session[:acc_token], session[:tiket], params[:kode])
			if @data['jenisPembayaran'] == "BANK TRANSFER"
				render '/payment/tagihanpembayarantiket', layout: 'application_payments'
			elsif @data['jenisPembayaran'] == "DEPOSIT"
				render 'accounts/evoucher/pay-invoice', layout: 'application', locals: {data: @data}
				# render json: @data
			end
			# render json: @data
		rescue RestClient::ExceptionWithResponse => err
			render json: err
		end
	end

	def self.historyTiket(app_token, tiket_token, filter, kode_transaksi = "")
		begin
			@res = RestClient.get @api + "/ppob/history/#{kode_transaksi}", {
				'Authorization' => "Bearer #{app_token}",
        		'x-tipe' => 'pesawat'
			}
			json = JSON.parse(@res)['data']
			return json
		rescue RestClient::ExceptionWithResponse => err
			return err.response
		end
	end

	def self.eTiket(app_token, kode)
		begin
			@res = RestClient.get @api + "/ppob/pesawat/detail-order?kode_transaksi=#{kode}", {
				'Authorization' => "Bearer #{app_token}"
			}
			# puts @res
			return JSON.parse(@res)
		rescue RestClient::ExceptionWithResponse => err
			return err.response
		end
	end

	def self.paymetChecker(app_token, kode)
		begin
			@res = RestClient.get @api + "/ppob/all/available-payment/#{kode}", {

			}
			return JSON.parse(@res)
		rescue RestClient::ExceptionWithResponse => err
			return err.response
		end
	end

	def check_updated_flights
		d = params[:d]
		a = params[:a]
		date = params[:date]
		@res = RestClient.get api_url + "/ppob/pesawat/check-updated?token=#{session[:tiket]}&d=#{d}&a=#{a}&date=#{date}",{
				'Authorization' => "Bearer #{session[:acc_session]}"
		}
		Rails.logger.info(@res)
		render json: JSON.parse(@res)
	rescue RestClient::ExceptionWithResponse => err
		@err = JSON.parse(err.response)
		render @err
	end
end
