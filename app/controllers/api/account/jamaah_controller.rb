class Api::Account::JamaahController < ApplicationController
	skip_before_action :verify_authenticity_token
	include VariableHelper
	require 'rest-client'
	require 'helper/paginator'
	require 'helper/time'
	require 'json'
	require "base64"
	def self.seat(api_url, token, ownership=0)
		begin
			@res = RestClient.get api_url + '/users/ebooking', {
				'x-per-page' => '',
				'x-page' => '',
				'x-is-ownership' => ownership,
				'Authorization' => "Bearer #{token}"
				}

			# return JSON.parse(@res)
			return JSON.parse(@res)
		rescue RestClient::ExceptionWithResponse => err
			@data = JSON.parse(err.response)
			@err_json = {:data => nil}
			return @err_json
		end
	end

	def self.ebookJamaahDetail(api_url, token, no_trans)
		begin
			res = RestClient.get api_url + "/users/ebooking/#{no_trans}", {
				'Authorization' => "Bearer #{token}",
			}
			return JSON.parse(res)
		rescue RestClient::ExceptionWithResponse => e
			@err_json = {:data => nil}
			return @err_json
		end
	end

	def self.detailJamaah(api_url, token, kode)
		begin
			@res = RestClient.get api_url + "/users/jamaah/#{kode}", {
				'Authorization' => "Bearer #{token}"
			}
			return JSON.parse(@res)
		rescue RestClient::ExceptionWithResponse => err
			@data = JSON.parse(err.response)
			@err_json = {:data => nil}
			return @err_json
		end
	end

	def self.detail_jamaah_for_publik(api_url, kode)
		begin
			@res = RestClient.get api_url + "jamaah/#{kode}", {
					'x-client-id' => '1cec286c6a4078358e12f5324c33aaed5486170a950ef893f13b78e096141d6f'
			}
			return JSON.parse(@res)
		rescue RestClient::ExceptionWithResponse => err
			@data = JSON.parse(err.response)
			@err_json = {:data => nil}
			return @err_json
		end
	end

	def self.detail_tiket_for_publik(api_url, kode)
		begin
			@res = RestClient.get api_url + "etiket/#{kode}", {
					'x-client-id' => '1cec286c6a4078358e12f5324c33aaed5486170a950ef893f13b78e096141d6f'
			}
			return JSON.parse(@res)
		rescue RestClient::ExceptionWithResponse => err
			@data = JSON.parse(err.response)
			@err_json = {:data => nil}
			return @err_json
		end
	end

	def self.jamaah(api_url, token, search)
		begin
			@res = RestClient.get api_url + '/users/jamaah', {
					'x-per-page' => '',
					'x-page' => '',
					'x-kode-booking' => search,
					'Authorization' => "Bearer #{token}"
			}
			@json = JSON.parse(@res)
			if @json && @json['status'] == 200
				@page_html = Paginator::render(@json)
				page = {
					:link_prev => "<a class='page-link btn btn-success' href='?page=#{@page_html[:link_prev]}'>Prev</a>",
					:link_next => "<a class='page-link btn btn-success' href='?page=#{@page_html[:link_next]}'>Next</a>",
					:html => @page_html[:page]
				}
			else
				page = nil
			end

			return {:data => @json['data'], :page => page}
		rescue RestClient::ExceptionWithResponse => err
			@data = JSON.parse(err.response)
			@err_json = {:data => nil}
			return @err_json
		end
	end

	def seatDataJamaah
		# render json: params
		begin
      if session[:no_trans].nil?
        begin
          if !params['photo_jamaah'].nil?
            uploader1 = AvatarUploader.new
            uploader1.store!(params['photo_jamaah'])
            uploader1.retrieve_from_store!('')
            image1 = File.open("#{Rails.public_path}/temp-file/#{uploader1.identifier}") {|img| img.read}
            encoded_image1 = Base64.encode64 image1
            image1 = MiniMagick::Image.open("#{Rails.public_path}/temp-file/#{uploader1.identifier}")
            base64_image1 = "data:image/#{image1.type};base64,#{encoded_image1}"
          else
            base64_image1 = " "
          end
          if !params['photo_passpor'].nil?
            uploader2 = AvatarUploader.new
            uploader2.store!(params['photo_passpor'])
            uploader2.retrieve_from_store!('')
            image2 = File.open("#{Rails.public_path}/temp-file/#{uploader2.identifier}") {|img2| img2.read}
            encoded_image2 = Base64.encode64 image2
            image2 = MiniMagick::Image.open("#{Rails.public_path}/temp-file/#{uploader2.identifier}")
            base64_image2 = "data:image/#{image2.type};base64,#{encoded_image2}"
          else
            base64_image2 = " "
          end
        rescue => e
          redirect_to "/data-jamaah" + "?res=fails", :flash => { :message => "Gambar Kosong", :status => true}
        end
        # render json: base64_image1.gsub!(/\s+/, '')
        detailJamaah = Api::Account::JamaahController.detailJamaah(api_url, session[:acc_token], params[:kode_booking])['data']
        user_data = Api::Account::UserProfilController.user_detail(session[:acc_token])
        user = user_data['user']
        user_detail = user_data['detail']
        @res = RestClient.post api_url + "/users/ebooking/isi_data", {
            'no_trans' => detailJamaah['no_trans'],
            'kode_produk' => params[:kode_produk],
            'kode_booking' => params[:kode_booking],
            'kode_kantor' => params[:kode_kantor],
            'ktp_pemesan' => user['ktp'],
            'nama_pemesan' => user['nama_depan'],
            'alamat_pemesan' => user_detail['alamat'],
            'status_pemesan' => params[:status_pemesan],
            'ktp' => params[:ktp],
            'no_paspor' => params[:no_paspor],
            'title' => params[:title],
            'nama_jamaah' => params[:nama_jamaah],
            'jk' => params[:jk],
            'tempat_lahir' => params[:tempat_lahir],
            'tanggal_lahir' => TimeFormat::system(params[:tanggal_lahir]),
            'provinsi_id' => params[:provinsi],
            'kabkot_id' => params[:kota],
            'kecamatan_id' => params[:kecamatan],
            'kelurahan' => params[:kelurahan],
            'alamat' => params[:alamat],
            'telepon' => params[:telepon],
            'keterangan' => params[:keterangan],
            'tanggal_issued_pass' => TimeFormat::system(params[:tanggal_issued_pass]),
            'tanggal_ex_pass' => TimeFormat::system(params[:tanggal_ex_pass]),
            'tempat_terbit_pass' => params[:tempat_terbit_pass],
            'bulan_berangkat' => params[:bulan_berangkat],
            'tahun_berangkat' => params[:tahun_berangkat],
            'pernah_umrah' => params[:pernah_umrah],
            'tanggal_umrah' => TimeFormat::system(params[:tanggal_umrah]),
            'kode_booking_mahrom' => '',
            'hubungan_mahrom' => '',
            'file_foto' => base64_image1.gsub!(/\s+/, ''),
            'file_paspor' => base64_image2.gsub!(/\s+/, '')
        }, {
                                   'Authorization' => "Bearer #{session[:acc_token]}",
                                   'Accept' => 'application/json'
                               }
        redirect_to "/data-jamaah" + "?res=success", :flash => { :message => "Berhasil mendaftarkan jamaah", :status => true}
      else
        @req = RestClient.post api_url + "ownership/alokasi_seat", {
						'kode_paket' => session[:kd_paket],
            'nomor_trans' => session[:no_trans],
            'tanggal' => params[:tgl],
            'alokasi_seat' => 1,
						'kode_booking' => session[:kdbooking],
						'kode_maskapai' => params[:maskapai],
        }, {
             'Authorization' => "Bearer #{session[:acc_token]}",
             'Accept' => 'application/json'
         }

        begin
          if !params['photo_jamaah'].nil?
            uploader1 = AvatarUploader.new
            uploader1.store!(params['photo_jamaah'])
            uploader1.retrieve_from_store!('')
            image1 = File.open("#{Rails.public_path}/temp-file/#{uploader1.identifier}") {|img| img.read}
            encoded_image1 = Base64.encode64 image1
            image1 = MiniMagick::Image.open("#{Rails.public_path}/temp-file/#{uploader1.identifier}")
            base64_image1 = "data:image/#{image1.type};base64,#{encoded_image1}"
          else
            base64_image1 = " "
          end
          if !params['photo_passpor'].nil?
            uploader2 = AvatarUploader.new
            uploader2.store!(params['photo_passpor'])
            uploader2.retrieve_from_store!('')
            image2 = File.open("#{Rails.public_path}/temp-file/#{uploader2.identifier}") {|img2| img2.read}
            encoded_image2 = Base64.encode64 image2
            image2 = MiniMagick::Image.open("#{Rails.public_path}/temp-file/#{uploader2.identifier}")
            base64_image2 = "data:image/#{image2.type};base64,#{encoded_image2}"
          else
            base64_image2 = " "
          end
        rescue => e
          redirect_to "/data-jamaah" + "?res=fails", :flash => { :message => "Gambar Kosong", :status => true}
        end
        # render json: base64_image1.gsub!(/\s+/, '')
        detailJamaah = Api::Account::JamaahController.detailJamaah(api_url, session[:acc_token], params[:kode_booking])['data']
        user_data = Api::Account::UserProfilController.user_detail(session[:acc_token])
        user = user_data['user']
        user_detail = user_data['detail']
        @res = RestClient.post api_url + "/users/ebooking/isi_data", {
            'no_trans' => detailJamaah['no_trans'],
            'kode_produk' => params[:kode_produk],
            'kode_booking' => params[:kode_booking],
            'kode_kantor' => params[:kode_kantor],
            'ktp_pemesan' => user['ktp'],
            'nama_pemesan' => user['nama_depan'],
            'alamat_pemesan' => user_detail['alamat'],
            'status_pemesan' => params[:status_pemesan],
            'ktp' => params[:ktp],
            'no_paspor' => params[:no_paspor],
            'title' => params[:title],
            'nama_jamaah' => params[:nama_jamaah],
            'jk' => params[:jk],
            'tempat_lahir' => params[:tempat_lahir],
            'tanggal_lahir' => TimeFormat::system(params[:tanggal_lahir]),
            'provinsi_id' => params[:provinsi],
            'kabkot_id' => params[:kota],
            'kecamatan_id' => params[:kecamatan],
            'kelurahan' => params[:kelurahan],
            'alamat' => params[:alamat],
            'telepon' => params[:telepon],
            'keterangan' => params[:keterangan],
            'tanggal_issued_pass' => TimeFormat::system(params[:tanggal_issued_pass]),
            'tanggal_ex_pass' => TimeFormat::system(params[:tanggal_ex_pass]),
            'tempat_terbit_pass' => params[:tempat_terbit_pass],
            'bulan_berangkat' => params[:bulan_berangkat],
            'tahun_berangkat' => params[:tahun_berangkat],
            'pernah_umrah' => params[:pernah_umrah],
            'tanggal_umrah' => TimeFormat::system(params[:tanggal_umrah]),
            'kode_booking_mahrom' => '',
            'hubungan_mahrom' => '',
            'file_foto' => base64_image1.gsub!(/\s+/, ''),
            'file_paspor' => base64_image2.gsub!(/\s+/, '')
        }, {
           'Authorization' => "Bearer #{session[:acc_token]}",
           'Accept' => 'application/json'
       }

        # delete session for ownership
				session.delete(:no_trans)
				session.delete(:kd_paket)
				session.delete(:kdbooking)
        # end
        redirect_to "/data-jamaah" + "?res=success", :flash => { :message => "Berhasil mendaftarkan jamaah", :status => true}
      end
		rescue RestClient::ExceptionWithResponse => err
			@data = JSON.parse(err.response)
			redirect_to "/data-jamaah" + "?res=fails", :flash => { :message => @data['message'], :status => true}
			# @err_json = {:data => nil}
			# render json: err.response
		end
	end

	def biayaTambahan
		begin
			@res = RestClient.post api_url + "/users/ebooking/biaya_tambahan", {
				'tanggal_lahir' => TimeFormat::system(params[:tanggal_lahir]),
				'ada_mahrom' => params[:mahrom],
				'pernah_umrah' => params[:pernah_umrah],
				'tanggal_umrah' => TimeFormat::system(params[:tanggal_umrah])
				}, {

				}
			json = JSON.parse(@res)
			render json: {
				'asuransi' => ActionController::Base.helpers.number_to_currency(json['data']['asuransi'], precision: 0, unit: "Rp "),
				'visa_progressif' => ActionController::Base.helpers.number_to_currency(json['data']['visa_progressif'], precision: 0, unit: "Rp "),
				'total' => ActionController::Base.helpers.number_to_currency(json['data']['asuransi'].to_i + json['data']['visa_progressif'].to_i, precision: 0, unit: "Rp ")
			}
		rescue RestClient::ExceptionWithResponse => err
			render json: err
		end
	end

	#KCP (Kantor Cabang Pembantu)
	def self.available_bln(api_url, token, kode)
		begin
			@bln = RestClient.get api_url + "/kcp/available_bulan_tahun/#{kode}", {
					'Authorization' => "Bearer #{token}"
			}
			return JSON.parse(@bln)
		rescue RestClient::ExceptionWithResponse => err
			@data = JSON.parse(err.response)
			@err_json = {:data => nil}
			return @err_json
		end
	end

	def seatDataJamaahkcp
		begin
			@req = RestClient.post api_url + "/kcp/penjualan", {
					'no_transaksi' => session[:kcp_trans],
					'kode_book' => params[:kode_booking],
					'harga_dasar' => session[:harga_dasar],
					'markup' => session[:markup],
					'harga_jual' => session[:harga_jual],
					'diskon' => session[:diskon],
					'ppn' => 0,
					'harga_bayar' => 0,
					'bulan' => session[:bulan],
					'tahun' => params['tahun_berangkat'],
					'keterangan' => "",
			}, {
																 'Authorization' => "Bearer #{session[:acc_token]}",
																 'Accept' => 'application/json'
														 }

			begin
				if !params['photo_jamaah'].nil?
					uploader1 = AvatarUploader.new
					uploader1.store!(params['photo_jamaah'])
					uploader1.retrieve_from_store!('')
					image1 = File.open("#{Rails.public_path}/temp-file/#{uploader1.identifier}") {|img| img.read}
					encoded_image1 = Base64.encode64 image1
					image1 = MiniMagick::Image.open("#{Rails.public_path}/temp-file/#{uploader1.identifier}")
					base64_image1 = "data:image/#{image1.type};base64,#{encoded_image1}"
				else
					base64_image1 = " "
				end
				if !params['photo_passpor'].nil?
					uploader2 = AvatarUploader.new
					uploader2.store!(params['photo_passpor'])
					uploader2.retrieve_from_store!('')
					image2 = File.open("#{Rails.public_path}/temp-file/#{uploader2.identifier}") {|img2| img2.read}
					encoded_image2 = Base64.encode64 image2
					image2 = MiniMagick::Image.open("#{Rails.public_path}/temp-file/#{uploader2.identifier}")
					base64_image2 = "data:image/#{image2.type};base64,#{encoded_image2}"
				else
					base64_image2 = " "
				end
			rescue => e
				redirect_to "/data-jamaah" + "?res=fails", :flash => {:message => "Gambar Kosong", :status => true}
			end
			# render json: base64_image1.gsub!(/\s+/, '')
			detailJamaah = Api::Account::JamaahController.detailJamaah(api_url, session[:acc_token], params[:kode_booking])['data']
			user_data = Api::Account::UserProfilController.user_detail(session[:acc_token])
			user = JSON.parse(user_data)['user']
			user_detail = JSON.parse(user_data)['detail']


			@res = RestClient.post api_url + "/users/ebooking/isi_data", {
					'no_trans' => detailJamaah['no_trans'],
					'kode_produk' => params[:kode_produk],
					'kode_booking' => params[:kode_booking],
					'kode_kantor' => params[:kode_kantor],
					'ktp_pemesan' => user['ktp'],
					'nama_pemesan' => user['nama_depan'],
					'alamat_pemesan' => user_detail['alamat'],
					'status_pemesan' => 'Y',
					'ktp' => params[:ktp],
					'no_paspor' => params[:no_paspor],
					'title' => params[:title],
					'nama_jamaah' => params[:nama_jamaah],
					'jk' => params[:jk],
					'tempat_lahir' => params[:tempat_lahir],
					'tanggal_lahir' => TimeFormat::system(params[:tanggal_lahir]),
					'provinsi_id' => params[:provinsi],
					'kabkot_id' => params[:kota],
					'kecamatan_id' => params[:kecamatan],
					'kelurahan' => params[:kelurahan],
					'alamat' => params[:alamat],
					'telepon' => params[:telepon],
					'keterangan' => params[:keterangan],
					'tanggal_issued_pass' => TimeFormat::system(params[:tanggal_issued_pass]),
					'tanggal_ex_pass' => TimeFormat::system(params[:tanggal_ex_pass]),
					'tempat_terbit_pass' => params[:tempat_terbit_pass],
					'bulan_berangkat' => params[:bulan_berangkat],
					'tahun_berangkat' => params[:tahun_berangkat],
					'pernah_umrah' => params[:pernah_umrah],
					'tanggal_umrah' => TimeFormat::system(params[:tanggal_umrah]),
					'kode_booking_mahrom' => '',
					'hubungan_mahrom' => '',
					'file_foto' => base64_image1.gsub!(/\s+/, ''),
					'file_paspor' => base64_image2.gsub!(/\s+/, '')
			},
														 {
																 'Authorization' => "Bearer #{session[:acc_token]}",
																 'Accept' => 'application/json',
																 'Content-Type' => 'application/json'
														 }


			# delete session for ownership
			session.delete(:bulan)
			session.delete(:harga_dasar)
			session.delete(:markup)
			session.delete(:harga_jual)
			session.delete(:diskon)
			# end
			redirect_to "/app/kcp/invoice/"+ JSON.parse(@req)['data']['kcp_trans'] + "?res=success", :flash => {:message => "Berhasil mendaftarkan jamaah", :status => true}
		rescue RestClient::ExceptionWithResponse => err
			@data = JSON.parse(err.response)
			redirect_to "/data-jamaah" + "?res=fails", :flash => {:message => @data['message'], :status => true}
			# @err_json = {:data => nil}
			# render json: err.response
		end
	end

	def self.getDetailPenjualan(api_url, token, kode)
		begin
			@bln = RestClient.get api_url + "/kcp/penjualan_detail/#{kode}", {
					'Authorization' => "Bearer #{token}"
			}
			return JSON.parse(@bln)
		rescue RestClient::ExceptionWithResponse => err
			@data = JSON.parse(err.response)
			@err_json = {:data => nil}
			return @err_json
		end
	end

	def self.getHistorikcp(api_url, token)
		begin
			@bln = RestClient.get api_url + "/kcp/penjualan_list", {
					'Authorization' => "Bearer #{token}"
			}
			return JSON.parse(@bln)
		rescue RestClient::ExceptionWithResponse => err
			@data = JSON.parse(err.response)
			@err_json = {:data => nil}
			return @err_json
		end
	end
end
