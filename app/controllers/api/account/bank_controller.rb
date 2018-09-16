class Api::Account::BankController < ApplicationController
	skip_before_action :verify_authenticity_token
	include VariableHelper
	require 'rest-client'
	require 'helper/bank'

	def detail
		data_bank = Api::Account::BankController.editBank(api_url, session[:acc_token], params[:id])
		data = JSON.parse(data_bank)['detail'][0]
		render json: data
	end

	def addBank
		@res = RestClient.post api_url + '/user_bank',{
			user_bank: {
				kode_bank: params[:nama_bank],
				nama_bank: Bank::kode(params[:nama_bank]),
				no_rekening: params[:no_rekening],
				atas_nama: params[:atas_nama],
				cabang: params[:cabang]
				}
			}, {'x-per-page' => '5',
				'Authorization' => "Bearer #{session[:acc_token]}"
			}
		redirect_to '/data-bank?res=success', :flash => { :message => 'Data Bank berhasil ditambahkan', :status => true}
	end

	def self.rendering(api_url, token, per_page = '10')
		begin
		@res = RestClient.get api_url + '/user_bank', {
			'x-per-page' => per_page,
			'Authorization' => "Bearer #{token}"
			}
		return JSON.parse(@res)
		rescue RestClient::ExceptionWithResponse => err
			@data = JSON.parse(err.response)
			return JSON.parse('{"json" : {"data" : null}}')
		end
	end

	def self.editBank(api_url, token, id)
		@res = RestClient.get api_url + '/user_bank/' + id, {
			'x-per-page' => '5',
			'Authorization' => "Bearer #{token}"
		}
		return @res
	end

	def updateBank
		@res = RestClient.put api_url + '/user_bank/' + params[:id], {
			user_bank: {
				nama_bank: params[:nama_bank],
				no_rekening: params[:no_rekening],
				atas_nama: params[:atas_nama],
				cabang: params[:cabang]
			}
		}, {
			'x-per-page' => '5',
			'Authorization' => "Bearer #{session[:acc_token]}"
		}

		redirect_to '/data-bank?res=success', :flash => { :message => 'Data Bank berhasil dirubah', :status => true}
	end

	def removeBank
		@res = RestClient.delete api_url + '/user_bank/' + params[:id], {
			'Authorization' => "Bearer #{session[:acc_token]}"
		}
		render json: @res
	end

	def self.listBank(api_url, tipe = 'IDR')
		begin
			@res = RestClient.get api_url + '/bank', {
				'x-tipe-curr' => tipe
			}
			return JSON.parse(@res)
		rescue RestClient::ExceptionWithResponse => err
			puts err.response
		end
	end

	def self.detailBank(api_url, kodeBank)
		begin
			@res = RestClient.get api_url + "/bank/" + kodeBank
			return JSON.parse(@res)
		rescue RestClient::ExceptionWithResponse => err
			puts err.response
		end
	end
end
