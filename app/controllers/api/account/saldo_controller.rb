class Api::Account::SaldoController < ApplicationController
	@api_url = VariableHelper.api_url
	def self.saldoPriority(api_url, token)
		begin
			@res = RestClient.post api_url + '/user_bank',{}, {'x-per-page' => '5',
				'Authorization' => "Bearer #{token}",
				'x-tahun' => '',
				'x-bulan' => ''
			}
		session[:saldoPriority] = JSON.parse(@res)['data']
		rescue RestClient::ExceptionWithResponse => err
			return err
		end
	end

	def self.mutasiDeposit(token)
		begin
			@res = RestClient.post @api_url + '/mutasi/topup',{}, {
				'Authorization' => "Bearer #{token}"
			}
			return JSON.parse(@res)
		rescue RestClient::ExceptionWithResponse => err
			return err
		end
	end
end
