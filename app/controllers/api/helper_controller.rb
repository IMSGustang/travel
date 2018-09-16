class Api::HelperController < ApplicationController
	require 'securerandom'
	def self.Error(request, error_url, session)
		@var_error = []
		@var_error << {
			'kode_kesalahan' => '400',
			'pesan_kesalahan' => request,
			'error_url' => error_url,
			'backtrace' => request.backtrace,
			'user_information' => {
				'nama' => "#{session[:account_nama_depan]} #{session[:account_nama_belakang]}",
				'user_id' => session[:account_kode_user],
				'email' => session[:account_email],
				'telp' => session[:account_telepon],
				'x-code' => "#{SecureRandom.hex}X#{session[:account_ktp]}X#{SecureRandom.hex}"
			}
		}
		return @var_error
	end
end
