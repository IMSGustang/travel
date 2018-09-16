class Api::Account::OwnershipController < ApplicationController
  skip_before_action :verify_authenticity_token
  include VariableHelper
  require 'rest-client'
  require 'json'
  require 'helper/error'
  require 'helper/time'
  require "base64"

  @api_url = VariableHelper.api_url

  def self.getOnedata(api_url, kode_transaksi, session)
    begin
      req = RestClient.get api_url + '/pembayaran/' + kode_transaksi, {
          Authorization: "Bearer #{session}",
      }

      @json = JSON.parse(req)
      return @json
    rescue RestClient::ExceptionWithResponse => err
      @err_respon = JSON.parse(err.response)
      @err_json = {
          :status => false
      }
      return @err_respon
    end
  end

  def createPaket
    # Base64 Image Encode
    begin
      uploader = AvatarUploader.new
      uploader.store!(params['photo'])
      uploader.retrieve_from_store!('')

      image = File.open("#{Rails.public_path}/temp-file/#{uploader.identifier}") {|img| img.read}
      encoded_image = Base64.encode64 image

      image = MiniMagick::Image.open("#{Rails.public_path}/temp-file/#{uploader.identifier}")

      base64_image = "data:image/#{image.type};base64,#{encoded_image}"

      if(params[:diskon] == '')
        diskon = 0
      else
        diskon = params[:diskon]
      end

      @res = RestClient.post api_url + "/ownership/paket", {
          'no_transaksi' => params[:no_trans],
          'nama_paket' => params[:nama_paket],
          'gambar' => base64_image.gsub!(/\s+/, ''),
          'harga_dasar' => params[:harga_dasar].gsub(/[^0-9]/, ''),
          'pax' => params[:pax],
          'jmh' => params[:jmh],
          'harga_jual' => params[:harga_jual].gsub(/[^0-9]/, ''),
          'diskon' => diskon
      }, {
                                 'Authorization' => "Bearer #{session[:acc_token]}",
                                 'Accept' => 'application/json',
                                 'Content-Type' => 'application/json'
                             }
      # render json: @res
      @json = JSON.parse(@res)
      redirect_to '/manajemen-paket?res=success', :flash => {:message => "Data berhasil disimpan.", :status => true}
    rescue RestClient::ExceptionWithResponse => err

      if err.response.code == 500
        render '/errors/500', layout: 'application_errors'
      elsif err.response.code == 400
        redirect_to "/create-packet/#{params[:no_trans]}?res=fails", :flash => {:message => "Pax yang Anda masukan melebihi kuota.", :status => true}
      else
        render json: err.response
      end
    end
  end

  def self.allPaket(api_url, session)
    req = RestClient.get api_url + '/ownership/paket/list_paket', {
        Authorization: "Bearer #{session}",
    }

    @json = JSON.parse(req)
    return @json
  end

  def self.getOnedatatrans(api_url, session, notrans)
    req = RestClient.get api_url + '/users/ebooking/' + notrans, {
        Authorization: "Bearer #{session}",
    }

    @json = JSON.parse(req)
    return @json
  end

  def pegaturanSite
    begin
      files = Api::UploaderController.new

      if !params[:logo].nil?
        logo = files.uploader(params[:logo])
      end

      if !params[:banner].nil?
        banner = files.uploader(params[:banner])
      end

      @res = RestClient.post api_url + "/ownership/update_profil", {
          'nama_perusahaan' => params[:nama_perusahaan],
          'situ' => params[:situ],
          'siup' => params[:siup],
          'npwp' => params[:npwp],
          'provinsi_id' => params[:provinsi],
          'kabkot_id' => params[:kabkot],
          'kecamatan_id' => params[:kecamatan],
          'kelurahan' => params[:kelurahan],
          'alamat' => params[:alamat],
          'brand' => params[:brand],
          'domain_alias' => params[:domain_alias],
          'tagline' => params[:tagline],
          'tentang_kami' => params[:tentang_kami],
          'logo' => logo,
          'banner' => banner
      }, {
                                 'Authorization' => "Bearer #{session[:acc_token]}",
                                 'Accept' => 'application/json',
                                 'Content-Type' => 'application/json'
                             }
      json = JSON.parse(@res)
      redirect_to "/pengaturan-site-ownerships?res=#{Error::code(json['status'])}", :flash => {:message => json['message'], :status => true}
    rescue RestClient::ExceptionWithResponse => err
      json = JSON.parse(err.response)
      redirect_to "/pengaturan-site-ownerships?res=#{Error::code(json['status'])}", :flash => {:message => json['message'], :status => true}
    end
  end

  def self.getDataPengaturanSeat(token)
    begin
      @res = RestClient.get @api_url + "/ownership/me", {
          'Authorization' => "Bearer #{token}"
      }

      return JSON.parse(@res)
    rescue RestClient::ExceptionWithResponse => err
      return err
    end

  end

  def self.getOnepacket(api_url, session, kdpaket)
    begin
      @res = RestClient.get api_url + 'ownership/paket/' + kdpaket, {
          Authorization: "Bearer #{session}",
          'Accept' => "application/json",
          'Content-Type' => "application/json",

      }
      @json = JSON.parse(@res)
      return @json
    rescue RestClient::ExceptionWithResponse => err
      return err.response
    end
  end

  def updatePaket
    # Base64 Image Encode
    if !params['photo'].nil?
      begin
        uploader = AvatarUploader.new
        uploader.store!(params['photo'])
        uploader.retrieve_from_store!('')

        image = File.open("#{Rails.public_path}/temp-file/#{uploader.identifier}") {|img| img.read}
        encoded_image = Base64.encode64 image

        image = MiniMagick::Image.open("#{Rails.public_path}/temp-file/#{uploader.identifier}")

        base64_image = "data:image/#{image.type};base64,#{encoded_image}"

        @res = RestClient.put api_url + "/ownership/paket/#{params[:kdpaket]}", {
            'nama_paket' => params[:nama_paket],
            'harga_dasar' => params[:harga_dasar].gsub(/[^0-9]/, ''),
            'harga_jual' => params[:harga_jual].gsub(/[^0-9]/, ''),
            'diskon' => params[:is_active],
            'is_active' => params[:diskon],
            'gambar' => base64_image.gsub!(/\s+/, '')
        }, {
                                  'Authorization' => "Bearer #{session[:acc_token]}",
                                  'Accept' => 'application/json',
                                  'Content-Type' => 'application/json'
                              }
        @json = JSON.parse(@res)
        redirect_to '/paket-saya?res=success', :flash => {:message => "Paket berhasil diperbaharui", :status => true}
      rescue RestClient::ExceptionWithResponse => err
        if err.response.code == 500
          render '/errors/500', layout: 'application_errors'
        else
          render json: err.response
        end
      end
    else
      begin
        @res = RestClient.put api_url + "/ownership/paket/#{params[:kdpaket]}", {
            'nama_paket' => params[:nama_paket],
            'harga_dasar' => params[:harga_dasar].gsub(/[^0-9]/, ''),
            'harga_jual' => params[:harga_jual].gsub(/[^0-9]/, ''),
            'is_active' => params[:is_active],
            'diskon' => params[:diskon]
        }, {
                                  'Authorization' => "Bearer #{session[:acc_token]}",
                                  'Accept' => 'application/json',
                                  'Content-Type' => 'application/json'
                              }
        @json = JSON.parse(@res)
        redirect_to '/paket-saya?res=success', :flash => {:message => "Paket berhasil diperbaharui", :status => true}
      rescue RestClient::ExceptionWithResponse => err
        if err.response.code == 500
          render '/errors/500', layout: 'application_errors'
        else
          render json: err.response
        end
      end
    end
  end

  def self.get_order_list(api_url, token, page, is_confirmed)
    begin
      res = RestClient.get "#{api_url}/ownership/orders", {
          'Authorization' => "Bearer #{token}",
          'x-page' => page,
          'x-per-page' => 8,
          'x-is-confirmed' => is_confirmed
      }
      @json = JSON.parse(res)
      @page_html = Paginator::render(@json)
      page = {
          :link_prev => "<a class='page-link btn btn-success' href='?page=#{@page_html[:link_prev]}'>Prev</a>",
          :link_next => "<a class='page-link btn btn-success' href='?page=#{@page_html[:link_next]}'>Next</a>",
          :html => @page_html[:page]
      }
      return {:data => @json['data'], :page => page}
    rescue RestClient::ExceptionWithResponse => err
      return err
    end
  end

  def self.konfirmasi_pesanan(api_url, token, kode_booking)
    begin
      url = "#{api_url}ownership/konfirmasi_pemesanan/#{kode_booking}"
      res = RestClient.post url, {}, {'Authorization' => "Bearer #{token}"}
      json = JSON.parse(res)
      return json
    rescue RestClient::ExceptionWithResponse => err
      return JSON.parse(err.response)
    end
  end

  def self.kirim_email_status_pesanan

  end

  def self.get_order_detail(api_url, token, kode_booking)
    begin
      res = RestClient.get "#{api_url}/ownership/orders/#{kode_booking}", {'Authorization' => "Bearer #{token}"}
      @json = JSON.parse(res)
      return @json['data']
    rescue RestClient::ExceptionWithResponse => err
      return err
    end
  end

  def self.get_pembayaran_list(api_url, token, page, status_bayar)
    begin
      res = RestClient.get "#{api_url}/ownership/pembayaran", {
          'Authorization' => "Bearer #{token}",
          'x-page' => page,
          'x-per-page' => 8,
          'x-status-bayar' => status_bayar
      }
      @json = JSON.parse(res)
      @page_html = Paginator::render(@json)
      page = {
          :link_prev => "<a class='page-link btn btn-success' href='?page=#{@page_html[:link_prev]}'>Prev</a>",
          :link_next => "<a class='page-link btn btn-success' href='?page=#{@page_html[:link_next]}'>Next</a>",
          :html => @page_html[:page]
      }
      return {:data => @json['data'], :page => page}
    rescue RestClient::ExceptionWithResponse => err
      return err
    end
  end

  def self.get_pembayaran_detail(api_url, token, nomor_bayar)
    begin
      res = RestClient.get "#{api_url}/ownership/pembayaran/#{nomor_bayar}", {
          'Authorization' => "Bearer #{token}"
      }
      @json = JSON.parse(res)
      if @json['status'] == 200
        return @json['data']
      end
    rescue RestClient::ExceptionWithResponse => err
      return nil
    end
  end

  def aprroval
    url = "#{api_url}/ownership/approval/#{params[:nomor]}"
    begin
      res = RestClient.post url, {
      }, {
          'Authorization' => "Bearer #{session[:acc_token]}",
          'x-status' => params[:status]
      }
      @json = JSON.parse(res)
      # puts "approval: #{@json}"
      if @json['status'] == 200
        AbuMailer.status_pemesanan(api_url, session[:acc_token], @json['data']['nomor_bayar']).deliver
      end
      render json: @json
    rescue RestClient::ExceptionWithResponse => e
      logger.error "#{e.message} #{e.response}"
      logger.error e.backtrace.join("\n")
      @json = JSON.parse(e.response)
      render json: e.response
    end
  end

  # DMZ -- EDITING -- CODE -- JOININED
  # please insert code not here

  def self.detailPaketOwnerships(params)
    begin
      @res = RestClient.get @api_url + "/users/toko/#{params[:nama_toko]}/paket/#{params[:kode_paket]}", {
        'x-client-id' => VariableHelper::clientId
      }
      json = JSON.parse(@res)
    rescue RestClient::ExceptionWithResponse => e
      return e
    end
  end

  def formPemesananToko
    begin
      nama = Strg.firstLastName(params[:nama])
      # render json: nama
      res = RestClient.post api_url + "/ownership/public/penjualan/#{params[:kode_paket]}", {
        "nama_depan" => nama[:nama_depan],
        "nama_belakang" => nama[:nama_belakang],
        "tanggal_lahir" => params[:tgl_lahir],
        "telepon" => params[:telepon],
        "email" => params[:email],
        "jk" => params[:jk],
        "ktp"=> params[:ktp],
        "telepon_rumah"=> params[:telepon_rumah],
        "provinsi_id"=> params[:provinsi],
        "kabkot_id"=> params[:kota],
        "kecamatan_id"=> params[:kecamatan_id],
        "kelurahan"=> params[:kecamatan],
        "alamat"=> params[:alamat],
        "keterangan"=> params[:catatan]
      }, {
        'x-client-id' => VariableHelper::clientId,
        "x-order-via" => "abutours"
      }
      redirect_to request.referer + "?res=success", :flash => { :message => 'Berhasil memesan paket', :status => "true"}
    rescue RestClient::ExceptionWithResponse => e
      render json: e.response
    end
  end

  def self.getInfoseat(api_url, session, notrans)
    begin
      req = RestClient.get api_url + '/ownership/sisa_seat/' + notrans, {
          Authorization: "Bearer #{session}",
      }

      @json = JSON.parse(req)
      return @json
    rescue RestClient::ExceptionWithResponse => e
      return e
    end
  end

  def self.available_bln_thn(session, kdpaket)
    begin
      @res = RestClient.get @api_url + 'ownership/available_bulan_tahun/' + kdpaket, {
          Authorization: "Bearer #{session}",
          'Accept' => "application/json",
          'Content-Type' => "application/json",
          'x-bulan' => 05,
          'x-tahun' => 2018,

      }
      @json = JSON.parse(@res)
      return @json
    rescue RestClient::ExceptionWithResponse => err
      return err.response
    end
  end

  def self.available_fulldate(session, kdpaket, bln, thn)
    begin
      @res = RestClient.get @api_url + 'ownership/available_seat/' + kdpaket, {
          Authorization: "Bearer #{session}",
          'Accept' => "application/json",
          'Content-Type' => "application/json",
          'x-bulan' => bln,
          'x-tahun' => thn,

      }
      @json = JSON.parse(@res)
      return @json
    rescue RestClient::ExceptionWithResponse => err
      return err.response
    end
  end

end
