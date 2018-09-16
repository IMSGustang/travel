class PaymentController < ApplicationController
  before_action :Authentication
  include VariableHelper
  require 'helper/number'
  layout "application_payments"

  def metodepembayaran
    @res = params[:res]
    @type = params[:payment_type]
    if params[:type] == 'kemitraan'
      paket_umrah = Api::Account::PaketUmrahAgenController.renderingDetail(params[:p], params[:kk], session[:acc_token], params[:bln], params[:th])
    elsif params[:type] == 'haji'
      paket_umrah = Api::Account::PaketHajiController.renderingDetail(api_url, params[:p], params[:kk], session[:acc_token], params[:bln], params[:th])
    else
      paket_umrah = Api::Account::PaketUmrahController.renderingDetail(api_url, params[:p], params[:kk], session[:acc_token], params[:bln], params[:th])
    end
    @bank = Api::Account::BankController.listBank(api_url, paket_umrah['tipe_curr'] ? paket_umrah['tipe_curr'] : 'IDR')['data']
    @paket = paket_umrah
    @voucher = Api::Account::VoucherController.checkVoucher(params, session).to_i

    if @type
      if @type == "deposit"
        if mobile_device?
          render '/mobile/sites/payments/umrah/mobilePaymentMethodDetailDeposit', layout: 'application_mobile'
        else
          render 'payment/metodepembayaran'
        end
      elsif @type == "transfer"
        if mobile_device?
          render '/mobile/sites/payments/umrah/mobilePaymentMethodDetailTransfer', layout: 'application_mobile'
        else
          render 'payment/metodepembayaran'
        end
      else
        if mobile_device?
          render '/mobile/sites/payments/umrah/mobilePaymentMethod', layout: 'application_mobile'
        else
          render 'payment/metodepembayaran'
        end
      end
    else
      if mobile_device?
        render '/mobile/sites/payments/umrah/mobilePaymentMethod', layout: 'application_mobile'
      else
        render 'payment/metodepembayaran'
      end
    end
    # render json: @bank
  end

  def metodepembayarantiket
    @data = Api::Account::TransaksiController.metodePembayaranTiketDetail(session[:acc_token], session[:tiket], params['kt'])['dataMain']
    # render json: @data
    @bank = Api::Account::BankController.listBank(api_url)['data']
    # @payment = Api::Account::TiketPesawatController.paymetChecker(session[:acc_token], params['fi'])
    # render json: @payment
    render 'payment/metodepembayarantiket'
  end

  def metode
    render 'payment/metode'
  end

  def pembayaranlangsung
    render 'payment/pembayaranlangsung'
  end

  def pembayarantransfer
    begin
      @res = params['res']
      if params[:type] == 'kemitraan'
        paket = Api::Account::PaketUmrahAgenController.renderingDetail(params[:p], params[:kk], session[:acc_token], params[:bln], params[:th])
      elsif params[:type] == 'tiket'
        paket_json = Api::Account::TiketPesawatController.infoPenumpang(session[:acc_token], session[:tiket], params['fi'], params['rfi'])
        paket_json_detail = Api::Account::TransaksiController.metodePembayaranTiketDetail(session[:acc_token], session[:tiket], params['kt'])
        if !paket_json.nil?
          # Jika pulang pergi
          if !paket_json_detail['dataChild'].to_a[1].nil?
            data_tiket_berangkat = []
            data_tiket_pulang = []

            paket_json['departures']['flight_infos']['flight_info'].each do |i|
              data_tiket_berangkat << {
                'gambar' => i['img_src']
              }
            end

            paket_json['returns']['flight_infos']['flight_info'].each do |i|
              data_tiket_pulang << {
                'gambar' => i['img_src']
              }
            end

            data_paket = {
              'type' => 'tiket',
              'flight_type' => 'two_ways',
              'berangkat' => data_tiket_berangkat,
              'berangkat_nama' => paket_json['departures']['departure_city_name'] + "-" + paket_json['departures']['arrival_city_name'],
              'pulang' => data_tiket_pulang,
              'pulang_nama' => paket_json['returns']['departure_city_name'] + "-" + paket_json['returns']['arrival_city_name'],
              'harga' => paket_json_detail['dataMain']['harga']
            }
          paket = JSON.parse(data_paket.to_json)
          else
          #jika sekali jalan 
            paket = {
              'gambar' => paket_json['departures']['image'],
              'harga_jual' => paket_json_detail['dataMain']['harga'],
              'nama' => paket_json['departures']['departure_city_name'] + "-" + paket_json['departures']['arrival_city_name']
            }
          end

        else
          paket = {
            'gambar' => "http://via.placeholder.com/140x100",
            'harga_jual' => '',
            'nama' => paket_json['departure_city_name'] + "-" + paket_json['arrival_city_name']
          }
        end
        
      else
        paket = Api::Account::PaketUmrahController.renderingDetail(api_url, params[:p], params[:kk], session[:acc_token], params[:bln], params[:th])
      end
      @paket = paket
      render 'payment/pembayarantransfer'
    rescue Exception => e
      if params['debug'] == 'true'
        render json: JSON.pretty_generate(Api::HelperController::Error(e, request.original_url, session));
      else
        render '/errors/500', layout: 'application_errors'
      end
    end
  end

  def tagihanpembayaran
    render 'payment/tagihanpembayaran'
  end

  def formpemesanan
    profil = Api::Account::UserProfilController.user_detail(session[:acc_token])
    if params[:type] == 'kemitraan'
      paket_umrah = Api::Account::PaketUmrahAgenController.renderingDetail(params[:id_produk], params[:kk], session[:acc_token], params[:bln], params[:th])
    elsif params[:type] == 'umrah-single'
      paket_umrah = Api::Account::PaketUmrahController.renderingDetail(api_url, params[:id_produk], params[:kk], session[:acc_token], params[:bln], params[:th])
    elsif params[:type] == 'haji'
      paket_umrah = Api::Account::PaketHajiController.renderingDetail(api_url, params[:id_produk], params[:kk], session[:acc_token], params[:bln], params[:th])
    end

    @data = JSON.parse(profil)
    @paket = paket_umrah
    @tahun = params[:th]
    @hari = params[:lu]
    @jumlah_voucher_tersedia = @paket['discounts'] != nil ? @paket['discounts'].count : 0

    if mobile_device?
      render '/mobile/sites/payments/umrah/mobileDataBuyer', layout: 'application_mobile'
    else
      render 'payment/formpemesananpaket'
      # render json: @paket
    end
    # render json: @paket
  end

  def inputdatajamaah
    render 'payment/inputdatajamaah'
  end

  def formpembelian
    render 'payment/formpemesananstore'
  end

  def formpemesanantours
    render 'payment/formpemesanantours'
  end

  def datapemesanantiket
    begin
      @res = params['res']
    # render 'payment/formpemesanantiket'
      @info_flight = Api::Account::TiketPesawatController.infoPenumpang(session[:acc_token], session[:tiket], params['fi'], params['rfi'])
      @countryTiket = Api::Account::TiketPesawatController.listCountry(session[:acc_token], 'f00d9fcdadde7d6ffe2e196e043ab21b5e8b2d72')['listCountry']


      array_flight = [
        'separator',
        'conSalutation',
        'conFirstName',
        'conLastName',
        'conPhone',
        'conEmailAddress'
      ]

      adult = @info_flight['departures']['count_adult']
      child = @info_flight['departures']['count_child']
      infant = @info_flight['departures']['count_infant']

      (1..adult.to_i).each do |item|
        array_flight << "separator_adult#{item}"
        array_flight << "titlea#{item}"
        array_flight << "firstnamea#{item}"
        array_flight << "lastnamea#{item}"
        array_flight << "birthdatea#{item}"
        array_flight << "passportnationalitya#{item}"
        array_flight << "passportnoa#{item}"
        array_flight << "passportExpiryDatea#{item}"
        array_flight << "passportissuinga#{item}"
      end

      (1..child.to_i).each do |item|
        array_flight << "separator_child#{item}"
        array_flight << "titlec#{item}"
        array_flight << "firstnamec#{item}"
        array_flight << "lastnamec#{item}"
        array_flight << "birthdatec#{item}"
        array_flight << "passportnationalityc#{item}"
        array_flight << "passportnoc#{item}"
        array_flight << "passportExpiryDatec#{item}"
        array_flight << "passportissuingc#{item}"
      end

      (1..infant.to_i).each do |item|
        array_flight << "separator_infant#{item}"
        array_flight << "titlei#{item}"
        array_flight << "firstnamei#{item}"
        array_flight << "lastnamei#{item}"
        array_flight << "birthdatei#{item}"
        array_flight << "passportnationalityi#{item}"
        array_flight << "passportnoi#{item}"
        array_flight << "passportExpiryDatei#{item}"
        array_flight << "passportissuingi#{item}"
      end
      array_flight_available = @info_flight['required'].keys - array_flight
      @html = []
      @html_s = {}
      array_flight_available.each do |item|
        array_for_html = @info_flight['required'][item]
        if array_for_html['type'] == 'datetime'
          @html << {:html => "<div class='col-6'><label class='col-form-label'>#{array_for_html['FieldText']}</label><input type='text' class='form-control timepicker' name='#{item}' id='' placeholder='' value=''></div>", :type => array_for_html['category']}
        end

        if array_for_html['type'] == 'combobox'
          if array_for_html['resource'].is_a? String
            resource_for_html = Api::Account::TiketPesawatController.listCountry(session[:acc_token], session[:tiket])
            @resource = []
            resource_for_html['listCountry'].each do |res|
              @resource << "<option value='#{res['country_id']}'> #{res['country_name']} </option>"
            end
          else
            @resource = []
            array_for_html['resource'].each do |res|
              @resource << "<option value='#{res['id']}'> #{res['name']} </option>"
            end
          end
          # render json: @res
          @html << {:html => "<div class='col-6'><label class='col-form-label'>#{array_for_html['FieldText']}</label><select class='dewasa' name='#{item}'>" + @resource.join + "</select></div>", :type => array_for_html['category']}
        end
      end
      render 'accounts/evoucher/tiket-pesawat/book'
    rescue Exception => e
      Error.log(e, request.original_url)
      render "errors/500", layout: 'application_errors'
    end
  end

  def detilpembelian
    render 'payment/detilpembelianevoucher'
  end

  def otpdeposit
    begin
      @res = params['res']

      if params['type'] == 'tiket'
        flight_id = Api::Account::TransaksiController.metodePembayaranTiketDetail(session[:acc_token], session[:tiket], params[:kode])
        if flight_id['dataChild'].count > 1
          @data = Api::Account::TiketPesawatController.infoPenumpang(session[:acc_token], session[:tiket], flight_id['dataChild'][0]['flight_id'], flight_id['dataChild'][1]['flight_id'])
        else
          @data = Api::Account::TiketPesawatController.infoPenumpang(session[:acc_token], session[:tiket], flight_id['dataChild'][0]['flight_id'])
        end
        
      end
      # render json: flight_id
      render 'payment/OtpDeposit'
    rescue Exception => e
      Error.log(e, request.original_url)
      render "errors/500", layout: 'application_errors'
    end
  end

  def formtoko
    @res = params['res']
    @data = Api::Account::OwnershipController.detailPaketOwnerships(params)['data']
    @data_detail = Api::Account::OwnershipController.detailPaketOwnerships(params)['detail_umrah']
    # render json: @data
    render 'payment/formpemesanantoko'
  end


  def pemesananhotel
    render 'payment/formpemesananhotel'
  end
end
