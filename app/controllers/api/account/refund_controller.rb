class Api::Account::RefundController < ApplicationController
	skip_before_action :verify_authenticity_token
	include VariableHelper
	require 'rest-client'
	require 'json'

	# Fungsi menjalankan pengajuan refund
	def refundAction()
		begin
			res = RestClient.post api_url + '/refund',{
			}, {'x-per-page' => '5',
				'Authorization' => "Bearer #{session[:acc_token]}",
				'x-no-transaksi' => params['no_trans'],
				'x-alasan' => params['alasan']+" : "+params['keterangan_alasan'],
				'x-kode-bank' => params['bank'],
				'x-otp-via' => 'json'
			}
			response = JSON.parse(res)
			if !response['data'].nil?
				redirect_to '/verifikasi-otp-refund'
			end
		rescue RestClient::ExceptionWithResponse => e
			response = JSON.parse(e.response)
			no_cookies_refund = !cookies[:XCOR].nil? ? cookies[:XCOR] : 0
			cookies_refund = cookies[:XCOR] = cookies[:XCOR].to_i + 1
			resend_otp = self.resendOTPCodeRefund(response['data']['notrans_refund'])
			if !response['data'].nil?
				redirect_to "/verifikasi-otp-refund/#{response['data']['notrans_refund']}"
			end
		end
	end

	def OtpRefundConfirmation
		begin
			res = RestClient.post api_url + '/refund/konfirmasi_otp', {

				}, {
					'Authorization' => "Bearer #{session[:acc_token]}",
					'x-no-trans-refund' => params[:no_trans],
					'x-kode-otp' => params['otp1']+params['otp2']+params['otp3']+params['otp4']+params['otp5']+params['otp6']
				}
			json = JSON.parse(res)
			redirect_to "/invoice-refund/#{json['data']['notrans_refund']}"
		rescue RestClient::ExceptionWithResponse => e
			redirect_to "/verifikasi-otp-refund/#{params[:no_trans]}?res=fails", :flash => { :message => JSON.parse(e.response)['message'], :status => true}
		end
	end

	def resendOTPCodeRefund(no_trans = params['no_trans'])
		begin
			no_cookies_refund = !cookies[:XCROR].nil? ? cookies[:XCROR] : 0
			cookies_refund = cookies[:XCROR] = cookies[:XCROR].to_i + 1

			res = RestClient.post api_url + '/refund/resend_otp', {

				}, {
					'Authorization' => "Bearer #{session[:acc_token]}",
					'x-no-trans-refund' => no_trans,
					'x-otp-via' => 'sms'
				}
		rescue RestClient::ExceptionWithResponse => e
			return e.response
		end
	end

	def self.detailRefund(api_url, params, token)
		begin
			res = RestClient.get api_url + "/refund/#{params['no_trans_refund']}", {
				'Authorization' => "Bearer #{token}"
			}
			return JSON.parse(res)
		rescue RestClient::ExceptionWithResponse => e
			return JSON.parse(e.response)
		end
	end
end
