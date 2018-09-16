class Api::Auth::Sosmed::SessionsController < ApplicationController
  include VariableHelper

  def create
    auth = request.env['omniauth.auth']
    # puts "\n------------------------------\n"
    # puts auth
    # puts "\n------------------------------\n"
    puts request.env['omniauth.params']
    puts params['provider']
    # url = "http://api2.abutours.com/v1/auth/#{params['provider']}/callback"
    url = "#{api_url}/auth/#{params['provider']}/callback"
    puts "API_SERVER_URL: #{url}"
    response = HTTParty.post(
        url,
        body: {
            :client_id => '1cec286c6a4078358e12f5324c33aaed5486170a950ef893f13b78e096141d6f',
            :device_id => request.env['omniauth.params']['fp'],
            :omniauth => auth
        }.to_json,
        headers: { 'User-Agent' => request.headers['HTTP_USER_AGENT'], 'Content-Type' => 'application/json', 'Accept' => 'application/json' }
    )

    puts "\n------------------------------\n"
    puts response.body, response.code, response.message
    puts "\n------------------------------\n"

    if response.code == 200
      data = response.parsed_response
      session[:acc_token] = data['access_token']
      session[:ref_token] = data['refresh_token']
      begin
        res_info = RestClient.get api_url + '/user_details', {Authorization: "Bearer #{session[:acc_token]}"}
        @json_info = JSON.parse(res_info)
        # puts @json_info
        # User
        session[:account_kode_user] = @json_info['user']['kode_user']
        session[:account_email] = @json_info['user']['email']
        session[:account_telepon] = @json_info['user']['telepon']
        session[:account_nama_depan] = @json_info['user']['nama_depan']
        session[:account_jk] = @json_info['user']['jk']
        session[:account_ktp] = @json_info['user']['ktp']
        session[:account_saldo] = @json_info['user']['saldo']
        session[:account_fee] = @json_info['user']['fee']
        session[:account_poin] = @json_info['user']['poin']
        session[:account_seat] = @json_info['user']['seat']
        session[:account_kode_referral] = @json_info['user']['kode_referral']

        # Detail
        session[:account_detail] = {
        :id => @json_info['detail']['id'], 
        :kode_kantor => @json_info['detail']['kode_kantor'],
        :tempat_lahir => @json_info['detail']['tempat_lahir'],
        :tanggal_lahir => @json_info['detail']['tanggal_lahir'],
        :foto => @json_info['detail']['foto']
      }
      rescue RestClient::ExceptionWithResponse => err
        err.response
      end
    elsif response.code == 401
      flash[:error] =  data['mesage']
    end
    redirect_to "/"

  end

  # def google
  #   #puts "----------------- #{params}"
  #   #puts "******* #{request.env['omniauth.auth'].to_yaml}"
  #   url = ENV['API_SERVER_URL'] + '/auth/google'
  #   response = HTTParty.post(
  #       url,
  #       body: {
  #           'redirect_url': ENV['OAUTH_REDIRECT_URI'],
  #           'omniauth': request.env['omniauth.auth']
  #       }.to_json,
  #       headers: { 'Content-Type' => 'application/json', 'Accept' => 'application/json' }
  #   )
  #
  #   puts "\n------------------------------\n"
  #   puts response.body, response.code, response.message, response.headers.inspect
  #   puts "\n------------------------------\n"
  #
  #   if response.code == 200
  #     data = response.parsed_response
  #     set_oauth_info_from data
  #     redirect_to root_path and return
  #   elsif response.code == 401
  #     data = response.parsed_response
  #     redirect_to auth_registers_path, :flash => { :error => data['message'] } and return
  #   end
  #
  # end
  def failure
    redirect_to root_url, alert: "Authentication failed, please try again."
  end
end