class Api::Auth::OtpController < ApplicationController
	include VariableHelper
	require 'rest-client'
	require 'json'

	def sendOtpLogin
		begin
			puts session[:otp_login_session]
			if session[:otp_login_session].nil?
				session[:otp_login_session] = 0
			end

			if session[:otp_login_session] < 3
				@res = RestClient.post api_url + '/sessions/resend_otp',{}, {
				'x-handphone' => session[:account_telepon],
				'Accept' => 'application/json',
				'Content-Type' => 'application/json'}
				@json = JSON.parse(@res)
				if @json['success'] == true
					session[:otp_login_session] = session[:otp_login_session]+1
				end
				redirect_to '/app/login-otp?res=success', :flash => { :message => "Kode OTP berhasil dikirim ke nomor Anda.", :status => true}
			else
				redirect_to '/app/login-otp?res=fails', :flash => { :message => "Kode OTP hanya dapat dikirimkan sebanyak 3 kali.", :status => true}
			end
			
		rescue RestClient::ExceptionWithResponse => err
			puts err.response
		end
	end

	def sendOtpRegister
		begin
			puts session[:otp_register_session]
			if session[:otp_register_session].nil?
				session[:otp_register_session] = 0
			end

			if session[:otp_register_session] < 3
				@res = RestClient.post api_url + '/users/resend_otp',{}, {
				'x-handphone' => session[:account_telepon],
				'Accept' => 'application/json', 
				'Content-Type' => 'application/json'}
				@json = JSON.parse(@res)
				if @json['success'] == true
					session[:otp_register_session] = session[:otp_register_session]+1
				end
				redirect_to '/app/register-otp?res=success', :flash => { :message => "Kode OTP berhasil dikirim ke nomor Anda.", :status => true}
			else
				redirect_to '/app/register-otp?res=fails', :flash => { :message => "Kode OTP hanya dapat dikirimkan sebanyak 3 kali.", :status => true}
			end
			
		rescue RestClient::ExceptionWithResponse => err
			render json: err.response
		end
	end

	def send_transfer_seat_otp
		begin
			puts session[:otp_transfer_seat_session]
			if session[:otp_transfer_seat_session].nil?
				session[:otp_transfer_seat_session] = 0
			end

			if session[:otp_transfer_seat_session] < 3
				@res = RestClient.post api_url + '/users/ebooking/resend_otp',{}, {
						'Authorization' => "Bearer #{session[:acc_token]}",
						'Accept' => 'application/json',
						'Content-Type' => 'application/json',
        }
				@json = JSON.parse(@res)
				if @json['success'] == true
					session[:otp_transfer_seat_session] = session[:otp_transfer_seat_session]+1
				end
        render json: { :status => 200, :success => true, :message => 'Kode OTP berhasil dikirim ke nomor Anda.' }
			else
				# redirect_to "transfer-seat/#{params[:kode]}?res=otpfails"
        render json: { :status => 400, :success => false, :message => "Kode OTP hanya dapat dikirimkan sebanyak 3 kali." }
			end

		rescue RestClient::ExceptionWithResponse => err
			puts err.response
		end
	end

	def send_change_number_otp
		begin
			puts session[:otp_change_number_session]
			if session[:otp_change_number_session].nil?
				session[:otp_change_number_session] = 0
			end

			if session[:otp_change_number_session] < 30
				@res = RestClient.post api_url + '/users/resend_otp_change_number',{}, {
						'Authorization' => "Bearer #{session[:acc_token]}",
						'Accept' => 'application/json',
						'Content-Type' => 'application/json',
				}
				@json = JSON.parse(@res)
				if @json['success'] == true
					session[:otp_change_number_session] += 1
				end
				render json: { :status => 200, :success => true, :message => "Kode OTP hanya dapat dikirimkan sebanyak 3 kali." }
			else
				# redirect_to "transfer-seat/#{params[:kode]}?res=otpfails"
				render json: { :status => 400, :success => false, :message => 'Kode OTP hanya dapat dikirimkan sebanyak 3 kali.' }
			end

		rescue RestClient::ExceptionWithResponse => err
			puts err.response
		end
	end

end
