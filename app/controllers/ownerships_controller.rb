class OwnershipsController < ApplicationController
  before_action :Authentication
  include ApplicationHelper
  include VariableHelper
  require 'helper/strg'
  require 'uri'

  def ownerships
    render 'ownerships/index'
  end

  # management content ownerships
  def manajemenpacket
    @res = params['res']
    begin
      req = Api::Account::JamaahController.seat(api_url, session[:acc_token], 1)
      @json = req
      # endpoint getdata per user
      @getseat = Api::Account::OwnershipController.allPaket(api_url, session[:acc_token])['data']

      # Pagination
      if !req['data'].nil?
        #Paginator
        @page_html = Paginator::render(@json)
        page = {
            :link_prev => "<a class='page-link btn btn-success' href='?page=#{@page_html[:link_prev]}'>Prev</a>",
            :link_next => "<a class='page-link btn btn-success' href='?page=#{@page_html[:link_next]}'>Next</a>",
            :html => @page_html[:page]
        }

        data = {:data => @json['data'], :page => JSON.parse(page.to_json)}
        @data = JSON.parse(data.to_json)
        render 'accounts/siteowner/managemenpacket'
      else
        @data = nil
        render 'accounts/siteowner/managemenpacket'
      end
    rescue RestClient::ExceptionWithResponse => e
      response = e.response.code

      if response == 400
        redirect_to '/daftar-paket-b2c?res=fails', :flash => {:message => "User Anda tidak terdaftar sebagai Ownership atau sebagai Agen/Mitra", :status => true}
      elsif response == 500 || response.nil?
        Error.log(e, request.original_url)
        render "errors/500", layout: 'application_errors'
      end
    end
  end

  def createpacket
    @res = params['res']
    begin
      @data = Api::Account::OwnershipController.getOnedata(api_url, params[:notrans], session[:acc_token])['data']
      @seat = Api::Account::OwnershipController.getInfoseat(api_url, session[:acc_token], params[:notrans])['data']['sisa_seat']

      render 'accounts/siteowner/createpacket'
    rescue RestClient::ExceptionWithResponse => e
      response = e.response.code

      if response == 400
        redirect_to '/daftar-paket-b2c?res=fails', :flash => {:message => "User Anda tidak terdaftar sebagai Ownership atau sebagai Agen/Mitra", :status => true}
      elsif response == 500 || response.nil?
        Error.log(e, request.original_url)
        render "errors/500", layout: 'application_errors'
      end
    end
  end

  def packetowner
    @res = params['res']
    begin
      @data = Api::Account::OwnershipController.allPaket(api_url, session[:acc_token])['data']
      @data_toko = Api::Account::TokoController.render_detail_toko(api_url, session[:acc_token])

      if !@data.nil? || !@data.empty?
        @data = @data
        render 'accounts/siteowner/packetowner'
      else
        @data = nil
        render 'accounts/siteowner/packetowner'
      end
    rescue RestClient::ExceptionWithResponse => e
      response = e.response.code
      if response == 400
        redirect_to '/daftar-paket-b2c?res=fails', :flash => {:message => "User Anda tidak terdaftar sebagai Ownership atau sebagai Agen/Mitra", :status => true}
      elsif response == 500 || response.nil?
        Error.log(e, request.original_url)
        render "errors/500", layout: 'application_errors'
      end
    end
  end

  def detailpacketowner
    begin
      @data = Api::Account::OwnershipController.getOnedatatrans(api_url, session[:acc_token], params[:notrans])['data']
      session[:no_trans] = @data['no_trans']
      session[:kd_paket] = params[:kp]
      render 'accounts/siteowner/detailpacketowner'
    rescue RestClient::ExceptionWithResponse => e
      response = e.response.code

      if response == 400
        redirect_to '/daftar-paket-b2c?res=fails', :flash => {:message => "User Anda tidak terdaftar sebagai Ownership atau sebagai Agen/Mitra", :status => true}
      elsif response == 500 || response.nil?
        Error.log(e, request.original_url)
        render "errors/500", layout: 'application_errors'
      end
    end
  end

  def setcontent
    render 'accounts/siteowner/settings'
  end

  def pesananpaket
    data = Api::Account::OwnershipController.get_order_list(api_url, session[:acc_token], params[:page], 0)
    @data = data[:data]
    @page = data[:page]
    render 'accounts/siteowner/pesananpaket'
  end

  def historypesanan
    data = Api::Account::OwnershipController.get_order_list(api_url, session[:acc_token], params[:page], 1)
    @data = data[:data]
    @page = data[:page]
    render 'accounts/siteowner/historypesanan'
  end

  def profil_toko
    @res = params['res']
    begin
      @data_toko = Api::Account::TokoController.render_detail_toko(api_url, session[:acc_token])
      render 'accounts/siteowner/settings'
    rescue RestClient::ExceptionWithResponse => e
      response = e.response.code

      if response == 400
        redirect_to '/daftar-paket-b2c?res=fails', :flash => {:message => "User Anda tidak terdaftar sebagai Ownership atau sebagai Agen/Mitra", :status => true}
      elsif response == 500 || response.nil?
        Error.log(e, request.original_url)
        render "errors/500", layout: 'application_errors'
      end
    end
  end

  def pengaturansite
    @res = params['res']
    begin
      @data = Api::Account::OwnershipController.getDataPengaturanSeat(session[:acc_token])['data']
      data_provinsi = Api::Account::LokasiController.renderProvinsi(api_url, session[:acc_token])

      @provinsi = data_provinsi

      # render json: @data
      render 'accounts/siteowner/settingsite'
    rescue Exception => e
      data_provinsi = Api::Account::LokasiController.renderProvinsi(api_url, session[:acc_token])
      
      @provinsi = data_provinsi
      # Handle error ketika user belum memiliki status ownership
      @data = {:data => ''}
      # render json: @data
      render 'accounts/siteowner/settingsite'
    end

  end

  def editpacket
    @data = Api::Account::OwnershipController.getOnepacket(api_url, session[:acc_token], params[:kdpaket])['data' ]
    render 'accounts/siteowner/editpacket'
  end
  
  def konfirmasi_pesanan
    data = Api::Account::OwnershipController.konfirmasi_pesanan(api_url, session[:acc_token], params[:kode_booking])
    if data['status'] == 200
      AbuMailer.konfirmasi_pemesanan(api_url, session[:acc_token], params[:kode_booking]).deliver
      redirect_to '/semua-pesanan-paket', :flash => { :message => "Sukses mengkonfirmasi pesanan. SMS/Email telah dikirim ke pemesan"  }
    else
      redirect_to '/semua-pesanan-paket', :flash => { :error => data['message'] }
    end
  end

  def penjualan
    data = Api::Account::OwnershipController.get_pembayaran_list(api_url, session[:acc_token], params[:page], 'Pending')
    @data = data[:data]
    @page = data[:page]
    render 'accounts/siteowner/penjualan'
  end

  def history_penjualan
    data = Api::Account::OwnershipController.get_pembayaran_list(api_url, session[:acc_token], params[:page], 'Approve')
    @data = data[:data]
    @page = data[:page]
    render 'accounts/siteowner/history_penjualan'
  end

  def dateseat
    @date_bln = Api::Account::OwnershipController.available_bln_thn(session[:acc_token],params[:kdpaket])
    @date_full = Api::Account::OwnershipController.available_fulldate(session[:acc_token],params[:kdpaket], '', '')['data']
    @getPaket = params[:kdpaket]
    @getYear = @date_full.first['tanggal'][0, 4]
    @getMonth = @date_full.first['tanggal'][5, 2]
    session[:kdbooking] = params[:kdbooking]
    # render json: @date_full
    # render json: @date_full
    render 'accounts/partnerbisnis/seat/datetimes'
  end

  def dateseatBytgl
    # @data_produk = Api::Account::OwnershipController.getOnedatatrans(api_url, session[:acc_token], params[:kdpaket])['data']
    @date_bln = Api::Account::OwnershipController.available_bln_thn(session[:acc_token],params[:kdpaket])
    @date_full = Api::Account::OwnershipController.available_fulldate(session[:acc_token],params[:kdpaket], params[:bln], params[:thn])['data']
    @get_booking = params[:kdbooking]
    @getPaket = params[:kdpaket]
    @get_kantor = params[:kdkantor]
    @getYear = params[:thn]
    @getMonth = params[:bln]

    # render json: @get_kantor
    # render json: @date_full and return
    render 'accounts/partnerbisnis/seat/datetimes'
  end

  def deletesession
    cek = session.delete(:no_trans)
    cek1 = session.delete(:kd_paket)
    cek2 = session.delete(:kdbooking)

    if cek.nil? && cek1.nil? && cek2.nil?
      render json: 'sukses'
    else
      render :json => {:no_trans => cek, :kd_paket => cek1, :kode_booking => cek2 }
    end
  end
end


