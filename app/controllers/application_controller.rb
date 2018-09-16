class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :ReNewToken
  include VariableHelper
  require 'rest-client'
  require 'json'
  require 'helper/error'
  require 'helper/bank'

  rescue_from ActionController::InvalidAuthenticityToken, with: :rescue_422

  def handle_unverified_request
    raise(ActionController::InvalidAuthenticityToken)
  end

  def rescue_422
    redirect_to '/500'
  end

  def current_controller?(names)
    names.include?(params[:controller]) unless params[:controller].blank? || false
  end

  helper_method :current_controller?

  def respond_modal_with(*args, &blk)
    options = args.extract_options!
    options[:responder] = ModalResponder
    respond_with *args, options, &blk
  end

  # def tiketToken
  #   begin
  #     # if session[:acc_token]
  #       @res = RestClient.get api_url + "/ppob/pesawat/get-token", {
  #         'Authorization' => "Bearer #{session[:acc_token]}"
  #       }
  #       json = JSON.parse(@res)
  #       session[:tiket] = json['token']
  #     # end
  #   rescue RestClient::ExceptionWithResponse => err
  #     Error.log(err, request.original_url)
  #     render "errors/500", layout: 'application_errors'
  #   end
  # end

  def ReNewToken
    Rails.logger.info("RenewToken '#{session[:acc_token]}'")
    # Memperbaharui OTP Otomatis
    begin
      uri = Rails.env.production? ? URI('http://api2.abutours.com') : URI('http://apiv3.abutours.com')
      response = Net::HTTP.get_response(uri)
      if session[:acc_token]
        begin
          # Cek OTP
          @res = RestClient.get api_url + "/oauth/token/info", {
              'Authorization' => "Bearer #{session[:acc_token]}"
          }
        rescue RestClient::ExceptionWithResponse => err
          Rails.logger.info "Error GET /oauth/token/info: #{err}"
          if session[:ref_token]
            begin
              @res = RestClient.post api_url + "/oauth/token" ,{
                  'grant_type' => 'refresh_token',
                  'refresh_token' => session[:ref_token]
              }, {'Content-Type' => 'application/x-www-form-urlencoded'}
              @json = JSON.parse(@res)
              session[:acc_token] = @json['access_token']
              session[:ref_token] = @json['refresh_token']
            rescue RestClient::ExceptionWithResponse => err
              Rails.logger.info "Error GET /oauth/token: #{err}"
              if !session[:acc_token].nil?
                reset_session
              end
            end
          end
        end
      end

      # Register Session Terbaru

      begin
        if session[:acc_token]
          res_info = RestClient.get api_url + '/user_details', {Authorization: "Bearer #{session[:acc_token]}"}
          @json_info = JSON.parse(res_info)

          # Saldo
          saldo = RestClient.get api_url + '/users/saldo_priority', {Authorization: "Bearer #{session[:acc_token]}", 'x-tahun' => '', 'x-bulan' => ''}
          @saldo =JSON.parse(saldo)
          # User
          session[:account_kode_user] = @json_info['user']['kode_user']
          session[:account_email] = @json_info['user']['email']
          session[:account_nama_depan] = @json_info['user']['nama_depan']
          session[:account_nama_belakang] = @json_info['user']['nama_belakang']
          session[:account_jk] = @json_info['user']['jk']
          session[:account_ktp] = @json_info['user']['ktp']
          session[:account_saldo] = @json_info['user']['saldo']
          session[:account_fee] = @json_info['user']['fee']
          session[:account_poin] = @json_info['user']['poin']
          session[:account_seat] = @json_info['user']['seat']
          session[:account_kode_referral] = @json_info['user']['kode_referal']
          session[:saldoPriority] = @saldo['data'] != nil ? @saldo['data']['total_saldo'] : 0
          session[:limitSaldoPriority] = @saldo['data'] != nil ? @saldo['data']['total_limit'] : 0
          session[:role] = @json_info['user']['role']
          session[:nama_role] = @json_info['user']['nama_role']
          session[:is_ownership] = @json_info['user']['is_ownership']
          session[:is_kcp] = @json_info['user']['is_kcp']
          session[:tiket] = "Content has been removed"

          # Detail
          session[:account_detail] = {
            :id => @json_info['detail']['id'],
            :kode_kantor => @json_info['detail']['kode_kantor'],
            :tempat_lahir => @json_info['detail']['tempat_lahir'],
            :tanggal_lahir => @json_info['detail']['tanggal_lahir'],
            :foto => @json_info['detail']['foto'],
            :account_telepon => @json_info['detail']['telepon_rumah'],
            :kode_role => @json_info['user']['kode_role'],
            :nama_role => @json_info['user']['nama_role'],
            :is_ownership => @json_info['user']['is_ownership'],
            :is_kcp => @json_info['user']['is_kcp']
          }
        end
      rescue RestClient::ExceptionWithResponse => err
        puts "ERROR Acc Token: #{err}"
      end
    rescue StandardError => e
      logger.info 'Server API down'
      logger.error e.message
      logger.error e.backtrace.join("\n")
      render 'errors/500', layout: 'application_errors'
    end
    
  end

  def Authentication
    Rails.logger.info("Authentication > #{session[:acc_token]}")
    if session[:acc_token].nil?
      # flash[:warning] = 'Akun anda telah login dari tempat lain. Jika bukan anda, harap melakukan pengamanan terhadap akun anda.'
      redirect_to "/"
    else
      data = Api::Account::NotifikasiController.render_notifikasi(api_url, session[:acc_token], params[:page], 10)
      @informasi = data[:data]
      @notifikasi = data[:notifikasi]
      pembelian = RestClient.get api_url + '/users/jumlah_pembelian', {
            'Authorization' => "Bearer #{session[:acc_token]}",
            'Accept' => 'application/json',
      }
      @badge_pembelian = JSON.parse(pembelian)
    end
  end

  def redirect_user
    redirect_to '/404'
  end

  def test
    # render json: VariableHelper::timess('2017-10-15T07:35:40.000Z')
    # saldo = RestClient.get api_url + '/users/saldo_priority', {Authorization: "Bearer #{session[:acc_token]}", 'x-tahun' => '', 'x-bulan' => ''}
    # @saldo =JSON.parse(saldo)
    # render json: @saldo
    render json: Bank::abutours('MANDIRI-ABUTOURS-COM')
  end

  def mobile_device?
    if session[:mobile_param]
      session[:mobile_param] == "1"
    else
      request.user_agent =~ /Mobile|webOS/
    end
  end
  
end
