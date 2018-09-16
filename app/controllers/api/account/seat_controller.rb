class Api::Account::SeatController < ApplicationController
	skip_before_action :verify_authenticity_token
	include VariableHelper
	require 'rest-client'

	def transfer
		begin
			@res = RestClient.post api_url + 'users/ebooking/transfer_seat',
          {},
          {
              'Authorization' => "Bearer #{session[:acc_token]}",
              'x-no-transaksi' => params['no_transaksi'],
              'x-kode-booking' => params['kode_booking'],
              'x-kode-user' => params['nomor_partnerships']
          }
      @data = JSON.parse(@res)
			render json: @data
		rescue RestClient::ExceptionWithResponse => err
      @err = JSON.parse(err.response)
      render json: @err
		end
  end

  def confirm_transfer_seat
    begin
      @res = RestClient.post api_url + 'users/ebooking/confirm_transfer_seat',
       {},
       {
           'Authorization' => "Bearer #{session[:acc_token]}",
           'x-no-transaksi' => params['no_transaksi'],
           'x-kode-booking' => params['kode_booking'],
           'x-kode-otp' => params['kode_otp']
       }
      @data = JSON.parse(@res)
      render json: @data
    rescue RestClient::ExceptionWithResponse => err
      @err = JSON.parse(err.response)
      render json: @err
    end
  end

  def self.render_riwayat_transfer(api_url, token, params_page, per_page)
    begin
      @res = RestClient.get api_url + '/users/ebooking/transfer_seat_history', {
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
      return {:data => nil, :page => nil}
    end
  end

end
