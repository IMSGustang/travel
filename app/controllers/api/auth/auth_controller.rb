 	class Api::Auth::AuthController < ApplicationController
	skip_before_action :verify_authenticity_token
	include ApplicationHelper
	include VariableHelper
	require 'rest-client'
	require 'json'
	require 'helper/error'

	def login
		if params['no_telepon'] == nil && params['password'] == nil
			redirect_to '/abutours-login?res=fails', :flash => {:status => true}
		else
			begin
			@res = RestClient.post api_url + '/users/login',{}, {
				'x-username' => params['no_telepon'], 
				'x-password' => params['password'], 
				'x-client-id' => clientId,
				'x-device-model' => '',
				'x-app-version' => 'v.1.0', 
				'x-device-id' => params['afb'],
				'x-otp-via' => '',
				'Accept' => 'application/json', 
				'Content-Type' => 'application/json'}
			@json = JSON.parse(@res)
			session[:acc_token] = @json['access_token']
			session[:ref_token] = @json['refresh_token']

			# Get user details and get all information
			res_info = RestClient.get api_url + '/user_details', {Authorization: "Bearer #{session[:acc_token]}"}
			@json_info = JSON.parse(res_info)
			# User
			session[:account_kode_user] = @json_info['user']['kode_user']
			session[:account_email] = @json_info['user']['email']
			session[:account_telepon] = @json_info['user']['telepon']
			session[:account_nama_depan] = @json_info['user']['nama_depan']
			session[:account_jk] = @json_info['user']['jk']
			session[:account_ktp] = @json_info['user']['ktp']
			session[:account_saldo] = @json_info['user']['saldo']
			session[:account_fee] = @json_info['user']['fee']
			session[:account_poin] = @json_info['user']['poin']
			session[:account_seat] = @json_info['user']['seat']
			session[:account_kode_referral] = @json_info['user']['kode_referral']

			# Detail
			session[:account_detail] = {
				:id => @json_info['detail']['id'], 
				:kode_kantor => @json_info['detail']['kode_kantor'],
				:tempat_lahir => @json_info['detail']['tempat_lahir'],
				:tanggal_lahir => @json_info['detail']['tanggal_lahir'],
				:telepon_rumah => @json_info['detail']['telepon_rumah'],
				:foto => @json_info['detail']['foto']
			}

			
			# 
			redirect_to '/accounts/dashboard'
			
			rescue RestClient::ExceptionWithResponse => err
				code = err.response.code
				if code == 500 or code == 502
					if params['debug'] == 'true'
						render json: JSON.pretty_generate(Api::HelperController::Error(e, request.original_url, session));
					else
						render '/errors/500', layout: 'application_errors'
					end
				else
				  	@data = 'fails'
					json = JSON.parse(err.response)
					session[:account_telepon] = params['no_telepon']
					session[:otp_code] = json['otp_code']
					if json['otp'] == true
						session[:otplog] = true
						redirect_to '/app/login-otp'
					else
						redirect_to '/abutours-login?res=fails', :flash => { :message => "Username atau password salah", :status => true}
					end
				end
			end
		end
		
	end

	def loginOtp
		@res = params['res']
		render "auth/loginotp", layout: 'application_logister'
	end

	def loginVerifikasi
		begin
		@res = RestClient.post api_url + '/users/confirm_new_device',{}, {
			'x-username' => session[:account_telepon],
			'x-kode-otp' => params['otp'],
			'x-client-id' => clientId,
			'x-app-version' => 'v.1.0', 
			'x-device-id' => params['afb'], 
			'x-device-model' => 'Web', 
			'Accept' => 'application/json'}
			@json = JSON.parse(@res)
			session[:acc_token] = @json['access_token']
			session[:ref_token] = @json['refresh_token']
			
			# Get user details and get all information
			res_info = RestClient.get api_url + '/user_details', {Authorization: "Bearer #{session[:acc_token]}"}
			@json_info = JSON.parse(res_info)
			# User
			session[:account_kode_user] = @json_info['user']['kode_user']
			session[:account_email] = @json_info['user']['email']
			session[:account_telepon] = @json_info['user']['telepon']
			session[:account_nama_depan] = @json_info['user']['nama_depan']
			session[:account_jk] = @json_info['user']['jk']
			session[:account_ktp] = @json_info['user']['ktp']
			session[:account_saldo] = @json_info['user']['saldo']
			session[:account_fee] = @json_info['user']['fee']
			session[:account_poin] = @json_info['user']['poin']
			session[:account_seat] = @json_info['user']['seat']
			session[:account_kode_referral] = @json_info['user']['kode_referral']

			# Detail
			session[:account_detail] = {
				:id => @json_info['detail']['id'], 
				:kode_kantor => @json_info['detail']['kode_kantor'],
				:tempat_lahir => @json_info['detail']['tempat_lahir'],
				:tanggal_lahir => @json_info['detail']['tanggal_lahir'],
				:foto => @json_info['detail']['foto']
			}

			# puts @res
		if mobile_device?
			redirect_to '/accounts/dashboard'
		else
			redirect_to '/daftar-paket-b2c'
		end
		rescue RestClient::ExceptionWithResponse => err
			code = err.response.code
			if code == 500 or code == 502
				Error.log(err, request.original_url)
				render '/errors/500', layout: 'application_errors'
			else
				if session[:account_telepon] != ""
					str = session[:account_telepon]
					@data = "XXXXXXXXX"+str[-3, 3]
					@res = 'fails'
					redirect_to "/app/login-otp?res=fails", :flash => { :message => "Kode OTP yang Anda masukan salah", :status => true}
				else
					reset_session
					redirect_to "/app/login-otp?res=fails", :flash => { :message => "Kode OTP yang Anda masukan salah", :status => true}
				end
			end
		end
	end

	# |--------------------------------------------------------------------------------------------|
	# |  										REGISTER 										   |
	# |--------------------------------------------------------------------------------------------|

	def register
		begin
		res = RestClient.post api_url + '/users', {'x' => 1}.to_json, {
			content_type: :json, 
			accept: :json, 
			'x-handphone' => params['telepon'],
			'x-email' => '',
			'x-nama' => params['nama'],
			'x-password' => params['password'], 
			'x-referral' => params['referral'], 
			'x-tipe-user' => 'CMS', 
			'x-client-id' => clientId,
			'x-app-version' => 'v.1.0', 
			'x-device-id' => params['afb'],
			# 'x-otp-via' => 'json'
		}
		@json = JSON.parse(res)
		session[:account_telepon] = @json['data']['telepon']
		session[:account_kode_user] = @json['data']['kode_user']
		session[:otpreg] = true
		session[:otp_code] = @json['otp_code']
		redirect_to '/app/register-otp'
		rescue RestClient::ExceptionWithResponse => err
			code = err.response.code
			if code == 500 or code == 502
				Error.log(err, request.original_url)
				render '/errors/500', layout: 'application_errors'
			else
				@res = err.response
				@json = JSON.parse(@res)
				puts @json
				redirect_to '/abutours-registers?res=fails', :flash => { :message => @json['message'], :status => true}
			end
		end
			
	end

	def registerOtp
		if session[:account_telepon] != ""
			str = session[:account_telepon]
			@data = "XXXXXXXXX"+str[-3, 3]
			@res = params['res']
			render "auth/registersotp", layout: 'application_logister'
		else
			reset_session
		end
		
	end

	def registerVerifikasi
		begin
		@res = RestClient.post api_url + '/users/confirm_and_login',{}, {
			'x-kode-user' => session[:account_kode_user],
			'x-kode-otp' => params['otp'],
			'x-client-id' => clientId,
			'x-app-version' => 'v.1.0', 
			'x-device-id' => params['afb'], 
			'x-device-model' => 'Web', 
			'Accept' => 'application/json'}
			@json = JSON.parse(@res)
			session[:acc_token] = @json['access_token']
			session[:ref_token] = @json['refresh_token']
			

			# Get user details and get all information
			res_info = RestClient.get api_url + '/user_details', {Authorization: "Bearer #{session[:acc_token]}"}
			@json_info = JSON.parse(res_info)
			# User
			session[:account_kode_user] = @json_info['user']['kode_user']
			session[:account_email] = @json_info['user']['email']
			session[:account_telepon] = @json_info['user']['telepon']
			session[:account_nama_depan] = @json_info['user']['nama_depan']
			session[:account_jk] = @json_info['user']['jk']
			session[:account_ktp] = @json_info['user']['ktp']
			session[:account_saldo] = @json_info['user']['saldo']
			session[:account_fee] = @json_info['user']['fee']
			session[:account_poin] = @json_info['user']['poin']
			session[:account_seat] = @json_info['user']['seat']
			session[:account_kode_referral] = @json_info['user']['kode_referral']

			# Detail
			session[:account_detail] = {
				:id => @json_info['detail']['id'], 
				:kode_kantor => @json_info['detail']['kode_kantor'],
				:tempat_lahir => @json_info['detail']['tempat_lahir'],
				:tanggal_lahir => @json_info['detail']['tanggal_lahir'],
				:foto => @json_info['detail']['foto']
			}
			# @data = 'success'
		if mobile_device?
			redirect_to '/accounts/dashboard'
		else
			redirect_to '/daftar-paket-b2c'
		end
		rescue RestClient::ExceptionWithResponse => err
			code = err.response.code
			if code == 500 or code == 502
				Error.log(err, request.original_url)
				render '/errors/500', layout: 'application_errors'
			else
				@res = err.response
				if session[:account_telepon] != ""
					str = session[:account_telepon]
					@data = "XXXXXXXXX"+str[-3, 3]
					@json = JSON.parse(@res)
					redirect_to '/app/register-otp?res=fails', :flash => { :message => "Kode OTP yang Anda masukan salah", :status => true}
				else
					reset_session
					redirect_to '/app/register-otp?res=fails', :flash => { :message => "Kode OTP yang Anda masukan salah", :status => true}
				end
			end
			
		end
	end

	# |--------------------------------------------------------------------------------------------|
	# |  										LOGOUT  										   |
	# |--------------------------------------------------------------------------------------------|

	def removeAndRevoke
		reset_session
		redirect_to '/'
	end
end
