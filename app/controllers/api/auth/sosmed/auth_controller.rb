class Api::Auth::Sosmed::AuthController < ApplicationController
  #protect_from_forgery except: [:login, :registers, :email_validation]
  #before_action :check_access_token, :except => [:verify, :login, :destroy, :registers, :email_validation]

  def login
    if request.get?
      if session[:access_token]
        # puts "redirect to root path"
        # if params && params[:ref]
        #   if params[:ref]=='naurah'
        #     redirect_to(paket_tabungan_naurah_path) and return
        #   end
        # end
        # redirect_to(accounts_dashboard_path) and return
      end
      state = rand_string(32)
      session[:state] = state
      @facebook_auth_url = "https://www.facebook.com/v2.6/dialog/oauth?client_id=#{ENV['FACEBOOK_APP_ID']}&redirect_uri=#{ENV['OAUTH_REDIRECT_URI']}&response_type=code&scope=email&state=#{state}"
    end

    if request.post?
      #we accept headerss or parameters
      url = ENV['API_SERVER_URL'] + '/v1/users/login'
      response = HTTParty.post(
          url,
          body: {
                  'username': params[:username],
                  'password':params[:password],
                  'device_id':params[:device_id],
                  'client_id': "1cec286c6a4078358e12f5324c33aaed5486170a950ef893f13b78e096141d6f"
          }.to_json,
          headers: { 'User-Agent' => request.headers['HTTP_USER_AGENT'], 'Content-Type' => 'application/json', 'Accept' => 'application/json' }
      )
      puts "\n------------------------------\n"
      puts response.body, response.code, response.message
      puts "\n------------------------------\n"
      if response.code == 200
        data = response.parsed_response
        set_oauth_info_from data
        redirect_to root_path and return
      elsif response.code == 401
        redirect_to root_path, :flash => { :error => "Email/No Telepon atau Password salah" } and return
      end
    elsif request.get?
      @ref = params[:ref]
      puts @ref
    end
  end

  def registers
    if request.post?
      url = ENV['API_SERVER_URL'] + '/users'
      if params[:email].include? "@"
        @is_phone = false
        email = { 'email' => params[:email]}
      else
        email = { 'handphone' => params[:email]}
        @is_phone = true
      end
      response = HTTParty.post(
          url,
          body: {
              'user': {
                  #'nama': params[:nama],
                  'password':params[:password],
                  'role_id': 4
              }.merge(email)
          }.to_json,
          headers: { 'Content-Type' => 'application/json', 'Accept' => 'application/json' }
      )
      if response.code == 201
        # get_access_token(params[:email], params[:password])
        session[:email] = params[:email]
        #redirect_to auth_verify_path and return
        redirect_to root_path and return
      else
        error = response.parsed_response
        redirect_to root_path
      end
    end
  end

  def destroy
    url = "#{ENV['API_SERVER_URL']}/v1/oauth/revoke"
    HTTParty.post(
        url,
         body: {
             'token': session[:access_token]
        }.to_json,
        headers: {
            'Content-Type' => 'application/json',
            'Accept' => 'application/json'
        }
    )
    session[:access_token] = nil
    session[:refresh_token] = nil
    session[:user_id] = nil
    session[:expired_at] = nil
    session[:email] = nil
    session[:avatar] = nil
    redirect_to root_path
  end

  def email_validation
    url = "#{ENV['API_SERVER_URL']}/api/check_email"
    auth = {:username => ENV['API_AUTH_NAME'], :password => ENV['API_AUTH_PASSWORD']}
    response = HTTParty.post(
        url,
        body: {
            'email': params[:email]
        }.to_json,
        headers: {
            'Content-Type' => 'application/json',
            'Accept' => 'application/json'
        },
        :basic_auth => auth
    )
    data = response.parsed_response
    if response.code == 200
      render json: data
    end
  end

  def verify
    render 'auth/verifikasi'
  end


  private
  def rand_string(len)
    o =  [('a'..'z'),('A'..'Z')].map{|i| i.to_a}.flatten
    string  =  (0..len).map{ o[rand(o.length)]  }.join
    return string
  end
  def auth_params
    params.require(:auth).permit(:username, :password, :client_id)
  end
end
