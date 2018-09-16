class Api::Account::NotifikasiController < ApplicationController
	skip_before_action :verify_authenticity_token
	include VariableHelper
  require 'helper/paginator'
	require 'rest-client'

  def self.render_notifikasi(api_url, token, params_page, per_page)
    begin
      @res = RestClient.get api_url + '/users/notifikasi', {
          'Authorization' => "Bearer #{token}",
          'Accept' => 'application/json',
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
        return {:data => @json['data'], :notifikasi => @json['notifikasi'], :page => page}
      end
    rescue RestClient::ExceptionWithResponse => err
      return {:data => nil, :page => nil}
    end
  end

  def update_notifikasi
    begin
      token = session[:acc_token]
      puts "ses: #{api_url} #{token}"
      @res = RestClient.put api_url + '/users/notifikasi/' + params[:id], {}, {
          'Authorization' => "Bearer #{token}",
          'Accept' => 'application/json'
      }
      @json = JSON.parse(@res)
      render json: @json
    rescue RestClient::ExceptionWithResponse => err
      render json: { :success => false }
    end
  end

end
