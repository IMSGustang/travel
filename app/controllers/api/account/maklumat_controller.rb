class Api::Account::MaklumatController < ApplicationController
	skip_before_action :verify_authenticity_token
	include VariableHelper
	require 'rest-client'
	require 'helper/bank'
	require 'helper/encryption'

	@api_url = VariableHelper.api_url
	def maklumatPengajuan
		begin
			res = RestClient.post api_url + '/maklumat/pengajuan', {

			}, {
				'Authorization' => "Bearer #{session[:acc_token]}",
				'x-no-transaksi' => params[:no_trans],
				'x-tgl-transaksi' => TimeFormat::indonesiaCustom(params['tgl_trans'], {:format => 'hbt', :operator => '-', :locale => 'en'})
			}
			redirect_to '/pengajuan-penambahan-biaya?res=success', :flash => { :message => JSON.parse(res)['message'], :status => true}
		rescue RestClient::ExceptionWithResponse => e
			if JSON.parse(e.response)['status'] == 404
				redirect_to '/pengajuan-penambahan-biaya?res=fails', :flash => { :message => JSON.parse(e.response)['message'], :status => true}
			else
				if params['debug'] == 'true'
					render json: JSON.pretty_generate(Api::HelperController::Error(e, request.original_url, session));
				else
					render '/errors/500', layout: 'application_errors'
				end
			end
		end
	end

	def self.maklumatDaftarPengajuan(token)
		begin
			res = RestClient.get @api_url + '/maklumat/daftar_pengajuan', {
				'Authorization' => "Bearer #{token}",
				'x-per-page' => '',
				'x-page' => '',
				'x-status' => ''
			}
			return JSON.parse(res)
		rescue RestClient::ExceptionWithResponse => e
			return JSON.parse(e.response)
		end
	end

	def self.maklumatDaftarPengajuanDetail(token, no_request)
		begin
			res = RestClient.get @api_url + '/maklumat/detail_pengajuan/'+no_request, {
				'Authorization' => "Bearer #{token}"
			}
			return JSON.parse(res)
		rescue RestClient::ExceptionWithResponse => e
			return JSON.parse(e.response)
		end
	end

	def self.maklumatCheck(encryption_token)
		begin
			token = Encryption::decode(encryption_token)
			res = RestClient.get @api_url + '/maklumat/check', {
				'x-no-transaksi' => token[0]['no_trans'],
				'x-tgl-transaksi' => token[0]['tgltrans']
			}
			return JSON.parse(res)
		rescue RestClient::ExceptionWithResponse => e
			return JSON.parse(e.response)
		end

	end

	def maklumatTransaksi(api_url, token, encryption_token)
		begin
			data = Encryption::decode(encryption_token)[0]
			res = RestClient.post api_url + '/maklumat/transaksi', {

			}, {
				'Authorization' => "Bearer #{token}",
				'x-no-request' => data['no_request'],
				'x-kode-booking' => data['kode_booking'],
				'x-jamaah-tambahan' => data['jamaah'],
				'x-kode-book-1' => '',
				'x-kode-book-2' => ''
			}
			return JSON.parse(res)
		rescue RestClient::ExceptionWithResponse => e
			return JSON.parse(e.response)
		end
	end

	def self.maklumatTransaksiDetail(token, no_trans)
		begin
			res = RestClient.get @api_url + "/maklumat/detail_transaksi/#{no_trans}", {
				'Authorization' => "Bearer #{token}"
			}
			return JSON.parse(res)
		rescue RestClient::ExceptionWithResponse => e
			return JSON.parse(e.response)
		end
	end

	def self.maklumatRiwayatTransaksi(token, x_per_page = nil, x_page = nil, x_status_bayar = nil)
		begin
			res = RestClient.get @api_url + '/maklumat/daftar_transaksi', {
				'Authorization' => "Bearer #{token}",
				'x-per-page' => x_per_page,
				'x-page' => x_page,
				'x_status_bayar' => x_status_bayar
			}
			return JSON.parse(res)
		rescue RestClient::ExceptionWithResponse => e
			return JSON.parse(e.response)
		end
	end

	def maklumatAddJamaah
		begin
			res = RestClient.post api_url + '/maklumat/tambah_jamaah', {

				}, {
					'Authorization' => "Bearer #{session[:acc_token]}",
					'x-no-transaksi' => params['no_trans'],
					'x-no-transaksi-umrah' => params['no_trans_umrah'],
					'x-kode-book' => params['kode_book']
				}
				render json: JSON.parse(res)
		rescue RestClient::ExceptionWithResponse => e
			render json: JSON.parse(e.response)
		end
	end
end
