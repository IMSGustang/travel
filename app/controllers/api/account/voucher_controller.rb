class Api::Account::VoucherController < ApplicationController
	skip_before_action :verify_authenticity_token
	include VariableHelper
	require 'rest-client'
	require 'openssl'
	@api_url = VariableHelper.api_url
	def self.render_voucher(api_url, token, params_page, per_page)
		begin
			@res = RestClient.get api_url + '/voucher', {
				'Authorization' => "Bearer #{token}",
				'x-per-page' => per_page,
				'x-page' => params_page,
			}
			@json = JSON.parse(@res)
			if @json && @json['status'] == 200
				@page_html = Paginator::render(@json)

				page = {
						:link_prev => "<a class='page-link btn btn-success' href='?page=#{@page_html[:link_prev]}'>Prev</a>",
						:link_next => "<a class='page-link btn btn-success' href='?page=#{@page_html[:link_next]}'>Next</a>",
						:html => @page_html[:page]
				}
				return {:data => @json['data'], :page => page}
			end
		rescue RestClient::ExceptionWithResponse => err
			if err.response.code == 500
				render "errors/500", layout: 'application_errors'
			else
				render json: err.response
			end
		end
	end

	def self.checkVoucher(params, session)
		begin
			if !session[:vc].nil?
				voucher_array = session[:vc].split(';')
				voucher = 0
				voucher_array.each do |item|
					@res = RestClient.post @api_url + "/voucher/check",{}, {
						'Authorization' => "Bearer #{session[:acc_token]}",
						'x-kode-produk' => params['p'],
						'x-no-voucher' => item
					}
					json = JSON.parse(@res)
					voucher = voucher + json['data']['nominal']
				end
			end

			return voucher
		rescue RestClient::ExceptionWithResponse => err
			if err.response.code == 500
				render "errors/500", layout: 'application_errors'
			else
				render json: err.response
			end
		end
	end

	def checkVoucher
		begin
			@res = RestClient.post api_url + "/voucher/check",{}, {
				'Authorization' => "Bearer #{session[:acc_token]}",
				'x-kode-produk' => params[:kode_produk],
				'x-no-voucher' => params[:kode_voucher]
			}
			render json: @res
		rescue RestClient::ExceptionWithResponse => err
			if err.response.code == 500
				render "errors/500", layout: 'application_errors'
			else
				render json: err.response
			end
		end
	end

	def checkDoubleVoucher
		begin
			array_voucher = params[:params_array]
			hasil = array_voucher.include?(params[:params_value])

			if hasil == true
				render json: {:response => true, :message => 'Kode voucher sudah digunakan'}
			else
				render json: {:response => false, :message => 'Kode voucher berhasil digunakan'}
			end
		rescue  => err
			if err.response.code == 500
				render "errors/500", layout: 'application_errors'
			else
				render json: err.response
			end
		end
	end

	def voucherSession
		begin
			session[:vc] = params[:vc].gsub! ',', ';'
		rescue RestClient::ExceptionWithResponse => err
			if err.response.code == 500
				render "errors/500", layout: 'application_errors'
			else
				render json: err.response
			end
		end
	end
end
