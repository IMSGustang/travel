class Api::Auth::ResetPasswordController < ApplicationController
	skip_before_action :verify_authenticity_token
	layout 'application_logister'
	include VariableHelper
	require 'rest-client'
	require 'json'

	def renderNumberPhone
		@res = params['res']
		

		if Rails.env.development?
	        if mobile_device?
	          render '/mobile/accounts/users/_resetpass/mobileForgotPass', layout: 'application_mobile'
	        else
	          render 'auth/reset_password_nomor'
	        end
	     else
	        render 'auth/reset_password_nomor'
      	end
	end

	def getNumberPhone
		begin
			@res = RestClient.post api_url + '/passwords/resend_otp',{}, {
				'x-handphone' => params[:nomor_telepon],
				'x-client-id' => clientId,
				'x-otp-via' => 'json',
				'Accept' => 'application/json',
				'Content-Type' => 'application/json'}
			@json = JSON.parse(@res)
			puts @json
			if @json['otp'] == true
				session[:account_telepon] = params[:nomor_telepon]
				session[:otp_code] = @json['otp_code']
				redirect_to '/app/reset-password-otp?res=success', :flash => { :message => @json['message'], :status => true}
			else
				render json: @json
			end
		rescue RestClient::ExceptionWithResponse => err
			@json = JSON.parse(err.response)
			redirect_to '/app/reset-password-number?res=fails', :flash => { :message => @json['message'], :status => true}
		end
	end

	def resendOtp
		begin
			@res = RestClient.post api_url + '/passwords/resend_otp',{}, {
				'x-handphone' => session[:account_telepon],
				'x-client-id' => clientId,
				# 'x-otp-via' => 'json',
				'Accept' => 'application/json',
				'Content-Type' => 'application/json'}
			@json = JSON.parse(@res)
			# puts @json
			session[:otp_code] = @json['otp_code']
			if @json['otp'] == true
				redirect_to '/app/reset-password-otp?res=success', :flash => { :message => "Kode OTP berhasil dikirim", :status => true}
			else
				render json: @json
			end
		rescue RestClient::ExceptionWithResponse => err
			render json: err.response
		end
	end

	def renderOtp
		@res = params['res']
		
		if Rails.env.development?
	        if mobile_device?
	          render '/mobile/accounts/users/_resetpass/mobileOtpPass', layout: 'application_mobile'
	        else
	          render 'auth/reset_password_otp'
	        end
	     else
	        render 'auth/reset_password_otp'
      	end
	end

	def confirmOtp
		if params['number'].kind_of?(Array)
			params[:otp] = params['number'].join.gsub(' ', '')
		end
		begin
			@res = RestClient.post api_url + '/passwords/confirm_otp',{}, {
				'x-username' => session[:account_telepon],
				'x-kode-otp' => params[:otp],
				'x-client-id' => clientId,
				'Accept' => 'application/json',
				'Content-Type' => 'application/json'}
			@json = JSON.parse(@res)
			puts @json
			if @json['success'] == true
				session[:reset_token] = @json['reset_token']
				
				if Rails.env.development?
			        if mobile_device?
			          render '/mobile/accounts/users/_resetpass/mobileResetPass', layout: 'application_mobile'
			        else
			          render 'auth/reset_password'
			        end
			    else
			        render 'auth/reset_password'
		      	end
			end
		rescue RestClient::ExceptionWithResponse => err
			redirect_to '/app/reset-password-otp?res=fails', :flash => { :message => "Kode OTP tidak cocok", :status => true}
		end
	end

	def renderReset
		render 'auth/reset_password'
	end

	def reset
		begin
		@res = RestClient.post api_url + '/passwords/reset',{}, {
			'x-reset-token' => session[:reset_token],
			'x-password' => params[:password],
			'x-password-confirmation' => params[:password_confirm],
			'x-client-id' => clientId,
			'Accept' => 'application/json',
			'Content-Type' => 'application/json'}
		@json = JSON.parse(@res)
		# render json: @json
		if @json['success'] == true
			session[:reset_token] = @json['reset_token']
			redirect_to '/abutours-login?res=success', :flash => { :message => 'Password berhasil dirubah', :status => true}
			# render json: @json
		end
		rescue RestClient::ExceptionWithResponse => err
			redirect_to '/abutours-login?res=success', :flash => { :message => 'Gagal melakukan perubahan', :status => true}
		end
	end

	# UBAH PASSWORD

	def ubahPassword
		begin
		@res = RestClient.post api_url + '/passwords/change',{}, {
			'Authorization' => "Bearer #{session[:acc_token]}",
			'x-password-confirmation' => params[:conf_new_password],
			'x-password' => params[:new_password],
			'x-old-password' => params[:old_password]
		}
		@json = JSON.parse(@res)
		redirect_to '/pengaturan-password?res=success', :flash => { :message => 'Password Anda berhasih dirubah', :status => true}
		rescue RestClient::ExceptionWithResponse => err
			redirect_to '/pengaturan-password?res=fails', :flash => { :message => JSON.parse(err.response)['message'], :status => true}
			# render json: err.response
		end
	end

end
