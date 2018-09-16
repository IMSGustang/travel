class Api::Account::FeeController < ApplicationController
	skip_before_action :verify_authenticity_token
  	before_action :Authentication
	include ApplicationHelper
	require 'helper/error'
	def otp
	    begin
			res = RestClient.post api_url + "fee/cair/otp", {

			},{
			  'Authorization' => "Bearer #{session[:acc_token]}",
			  'x-otp-via' => ''
			}
			render json: res
	    rescue RestClient::ExceptionWithResponse => e
			Error.log(e, request.original_url)
			render "errors/500", layout: 'application_errors'
	    end
	end

	def konfirmasi_otp
		begin
			res = RestClient.post api_url + "fee/cair", {

				}, {
					'Authorization' => "Bearer #{session[:acc_token]}",
					'x-metode' => params[:metode],
					'x-kode-bank' => params[:bank],
					'x-kode-otp' => params[:otp].join('')
				}
				redirect_to '/fee/pencairan?res=success', :flash => { :message => 'Berhasil melakukan pencairan fee', :status => true}
		rescue RestClient::ExceptionWithResponse => e
			redirect_to '/fee/pencairan?res=fails', :flash => { :message => JSON.parse(e.response)['message'], :status => true}
		end
	end
end
