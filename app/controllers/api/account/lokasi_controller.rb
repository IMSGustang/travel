class Api::Account::LokasiController < ApplicationController
	skip_before_action :verify_authenticity_token
	include VariableHelper
	require 'rest-client'
	# require 'json'
	# $url = api_url
	@url = VariableHelper.api_url
	class <<self
		def renderProvinsi(api_url, token)
			res = RestClient.get @url + "/provinsi",{Authorization: "Bearer #{token}"}
			return JSON.parse(res)
		end

		def renderProvinsiSl(token)
			rs = Api::Account::UserProfilController.user_detail(token)
			res = RestClient.get @url + "/provinsi/#{JSON.parse(rs)['detail']['id_provinsi']}",{Authorization: "Bearer #{token}"}

			unless JSON.parse(rs)['detail']['id_provinsi'].nil? || JSON.parse(rs)['detail']['id_provinsi'] == 0
				return JSON.parse(res)
			else
				return {:province_id => '0', :province => 'Pilih Provinsi'}
			end
			# render json: "/provinsi/#{rs[:detail]}"
		end

		# |-----------------------------------|
		# |				 KABKOT 			  |
		# |-----------------------------------|

		def renderKabKot(token)
			res = RestClient.get @url + "/kabkot",{Authorization: "Bearer #{token}"}
			return JSON.parse(res)
		end

		def renderKabKotSl(token)
			rs = Api::Account::UserProfilController.user_detail(token)
			res = RestClient.get @url + "/kabkot/#{JSON.parse(rs)['detail']['id_kabkot']}",{Authorization: "Bearer #{token}"}
			unless JSON.parse(rs)['detail']['id_kabkot'].nil? || JSON.parse(rs)['detail']['id_kabkot'] == 0
				return JSON.parse(res)
			else
				render json: {:province_id => '0', :province => 'Pilih Provinsi'}
			end
		end


		# |-----------------------------------|
		# |			   KECAMATAN 			  |
		# |-----------------------------------|

		def renderKecSl(token)
			rs = Api::Account::UserProfilController.user_detail(token)
			res = RestClient.get @url + "/kecamatan/#{JSON.parse(rs)['detail']['id_kecamatan']}",{Authorization: "Bearer #{token}"}
			unless JSON.parse(rs)['detail']['id_kecamatan'].nil? || JSON.parse(rs)['detail']['id_kecamatan'] == 0
				return JSON.parse(res)
			else
				render json: {:province_id => '0', :province => 'Pilih Provinsi'}
			end
		end
	end

	def renderKabKotByProvinsi
		rs = Api::Account::UserProfilController.user_detail(session['acc_token'])
		res = RestClient.get api_url + "/kabkot/provinsi/#{params[:id]}",{Authorization: "Bearer #{session['acc_token']}"}
		render json: res
	end

	def renderKecByKabkot
		rs = Api::Account::UserProfilController.user_detail(session['acc_token'])
		res = RestClient.get api_url + "/kecamatan/kabkot/#{params[:id]}",{Authorization: "Bearer #{session['acc_token']}"}
		render json: res
	end

	def render_lokasi_by_id(token, id_kecamatan)
		if id_kecamatan.present?
			res = RestClient.get @url + "/kecamatan/#{id_kecamatan}",{Authorization: "Bearer #{token}"}
			JSON.parse(res)
		end
	end

	def self.CabangKotaAbutours(zona = nil, per_page = nil, page = nil)
		begin
			res = RestClient.get @url + "kantor",{
				"x-zona" => zona,
				"x-per-page" => per_page,
				"x-page" => page
			}
			return JSON.parse(res)
		rescue RestClient::ExceptionWithResponse => err
			return {:status => false}
		end
	end
	
end
