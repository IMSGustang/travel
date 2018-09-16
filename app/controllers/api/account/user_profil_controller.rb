class Api::Account::UserProfilController < ApplicationController
	skip_before_action :verify_authenticity_token
	before_action :Authentication
	include VariableHelper
	require 'helper/strg'
	require 'rest-client'
	require 'json'
	require "base64"

	# Variable Set
	@url = VariableHelper.api_url

	def updateProfil
		# Base64 Image Encode
		if !params['photo'].nil?
			begin
				uploader = AvatarUploader.new
				uploader.store!(params['photo'])
				uploader.retrieve_from_store!('')

				image = File.open("#{Rails.public_path}/temp-file/#{uploader.identifier}") {|img| img.read}
				encoded_image = Base64.encode64 image

				image = MiniMagick::Image.open("#{Rails.public_path}/temp-file/#{uploader.identifier}")

				base64_image = "data:image/#{image.type};base64,#{encoded_image}"
				nama = Strg::firstLastName(params[:nama])
				@res = RestClient.put api_url + "/user_details/#{session[:account_detail][:id]}" ,{
					'nama_depan' => nama[:nama_depan],
					'nama_belakang' => nama[:nama_belakang],
					'tempat_lahir' => params[:tempat_lahir],
					'tanggal_lahir' => params[:tgl_lahir].gsub('/', '-'),
					'jk' => params[:jk],
					'email' => params[:email],
					'ktp' => params[:ktp],
					'telepon_rumah' => params[:telepon_rumah],
					'id_provinsi' => params[:id_provinsi],
					'id_kabkot' => params[:id_kabkot],
					'id_kecamatan' => params[:id_kecamatan],
					'kelurahan' => '',
					'alamat' => params[:alamat],
					'nama_kerabat' => '',
					'alamat_kerabat' => '',
					'telepon_kerabat' => '',
					'foto' => base64_image.gsub!(/\s+/, '')				
				}, {
					'Authorization' => "Bearer #{session[:acc_token]}",
					'Accept' => 'application/json',
					'Content-Type' => 'application/json'
				}
				# render json: encoded_image
				@json = JSON.parse(@res)
				redirect_to '/pengaturan-akun-profile?res=success', :flash => { :message => "Profil berhasil diperbaharui", :status => true}
			rescue RestClient::ExceptionWithResponse => err
				if err.response.code == 500
					render '/errors/500', layout: 'application_errors'
				else
					redirect_to '/pengaturan-akun-profile?res=fails', :flash => { :message => JSON.parse(err.response)['message'], :status => true}
				end
			end
		else
			begin
				@res = RestClient.put api_url + "/user_details/#{session[:account_detail][:id]}" ,{
					'nama_depan' => params[:nama],
					'tempat_lahir' => params[:tempat_lahir],
					'tanggal_lahir' => params[:tgl_lahir].gsub('/', '-'),
					'jk' => params[:jk],
					'email' => params[:email],
					'ktp' => params[:ktp],
					'telepon_rumah' => params[:telepon_rumah],
					'id_provinsi' => params[:id_provinsi],
					'id_kabkot' => params[:id_kabkot],
					'id_kecamatan' => params[:id_kecamatan],
					'kelurahan' => '',
					'alamat' => params[:alamat],
					'nama_kerabat' => '',
					'alamat_kerabat' => '',
					'telepon_kerabat' => ''			
				}, {
					'Authorization' => "Bearer #{session[:acc_token]}",
					'Accept' => 'application/json',
					'Content-Type' => 'application/json'
				}
				@json = JSON.parse(@res)
				redirect_to '/pengaturan-akun-profile?res=success', :flash => { :message => "Profil berhasil diperbaharui", :status => true}
			rescue RestClient::ExceptionWithResponse => err
				if err.response.code == 500
					render '/errors/500', layout: 'application_errors'
				else
					redirect_to '/pengaturan-akun-profile?res=fails', :flash => { :message => JSON.parse(err.response)['message'], :status => true}
				end
			end
		end
	end

	def update_profil_mobile
		# Base64 Image Encode
		begin
			user_detail = JSON.parse(Api::Account::UserProfilController.user_detail(session[:acc_token]))

			@res = RestClient.put api_url + "/user_details/#{session[:account_detail][:id]}" ,{
					'nama_depan' => params[:nama_depan],
					'nama_belakang' => params[:nama_belakang],
					'tempat_lahir' => params[:tempat_lahir],
					'tanggal_lahir' => params[:tgl_lahir].gsub('/', '-'),
					'jk' => params[:jk],
					'email' => user_detail['user']['email'],
					'ktp' => user_detail['user']['ktp'],
					'telepon_rumah' => user_detail['detail']['telepon_rumah'],
					'id_provinsi' => user_detail['detail']['id_provinsi'],
					'id_kabkot' => user_detail['detail']['id_kabkot'],
					'id_kecamatan' => user_detail['detail']['id_kecamatan'],
					'kelurahan' => '',
					'alamat' => user_detail['detail']['alamat'],
					'nama_kerabat' => '',
					'alamat_kerabat' => '',
					'telepon_kerabat' => ''
			}, {
					'Authorization' => "Bearer #{session[:acc_token]}",
					'Accept' => 'application/json',
					'Content-Type' => 'application/json'
			}
			@json = JSON.parse(@res)
			redirect_to '/pengaturan-akun-profile?res=success', :flash => { :message => "Profil berhasil diperbaharui", :status => true}
		rescue RestClient::ExceptionWithResponse => err
			if err.response.code == 500
				render '/errors/500', layout: 'application_errors'
			else
				redirect_to '/pengaturan-akun-profile?res=fails', :flash => { :message => JSON.parse(err.response)['message'], :status => true}
			end
		end
	end

	def update_profiPembelian
		begin
			profil = Api::Account::UserProfilController.user_detail(session[:acc_token])
			@profil_detail = JSON.parse(profil)['detail']
			@res = RestClient.put api_url + "/user_details/#{session[:account_detail][:id]}" ,{
				'nama_depan' => params[:nama],
				'tempat_lahir' => params[:tempat_lahir],
				'tanggal_lahir' => params[:tanggal_lahir].gsub('/', '-'),
				'email' => params[:email],
				'ktp' => params[:ktp],
				'alamat' => params[:alamat_lengkap],

				'jk' => JSON.parse(profil)['user']['jk'],
				'telepon_rumah' => @profil_detail[:telepon_rumah],
				'id_provinsi' => @profil_detail[:id_provinsi],
				'id_kabkot' => @profil_detail[:id_kabkot],
				'id_kecamatan' => @profil_detail[:id_kecamatan],
			}, {
				'Authorization' => "Bearer #{session[:acc_token]}",
				'Accept' => 'application/json',
				'Content-Type' => 'application/json'
			}
			# @json = JSON.parse(@res)
			render json: @res
		rescue RestClient::ExceptionWithResponse => err
			if err.response.code == 500
				render '/errors/500', layout: 'application_errors'
			else
				render json: err.response
			end
		end
	end

	def self.user_detail(token)
		res = RestClient.get @url + "/user_details", {Authorization: "Bearer #{token}"}
		return res
	end

	def self.profil_progress(token)
		begin
			@res = RestClient.get @url + "/users/progress", {Authorization: "Bearer #{token}"}
			return JSON.parse(@res)
		rescue RestClient::ExceptionWithResponse => err
			puts err.response
		end
	end

	def updateProfilPhoto
		# begin
			# Image Uploader
			
		# 	@res = RestClient.put api_url + "/user_details/#{session[:account_detail][:id]}", {
		# 		'nama_depan' => params[:nama],
		# 		'tempat_lahir' => params[:tempat_lahir],
		# 		'tanggal_lahir' => params[:tgl_lahir].gsub('/', '-'),
		# 		'jk' => params[:jk],
		# 		'telepon_rumah' => params[:telepon_rumah],
		# 		'id_provinsi' => params[:id_provinsi],
		# 		'id_kabkot' => params[:id_kabkot],
		# 		'id_kecamatan' => params[:id_kecamatan],
		# 		'kelurahan' => '',
		# 		'alamat' => params[:alamat],
		# 		'nama_kerabat' => '',
		# 		'alamat_kerabat' => '',
		# 		'telepon_kerabat' => '',
		# 		'foto' => ''
		# 	}
		# rescue RestClient::ExceptionWithResponse => err
		# 	render json: err.response
		# end

	end

	def infoJamaah
		begin
			@res = RestClient.post api_url + "/cari/jamaah",{}, {
				"x-nomor" => params[:nomor]
			}
			render json: JSON.parse(@res)
		rescue RestClient::ExceptionWithResponse => err
			if err.response.code == 500
				render '/errors/500', layout: 'application_errors'
			else
				render json: err.response
			end
		end
	end

	def change_number
		begin
			@res = RestClient.post api_url + 'users/change_number',{},
			{
				'Authorization' => "Bearer #{session[:acc_token]}",
				'x-no-telepon-baru' => params['new_number']
			}
			@data = JSON.parse(@res)
			render json: @data
		rescue RestClient::ExceptionWithResponse => err
			@err = JSON.parse(err.response)
			render json: @err
		end
	end

	def confirm_change_number
		begin
			@res = RestClient.post api_url + 'users/confirm_change_number',{},
			{
				'Authorization' => "Bearer #{session[:acc_token]}",
				'x-no-telepon-baru' => params['new_number'],
				'x-kode-otp' => params['kode_otp']
			}
			@data = JSON.parse(@res)
			render json: @data
		rescue RestClient::ExceptionWithResponse => err
			@err = JSON.parse(err.response)
			render json: @err
		end
	end

	def change_email
		begin
			@res = RestClient.post api_url + "/users/change_email" ,{}, {
					'Authorization' => "Bearer #{session[:acc_token]}",
					'Accept' => 'application/json',
					'x-email-baru' => params[:email],
					'x-password' => params[:password]
			}
			@json = JSON.parse(@res)
			redirect_to '/pengaturan-akun-profile?res=success', :flash => { :message => "Profil berhasil diperbaharui", :status => true}
		rescue RestClient::ExceptionWithResponse => err
			if err.response.code == 500
				render '/errors/500', layout: 'application_errors'
			else
				redirect_to '/pengaturan-akun-profile/akun-email?res=fails', :flash => { :message => JSON.parse(err.response)['message'], :status => true}
			end
		end
	end

	def update_alamat
		begin
			user_detail = JSON.parse(Api::Account::UserProfilController.user_detail(session[:acc_token]))

			@res = RestClient.put api_url + "/user_details/#{session[:account_detail][:id]}" ,{
				'nama_depan' => params[:nama],
				'tempat_lahir' => user_detail['detail']['tempat_lahir'],
				'tanggal_lahir' => user_detail['detail']['tanggal_lahir'],
				'jk' => user_detail['user']['jk'],
				'email' => user_detail['user']['email'],
				'ktp' => user_detail['user']['ktp'],
				'telepon_rumah' => user_detail['detail']['telepon_rumah'],
				'id_provinsi' => params[:id_provinsi],
				'id_kabkot' => params[:id_kabkot],
				'id_kecamatan' => params[:id_kecamatan],
				'kelurahan' => '',
				'alamat' => params[:alamat],
				'nama_kerabat' => '',
				'alamat_kerabat' => '',
				'telepon_kerabat' => ''
			}, {
				'Authorization' => "Bearer #{session[:acc_token]}",
				'Accept' => 'application/json',
				'Content-Type' => 'application/json'
			}
			@json = JSON.parse(@res)
			redirect_to '/pengaturan-akun-profile?res=success', :flash => { :message => "Profil berhasil diperbaharui", :status => true}
		rescue RestClient::ExceptionWithResponse => err
			if err.response.code == 500
				render '/errors/500', layout: 'application_errors'
			else
				redirect_to '/pengaturan-akun-profile?res=fails', :flash => { :message => JSON.parse(err.response)['message'], :status => true}
			end
		end
	end 


end

