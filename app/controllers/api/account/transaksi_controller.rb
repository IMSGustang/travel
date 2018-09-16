class Api::Account::TransaksiController < ApplicationController
	skip_before_action :verify_authenticity_token
	before_action :Authentication
	include VariableHelper
	require 'rest-client'
	require 'json'
	require "base64"
	require 'fileutils'
	require 'helper/paginator'
	require 'helper/error'
	layout "application_payments"
	# require 'json'
	# $url = api_url
	@url = VariableHelper.api_url
	def pembelianPaket
		if params[:type] == 'umrah-single'
			begin
				@res = RestClient.post api_url + "/penjualan/umrah/#{params['p']}", {}, {
					Authorization: "Bearer #{session[:acc_token]}",
					'x-kode-kantor' => params['kk'],
					'x-metode-bayar' => params['mtd'],
					'x-kode-bank' => params['mb'],
					'x-vouchers' => session[:vc],
					'x-bulan' => params['bln'],
					'x-tahun'=> params['th']
				}
				@data = JSON.parse(@res)['data']
				@data_single = JSON.parse(@res)
				@bank = Api::Account::BankController.listBank(api_url)['data']
				# render json: @data
				if params['mtd'] == 'ABUPAY'
					if mobile_device?
						redirect_to "/m/otp-deposit/#{@data['notrans']}?type=umrah-single"
					else
						redirect_to "/verifikasi-pembayaran/#{@data['notrans']}?type=umrah-single" and return
					end
				else
					if mobile_device?
						render '/mobile/sites/payments/umrah/mobilePaymentBill', layout: 'application_mobile'
					else
						render 'payment/tagihanpembayaran'
					end
				end
				# render json: @data_single
			rescue RestClient::ExceptionWithResponse => err
				if err.response.code == 500
					if params['debug'] == 'true'
						render json: JSON.pretty_generate(Api::HelperController::Error(e, request.original_url, session));
					else
						render '/errors/500', layout: 'application_errors'
					end
				else
					@err_data = JSON.parse(err.response)
					redirect_to request.referer + "&res=fails", :flash => { :message => @err_data['message'], :status => "true"}
				end
			end
		elsif params[:type] == 'kemitraan'
			begin
				@res = RestClient.post api_url + "/penjualan/partnership/#{params['p']}", {}, {
					Authorization: "Bearer #{session[:acc_token]}",
					'x-kode-kantor' => params['kk'],
					'x-metode-bayar' => params['mtd'],
					'x-kode-bank' => params['mb'],
					'x-vouchers' => '',
					'x-bulan' => params['bln'],
					'x-tahun'=> params['th']
				}
				@data = JSON.parse(@res)['data']
				@data_single = JSON.parse(@res)
				@bank = Api::Account::BankController.listBank(api_url)['data'] 
				if params['mtd'] == 'ABUPAY'
					redirect_to "/verifikasi-pembayaran/#{@data['notrans']}?type=kemitraan" and return
				else
					render 'payment/tagihanpembayaran'
				end
				# render json: @data
			rescue RestClient::ExceptionWithResponse => err
				@err_data = JSON.parse(err.response)
				if err.response.code == 500
					if params['debug'] == 'true'
						render json: JSON.pretty_generate(Api::HelperController::Error(e, request.original_url, session));
					else
						render '/errors/500', layout: 'application_errors'
					end
				else
					redirect_to request.referer + "&res=fails", :flash => { :message => @err_data['message'], :status => "true"}
				end
			end
		elsif params[:type] == 'haji'
			begin
				@res = RestClient.post api_url + "/penjualan/haji/#{params['p']}", {}, {
						Authorization: "Bearer #{session[:acc_token]}",
						'x-kode-kantor' => params['kk'],
						'x-metode-bayar' => params['mtd'],
						'x-kode-bank' => params['mb'],
						'x-vouchers' => '',
						'x-bulan' => params['bln'],
						'x-tahun'=> params['th']
				}
				@data = JSON.parse(@res)['data']
				@data_single = JSON.parse(@res)
				@bank = Api::Account::BankController.listBank(api_url)['data']
				if params['mtd'] == 'ABUPAY'
					if mobile_device?
						redirect_to "/m/otp-deposit/#{@data['notrans']}?type=haji"
					else
						redirect_to "/verifikasi-pembayaran/#{@data['notrans']}?type=haji" and return
					end
				else
					if mobile_device?
						render '/mobile/sites/payments/umrah/mobilePaymentBill', layout: 'application_mobile'
					else
						render 'payment/tagihanpembayaran'
					end
				end
					# render json: @data
			rescue RestClient::ExceptionWithResponse => err
				@err_data = JSON.parse(err.response)
				if err.response.code == 500
					if params['debug'] == 'true'
						render json: JSON.pretty_generate(Api::HelperController::Error(e, request.original_url, session));
					else
						render '/errors/500', layout: 'application_errors'
					end
				else
					redirect_to request.referer + "&res=fails", :flash => { :message => @err_data['message'], :status => "true"}
				end
			end
		end
	end

	def konfirmasiTransaksiPaketAbupay
		if params['type'] == 'umrah-single' or params['type'] == 'kemitraan' or params['type'] == 'haji'
			begin
				@res = RestClient.post api_url + "/penjualan/confirm_otp", {}, {
					'Authorization' => "Bearer #{session[:acc_token]}",
					'x-no-transaksi' => params[:kode_paket],
					'x-kode-otp' => params[:otp1] + params[:otp2] + params[:otp3] + params[:otp4] + params[:otp5] + params[:otp6]
				}

				json = JSON.parse(@res)
				# render json: json
				if json['status'] == 200
					redirect_to "/app/umrah/invoice/#{json['data']['notrans']}"
				elsif json['status'] == 400
					
				end
			rescue RestClient::ExceptionWithResponse => err
				json = JSON.parse(err.response)
				redirect_to request.referer + "&res=#{Error::code(json['status'])}", :flash => { :message => json['message'], :status => true, :type => 0}
			end
		elsif params['type'] == 'tiket'
			begin
				@res = RestClient.post api_url + "/ppob/all/konfirmasi", {}, {
					'Authorization' => "Bearer #{session[:acc_token]}",
					'x-kode-transaksi' => params[:kode_paket],
					'x-kode-otp' => params[:otp1] + params[:otp2] + params[:otp3] + params[:otp4] + params[:otp5] + params[:otp6]
				}
				# render json: @res
				json = JSON.parse(@res)
				if json['status'] == 200
					AbuMailer.e_ticket_email(session[:acc_token], params[:kode_paket]).deliver
					redirect_to "/app/tiket/invoice/#{json['data']['kode_transaksi']}"
				elsif json['status'] == 400
					
				end
			rescue RestClient::ExceptionWithResponse => err
				json = JSON.parse(err.response)
				redirect_to "/tiket-pesawat?res=#{Error::code(json['status'])}", :flash => { :message => json['message'], :status => true, :type => 0}
			end
		end
	end

	def self.logTransaksiPaket(api_url, token, per_page = "", page = "", filter, tipe)
		begin
			@res = RestClient.get api_url + "/riwayat_transaksi", {
				'Authorization' => "Bearer #{token}",
				'x-per-page' => per_page,
				'x-page' => page,
				'x-status-bayar' => filter,
				'x-tipe-transaksi' => tipe
			}
			# Paginator
			@json = JSON.parse(@res)
			@page_html = Paginator::render(@json)

			page = {
				:link_prev => "<a class='page-link btn btn-success' href='?page=#{@page_html[:link_prev]}'>Prev</a>",
				:link_next => "<a class='page-link btn btn-success' href='?page=#{@page_html[:link_next]}'>Next</a>",
				:html => @page_html[:page]
			}

			return data = {:data => @json['data'], :page => page}
		rescue RestClient::ExceptionWithResponse => err
			if err.response.code == 500
				if params['debug'] == 'true'
					render json: JSON.pretty_generate(Api::HelperController::Error(e, request.original_url, session));
				else
					render '/errors/500', layout: 'application_errors'
				end
			else
				return {:status => false}
			end
		end
	end

	def self.log_transaksi_paket_detail(api_url, token, no_trans)
		begin
			@res = RestClient.get api_url + "/riwayat_transaksi/#{no_trans}", {
					'Authorization' => "Bearer #{token}"
			}
			# Paginator
			@json = JSON.parse(@res)

			return @json['data']
		rescue RestClient::ExceptionWithResponse => err
			if err.response.code == 500
				if params['debug'] == 'true'
					render json: JSON.pretty_generate(Api::HelperController::Error(e, request.original_url, session));
				else
					render '/errors/500', layout: 'application_errors'
				end
			else
				return {:status => false}
			end
		end
	end

	def konfirmasiPembayaran
		# Handle form kosong
		if params[:jumlah] == ""
			redirect_to "/transaksi-umrah?res=fails", :flash => { :message => "Transaksi Gagal", :status => true, :type => 0}
		else
			begin
				uploader = AvatarUploader.new
				uploader.store!(params['gambar'])
				uploader.retrieve_from_store!('xdk')

				image = File.open(Rails.root.to_s+"/public/temp-file/#{uploader.identifier}") {|img| img.read}
				encoded_image = Base64.encode64 image

				data_image = MiniMagick::Image.open(Rails.root.to_s+"/public/temp-file/#{uploader.identifier}")

				base64_image = "data:image/#{data_image.type};base64,#{encoded_image}"
				
				@res = RestClient.post api_url + "/konfirmasi_bayar", {
					'no_transaksi' => params[:no_transaksi],
					'no_bayar' => params[:no_bayar],
					'metode_bayar' => params[:metode_pembayaran],
					'kode_bank' => params[:kode_bank],
					'jumlah' => params[:jumlah].gsub(/[^0-9]/, ''),
					'keterangan' => params[:keterangan],
					'file' => base64_image.gsub!(/\s+/, '')
				}, {
					'Authorization' => "Bearer #{session[:acc_token]}"
				}
				@json = JSON.parse(@res)
				if request[:type] == "haji"
				redirect_to "/transaksi-haji?res=success", :flash => { :message => 'Konfirmasi telah berhasil', :status => true, :type => 0}
				else
				redirect_to "/transaksi-umrah?res=success", :flash => { :message => 'Konfirmasi telah berhasil', :status => true, :type => 0}
				end
			rescue RestClient::ExceptionWithResponse => err
				# render json: err.response
				if err.response.code == 500
					if params['debug'] == 'true'
						render json: JSON.pretty_generate(Api::HelperController::Error(e, request.original_url, session));
					else
						render '/errors/500', layout: 'application_errors'
					end
				else
					@err_data = JSON.parse(err.response)
					redirect_to "/transaksi-umrah?res=fails", :flash => { :message => @err_data['message'], :status => true, :type => 0}
				end
			end
		end
		
	end

	def self.konfirmasiPembayaranDetail(api_url, token, kode)
		begin
			res = RestClient.get api_url + "/pembayaran/#{kode}", {
				'Authorization' => "Bearer #{token}"
			}
			json_res = JSON.parse(res)
			get_bank = Api::Account::BankController.listBank(api_url)

			bank = get_bank['data'].select {|e| e['kdbank'] == json_res['data']['kdbank']}
			data = {:data => json_res, :bank => bank}
			return data
		rescue RestClient::ExceptionWithResponse => err
			error = JSON.parse(err.response)
			return error
		end
	end

	# TOPUP DEPOSIT ABUPAY
	def abupayDeposit
		begin
			@res = RestClient.post api_url + "/saldo/topup", {

			}, {
				'Authorization' => "Bearer #{session[:acc_token]}",
				'Content-Type' => 'application/json',
				'x-kode-bank' => params[:bank],
				'x-nominal' => params[:nominal].gsub(/[^0-9]/, '')
			}
			data = JSON.parse(@res)
			# render json: data['data']['kode'] and return
			redirect_to "/tambah-saldo-abupay/"+ data['data']['kode'] +"/tagihan?res=success", :flash => { :message => 'Berhasil melakukan transaksi', :status => true}
		rescue RestClient::ExceptionWithResponse => err
			res = JSON.parse(err.response)
			redirect_to "/tambah-saldo-abupay?res=fails", :flash => { :message => "Gagal melakukan transaksi, #{res['message']}", :status => true}
			# render json: err.response
		end
	end

	def self.logAbupayDeposit(token)
		begin
			@res = RestClient.post @url + "/mutasi/topup", {}, {
				'Authorization' => "Bearer #{token}",
			}
			return @res
		rescue RestClient::ExceptionWithResponse => err
			# redirect_to "/tambah-saldo-abupay?res=fails", :flash => { :message => 'Gagal melakukan transaksi', :status => true}
			# render json: err.response
		end
	end

	def self.konfirmasiTopUpAbupayDetail(token, kode)
		begin
			@res = RestClient.get @url + "/mutasi/topup/#{kode}", {
				'Authorization' => "Bearer #{token}"
			}
			puts JSON.parse(@res)
			return JSON.parse(@res)
		rescue RestClient::ExceptionWithResponse => err
			puts err.response
			return err.response
		end
	end

	def self.bankAbupayDetail(token, kode)
		begin
			@res = RestClient.get @url + "/bank/#{kode}", {
					'Authorization' => "Bearer #{token}"
			}
			render json: @res
		rescue RestClient::ExceptionWithResponse => err
			render json: err.response
		end
	end

	def konfirmasiTopUpAbupay
		begin
			uploader = AvatarUploader.new
			uploader.store!(params['gambar'])
			uploader.retrieve_from_store!('xdk')

			image = File.open(Rails.root.to_s+"/public/temp-file/#{uploader.identifier}") {|img| img.read}
			encoded_image = Base64.encode64 image

			data_image = MiniMagick::Image.open(Rails.root.to_s+"/public/temp-file/#{uploader.identifier}")

			base64_image = "data:image/#{data_image.type};base64,#{encoded_image}"
			@res = RestClient.post api_url + "/saldo/konfirmasi-topup",{
					'kode_transaksi' => params[:no_transaksi],
					'nominal' => params[:jumlah].gsub(/[^0-9]/, ''),
					'bank_penerima' => params[:kode_bank],
					'bukti_transfer' => base64_image.gsub!(/\s+/, '')
			}, {
				'Authorization' => "Bearer #{session[:acc_token]}"
			}
			redirect_to "/transaksi-abupay?res=success", :flash => { :message => JSON.parse(@res)['message'], :status => true}
		rescue RestClient::ExceptionWithResponse => err
			if params['debug'] == 'true'
				render json: JSON.pretty_generate(Api::HelperController::Error(e, request.original_url, session));
			else
				render '/errors/500', layout: 'application_errors'
			end
		end
	end

	# TIKET
	def self.metodePembayaranTiketDetail(app_token, tiket_token, id)
		begin
			@res = RestClient.get @url + "/ppob/all/history/#{id}", {
				'Authorization' => "Bearer #{app_token}"
			}
			return JSON.parse(@res)
		rescue RestClient::ExceptionWithResponse => err
			return JSON.parse(err.response)
		end
	end

	def self.metodePembayaranTiketDetailNew(app_token, tiket_token, id)
		begin
			@res = RestClient.get @url + "/ppob/history/#{id}", {
					'Authorization' => "Bearer #{app_token}"
			}
			return JSON.parse(@res)['data']
		rescue RestClient::ExceptionWithResponse => err
			return JSON.parse(err.response)
		end
	end

	def metodePembayaranTiket
		begin
			@res = RestClient.get api_url + "/ppob/all/choose-payment?v=#{params['mt']}&kodeTransaksi=#{params['kt']}&kodeBank=#{params['kb']}", {
				'Authorization' => "Bearer #{session[:acc_token]}"
			}
			detail = Api::Account::TransaksiController.metodePembayaranTiketDetail(session[:acc_token], session[:tiket], params['kt'])
			# Jika Pembayaran menggunakan Abupay
			if params['mt'] == '3'

				unless session[:account_saldo] < detail['dataMain']['harga']
					begin
						@res2 = RestClient.get api_url + "/ppob/all/otp", {
							'Authorization' => "Bearer #{session[:acc_token]}",
							'x-kode-transaksi' => params['kt']
						}
					rescue RestClient::ExceptionWithResponse => e
						puts e.response
					end
					# render json: @res
					redirect_to "/verifikasi-pembayaran/#{params['kt']}?type=tiket" and return
				else
					redirect_to request.referer + "&res=fails", :flash => { :message => "Saldo deposit Anda tidak mencukupi", :status => "true"}
				end
				
			else
				redirect_to "/app/tiket/invoice/#{params['kt']}" and return
			end
			# render json: @res

		rescue RestClient::ExceptionWithResponse => err
			if params['debug'] == 'true'
				render json: JSON.pretty_generate(Api::HelperController::Error(e, request.original_url, session));
			else
				render '/errors/500', layout: 'application_errors'
			end
		end
	end

	def konfirmasiTiket
		begin
			uploader = AvatarUploader.new
			uploader.store!(params['gambar'])
			uploader.retrieve_from_store!('xdk')

			image = File.open(Rails.root.to_s+"/public/temp-file/#{uploader.identifier}") {|img| img.read}
			encoded_image = Base64.encode64 image

			data_image = MiniMagick::Image.open(Rails.root.to_s+"/public/temp-file/#{uploader.identifier}")

			base64_image = "data:image/#{data_image.type};base64,#{encoded_image}"

			@res = RestClient.post api_url + "/ppob/all/konfirmasi", {
					'kodeTransaksi' => params[:no_bayar],
					'bankPenerima' => params[:kode_bank],
					'nominal' => params[:jumlah].gsub(/[^0-9]/, ''),
					'bukti_transfer' => base64_image
				}, {
					'Authorization' => "Bearer #{session[:acc_token]}",
					'x-kode-transaksi' => params['no_transaksi']
				}
			json = JSON.parse(@res)
			if json['status'] == 200
				redirect_to "/transaksi-tiket?res=success", :flash => { :message => JSON.parse(@res)['message'], :status => true}
			end
		rescue RestClient::ExceptionWithResponse => err
			if err.response.code == 500
				if params['debug'] == 'true'
					render json: JSON.pretty_generate(Api::HelperController::Error(e, request.original_url, session));
				else
					render '/errors/500', layout: 'application_errors'
				end
			else
				@err_data = JSON.parse(err.response)
				redirect_to "/transaksi-tiket?res=fails", :flash => { :message => JSON.parse(@res)['message'], :status => true}
			end
			
		end
	end
end
