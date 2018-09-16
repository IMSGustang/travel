class AccountsController < ApplicationController
  before_action :Authentication
  include ApplicationHelper
  include ActionView::Helpers::TextHelper
  require 'helper/time'
  require 'helper/number'
  require 'helper/strg'
  require 'helper/error'
  require 'helper/encryption'

  def dashboard
    begin
      @progress_profil = Api::Account::UserProfilController.profil_progress(session[:acc_token])
      data = Api::Account::JamaahController.seat(api_url, session[:acc_token], 0)
      @jumlah_seat = 0
      if data && data['status'] == 200
        data_seats = data['data']
        data_seats.each {|d| @jumlah_seat += d['booking'].count}
      end

      data1 = Api::Account::JamaahController.jamaah(api_url, session[:acc_token], '')
      @jumlah_jamaah = 0

      if data1 && data1[:data]
        data_jamaah = data1[:data]
        # data_jamaah.each {|d| @jumlah_jamaah += d['jamaah'].count }
        @jumlah_jamaah = data_jamaah.count
      end

      if mobile_device?
        render 'mobile/accounts/dashboard/_profile/mobileProfileUsers', layout: 'application_mobile'
      else
        render 'accounts/dashboard'
      end

    rescue => e
      if params['debug'] == 'true'
        render json: JSON.pretty_generate(Api::HelperController::Error(e, request.original_url, session));
      else
        render '/errors/500', layout: 'application_errors'
      end
    end
  end


  # -- panel partner bisnis _agen & mitra --
  def home
    render 'accounts/partnerbisnis/home'
  end

  def formupgrade
    render 'accounts/partnerbisnis/formupgrade'
  end

  def datajamaah
    begin
      @res = params['res']
      data_jamaah = Api::Account::JamaahController.jamaah(api_url, session[:acc_token], request['kode_booking'])
      @data = data_jamaah[:data]
      @page = data_jamaah[:page]
      # render json: @page
      if mobile_device?
        render 'mobile/accounts/jamaah/daftarJamaah', layout: 'application_mobile'
      else
        render 'accounts/partnerbisnis/jamaah/data'
      end
    rescue => e
      if params['debug'] == 'true'
        render json: JSON.pretty_generate(Api::HelperController::Error(e, request.original_url, session));
      else
        render '/errors/500', layout: 'application_errors'
      end
    end
  end

  def manifestbus
    render 'accounts/partnerbisnis/manifest/group_bus'
  end

  def manifesthotel
    render 'accounts/partnerbisnis/manifest/group_hotel'
  end

  def seat
    begin
      data = Api::Account::JamaahController.seat(api_url, session[:acc_token], 0)['data']

      seats = Api::Account::SeatController.render_riwayat_transfer(api_url, session[:acc_token], params['page'], '10')
      puts "result: #{seats}"
      if seats
        @data2 = seats[:data]
        @page2 = seats[:page]
      else
        @data2 = nil
        @page2 = nil
      end

      # delete session for ownership
      session.delete(:no_trans)
      session.delete(:kd_paket)
      session.delete(:kdbooking)
      # end
      if !data.nil?
        @data = data
        if mobile_device?
          render 'mobile/accounts/seatumrah/index', layout: 'application_mobile'
        else
          render 'accounts/partnerbisnis/seat/index'
        end
      else
        @data = nil
        if mobile_device?
          render 'mobile/accounts/seatumrah/index', layout: 'application_mobile'
        else
          render 'accounts/partnerbisnis/seat/index'
        end
      end
    rescue => e
      if params['debug'] == 'true'
        render json: JSON.pretty_generate(Api::HelperController::Error(e, request.original_url, session));
      else
        render '/errors/500', layout: 'application_errors'
      end
    end
    # render json: @data
  end

  # seat kcp controller
  def seatKcp
    begin
      data = Api::Account::JamaahController.seat(api_url, session[:acc_token], 0)['data']
      # delete session for ownership
      session.delete(:no_trans)
      session.delete(:kd_paket)
      session.delete(:kdbooking)
      # end
      if !data.nil?
        @data = data
        render 'accounts/partnerbisnis/seat_kcp/index'
      else
        @data = nil
        render 'accounts/partnerbisnis/seat_kcp/index'
      end
    rescue => e
      if params['debug'] == 'true'
        render json: JSON.pretty_generate(Api::HelperController::Error(e, request.original_url, session));
      else
        render '/errors/500', layout: 'application_errors'
      end
    end
  end

  def seatmarkup
    @req = Api::Account::JamaahController.detailJamaah(api_url, session[:acc_token], params[:kdbook])['data']['detail_paket']
    @bln = Api::Account::JamaahController.available_bln(api_url, session[:acc_token], params[:kdproduk])['data']
    session[:kcp_trans] = @req['notrans']
    render 'accounts/partnerbisnis/seat_kcp/markup'
  end

  def kcpaddjamaah
    data = params
    @provinsi = Api::Account::LokasiController.renderProvinsi(api_url, session[:acc_token])
    @kabkot = Api::Account::LokasiController.renderKabKot(session[:acc_token])
    @kecamatan = Api::Account::LokasiController.renderKecSl(session[:acc_token])
    # session for post penjualan
    session[:bulan] = data['bulan']
    session[:harga_dasar] = data['harga_dasar'].gsub(/[^0-9]/, '')
    session[:markup] = data['harga_jual'].gsub(/[^0-9]/, '')
    session[:harga_jual] = data['kdbook'].gsub(/[^0-9]/, '')
    session[:diskon] = data['kdbook']
    # end
    # render json: session[:harga_dasar] and return
    render 'accounts/partnerbisnis/seat_kcp/addJamaah', locals: {data: data}
  end

  def historykcp
    @req = Api::Account::JamaahController.getHistorikcp(api_url, session[:acc_token]);
    # render json: @req['data']['kcp_trans'] and return
    render 'accounts/partnerbisnis/seat_kcp/historyPenggunaanKcp'
  end

  def invoicekcp
    @penjualan = Api::Account::JamaahController.getDetailPenjualan(api_url, session[:acc_token], params[:kcptrans])
    # render json: @penjualan and return
    render 'accounts/partnerbisnis/seat_kcp/kcp-invoice'
  end

  def addjamaah
    begin
      info_jamaah = Api::Account::JamaahController.detailJamaah(api_url, session[:acc_token], params[:kode])
      @provinsi = Api::Account::LokasiController.renderProvinsi(api_url, session[:acc_token])
      @kabkot = Api::Account::LokasiController.renderKabKot(session[:acc_token])
      @kecamatan = Api::Account::LokasiController.renderKecSl(session[:acc_token])
      @data = info_jamaah['data']
      # render json: @kecamatan
      if mobile_device?
        render 'mobile/accounts/jamaah/addJamaah', layout: 'application_mobile'
      else
        render 'accounts/partnerbisnis/seat/addjamaah'
      end
    rescue => e
      if params['debug'] == 'true'
        render json: JSON.pretty_generate(Api::HelperController::Error(e, request.original_url, session));
      else
        render '/errors/500', layout: 'application_errors'
      end
    end
  end

  def transferseat
    begin
      if request.post?
      else
        info_jamaah = Api::Account::JamaahController.detailJamaah(api_url, session[:acc_token], params[:kode])
        @data = info_jamaah['data']
        if @data.nil?
          flash[:warning] = 'Data ebooking tidak ditemukan.'
        end
        if mobile_device?
          render 'mobile/accounts/transferseat/index', layout: 'application_mobile'
        else
          render 'accounts/partnerbisnis/seat/transferseat'
        end
      end
    rescue => e
      if params['debug'] == 'true'
        render json: JSON.pretty_generate(Api::HelperController::Error(e, request.original_url, session));
      else
        render '/errors/500', layout: 'application_errors'
      end
    end
  end

  def riwayatseat
    begin
      seats = Api::Account::SeatController.render_riwayat_transfer(api_url, session[:acc_token], params['page'], '10')
      puts "result: #{seats}"
      if seats
        @data = seats[:data]
        @page = seats[:page]
      else
        @data = nil
        @page = nil
      end
      if mobile_device?
        render 'mobile/accounts/seatumrah/index', layout: 'application_mobile'
      else
        render 'accounts/partnerbisnis/seat/riwayat'
      end
    rescue => e
      if params['debug'] == 'true'
        render json: JSON.pretty_generate(Api::HelperController::Error(e, request.original_url, session));
      else
        render '/errors/500', layout: 'application_errors'
      end
    end
  end

  def addvoucher
    render 'accounts/partnerbisnis/voucher/index'
  end

  def daftarvoucher
    begin
      data_voucher = Api::Account::VoucherController.render_voucher(api_url, session[:acc_token], params['page'], '10')
      if data_voucher
        @data = data_voucher[:data]
        @page = data_voucher[:page]
      end
      if mobile_device?
        render 'mobile/accounts/voucher/index', layout: 'application_mobile'
      else
        render 'accounts/partnerbisnis/voucher/voucher'
      end
    rescue => e
      if params['debug'] == 'true'
        render json: JSON.pretty_generate(Api::HelperController::Error(e, request.original_url, session));
      else
        render '/errors/500', layout: 'application_errors'
      end
    end
  end

  def riwayatvoucher
    render 'accounts/partnerbisnis/voucher/transaksi'
  end

  def poin
    @res = params['res']
    begin
      @data_poin = Api::Account::PoinController.renderPoin(api_url, session[:acc_token])
      @data_history = Api::Account::PoinController.history(api_url, session[:acc_token])
      @data_reward = Api::Account::PoinController.poinReward(api_url, session[:acc_token])['data']
      if mobile_device?
        render 'mobile/accounts/poin/index', layout: 'application_mobile'
      else
        render 'accounts/partnerbisnis/poin/index'
      end
    rescue => e
      if params['debug'] == 'true'
        render json: JSON.pretty_generate(Api::HelperController::Error(e, request.original_url, session));
      else
        render '/errors/500', layout: 'application_errors'
      end
    end
  end

  def transaksipoin
    begin
      @data = Api::Account::PoinController.history(api_url, session[:acc_token])
      render 'accounts/partnerbisnis/poin/transaksi'
    rescue Exception => e
      if params['debug'] == 'true'
        render json: JSON.pretty_generate(Api::HelperController::Error(e, request.original_url, session));
      else
        render '/errors/500', layout: 'application_errors'
      end
    end
  end


  # -- panel controller informasi ---
  def konfirmasipembayaran
    begin
      if params['type'] == 'deposit'
        data_api = Api::Account::TransaksiController.konfirmasiTopUpAbupayDetail(session[:acc_token], params[:kode])
        data_bank = Bank::abutours(data_api['kode_bank'])
        data_api_json = {
            'data' => {
                'data' => {
                    'no_trans' => data_api['kode_transaksi'],
                    'tgl_trans' => data_api['created_at'],
                    'metodebayar' => 'TRANSFER',
                    'harga_bayar' => data_api['nominal_transfer'],
                    'kode_unik' => 0
                }
            },
            'bank' => [
                'kdbank' => data_bank['kdbank'],
                'norekening' => data_bank['norekening'],
                'nama' => data_bank['nama']
            ]

        }
        data = JSON.parse(data_api_json.to_json)
      elsif params['type'] == 'tiket'
        data_api = Api::Account::TransaksiController.metodePembayaranTiketDetail(session[:acc_token], session[:tiket], params['kode'])
        data_bank = Bank::abutours(data_api['kode_bank'])
        if data_api['dataMain']['bank_penerima'] == nil or data_api['dataMain'] == nil
          data_api_json = {
              'data' => {
                  'data' => {
                      'no_trans' => data_api['kodeTransaksi'],
                      'no_bukti' => data_api['kodeTransaksi'],
                      'tgl_trans' => data_api['dataMain']['created_at'],
                      'metodebayar' => data_api['jenisPembayaran'],
                      'harga_bayar' => data_api['nominalTransfer'],
                      'kode_unik' => 0
                  }
              },
              'bank' => [
                  'kdbank' => "DEPOSIT",
                  'norekening' => "",
                  'nama' => "DEPOSIT"
              ]

          }
        else
          data_bank = Bank::abutours(data_api['dataMain']['bank_penerima'])
          data_api_json = {
              'data' => {
                  'data' => {
                      'no_trans' => data_api['kodeTransaksi'],
                      'no_bukti' => data_api['kodeTransaksi'],
                      'tgl_trans' => data_api['dataMain']['created_at'],
                      'metodebayar' => data_api['jenisPembayaran'],
                      'harga_bayar' => data_api['nominalTransfer'],
                      'kode_unik' => 0
                  }
              },
              'bank' => [
                  'kdbank' => data_bank['kdbank'],
                  'norekening' => data_bank['norekening'],
                  'nama' => data_bank['nama']
              ]

          }
        end
        data = JSON.parse(data_api_json.to_json)
      elsif params['type'] == 'haji'
        data = JSON.parse(Api::Account::TransaksiController.konfirmasiPembayaranDetail(api_url, session[:acc_token], params[:kode]).to_json)
        data_bank = Bank::abutours(data['data']['data']['kdbank'])
        data_api_json = {
            'data' => {
                'data' => {
                    'no_trans' => data['data']['data']['no_trans'],
                    'no_bukti' => '',
                    'tgl_trans' => data['data']['data']['tgl_trans'],
                    'metodebayar' => data['data']['data']['metodebayar'],
                    'harga_bayar' => data['data']['data']['harga_bayar'],
                    'kode_unik' => 0
                }
            },
            'bank' => [
                'kdbank' => data_bank['kdbank'],
                'norekening' => data_bank['norekening'],
                'nama' => data_bank['nama']
            ]
        }
        data = JSON.parse(data_api_json.to_json)
      else
        data = JSON.parse(Api::Account::TransaksiController.konfirmasiPembayaranDetail(api_url, session[:acc_token], params[:kode]).to_json)
      end

      user_bank = Api::Account::BankController.rendering(api_url, session[:acc_token])
      if data['status'] == 404
        if params[:type] == "haji"
          redirect_to "/transaksi-haji?res=fails", :flash => {:message => data['message'], :status => true}
        else
          redirect_to "/transaksi-umrah?res=fails", :flash => {:message => data['message'], :status => true}
        end
      else
        @data = data['data']['data']
        @bank = data['bank']
        @user_bank = user_bank['json']['data']
        # render json: data and return
        if mobile_device?
          render 'mobile/sites/payments/confirmation/mobileConfirmPayment', layout: 'application_mobile'
        else
          render 'accounts/paykonfirmasi/index'
        end
      end
    rescue Exception => e
      if params['debug'] == 'true'
        render json: JSON.pretty_generate(Api::HelperController::Error(e, request.original_url, session));
      else
        render '/errors/500', layout: 'application_errors'
      end
    end
  end

  def thanks
    render 'accounts/paykonfirmasi/thanks'
  end

  # -- panel controller informasi ---
  def informasi
    render 'accounts/informasikeberangkatan/informasi'
  end


  # -- panel controller AbuPay ---
  def topup
    begin
      @res = params['res']
      bank = Api::Account::BankController.rendering(api_url, session[:acc_token])['json']['data']
      @abutours_bank = Api::Account::BankController.listBank(api_url)['data']
      @data = JSON.parse(Api::Account::TransaksiController.logAbupayDeposit(session[:acc_token]))
      @bank = bank
      if mobile_device?
        render 'mobile/accounts/topUp/mobileTopUp', layout: 'application_mobile'
      else
        render 'accounts/abupay/index'
      end

    rescue => e
      if params['debug'] == 'true'
        render json: JSON.pretty_generate(Api::HelperController::Error(e, request.original_url, session));
      else
        render '/errors/500', layout: 'application_errors'
      end
    end
    # render json: bank
  end

  def transaksitopup
    @res = params['res']
    @data = JSON.parse(Api::Account::TransaksiController.logAbupayDeposit(session[:acc_token]))
    # render json: @data
    render 'accounts/abupay/transaksi'
  end

  def topupTagihan
    begin
      id = params[:id]
      begin
        data = JSON.parse(RestClient.get api_url + "mutasi/topup/" + id, {Authorization: "Bearer #{session[:acc_token]}"})
        dataBank = JSON.parse(RestClient.get api_url + "bank/" + data['kode_bank'], {Authorization: "Bearer #{session[:acc_token]}"})
      rescue RestClient::ExceptionWithResponse => err
        @err_data = err.response
        redirect_to "/tambah-saldo-abupay/" + id + "/tagihan?res=fails", :flash => {:message => @err_data['message'], :status => true, :type => 0}
      end
      if mobile_device?
        render 'mobile/accounts/topUp/invoiceTopUp', layout: 'application_mobile', locals: {data: data, dataBank: dataBank}
      else
        render 'accounts/abupay/tagihan', layout: 'application_payments', locals: {data: data, dataBank: dataBank}
      end
    rescue Exception => e
      if params['debug'] == 'true'
        render json: JSON.pretty_generate(Api::HelperController::Error(e, request.original_url, session));
      else
        render '/errors/500', layout: 'application_errors'
      end
    end
  end

  # -- panel saldo priority
  def priority
    render 'accounts/priority/index'
  end


  # -- panel controller naurah ---


  # -- panel daftar paket
  def daftarpaket
    @res = params[:res]
    # begin
    # Session token harus dikirim melalui parameter
    @cabang = Api::Account::LokasiController.CabangKotaAbutours()['data']
    pra_cari = Api::Account::PaketUmrahController.pre_search(api_url, session[:acc_token], '', '', '', '')
    @data_pre_search = pra_cari['data'] if pra_cari && pra_cari['status'] == 200

    kota = params[:kota].gsub(',', ';') if params[:kota]
    if params['type'] == 'search'
      url = request.url
      uri = URI(url)
      uri_query = "&"+uri.query.sub("page=#{params[:page]}", '') if uri.query
      uri = uri_query.sub("&&", "&").sub("&&&", "&") if uri_query

      return_data = Api::Account::PaketUmrahController.pencarianPaket(
          api_url, session[:acc_token],
          params['tahun'],
          params['bulan'],
          '10',
          params['page'],
          kota, nil, params['order'], nil, {:url => uri})
    else
      return_data = Api::Account::PaketUmrahController.rendering(api_url, session[:acc_token], params['page'], '10', params['debug'])
    end
    if params['debug'] == 'true' || params['debug'] == 'true2'
      render json: return_data
    else
      @data = return_data["data"]
      @page = return_data["page"]
      # render json: @page
      # render json: @page

      if mobile_device?
        render 'mobile/accounts/dashboard/_profile/mobileProfileUsers', layout: 'application_mobile'
      else
        render 'accounts/paket/index'
      end
      # render json:
    end
    # rescue => e
    #   Error.log(e, request.original_url)
    #   render "errors/500", layout: 'application_errors'
    # end
  end

  def detilpaket
    begin
      @data = Api::Account::PaketUmrahController.renderingDetail(api_url, params[:kode], params['kk'], session[:acc_token], params[:bln], params[:th])
      # render json: @data
      render 'accounts/paket/detilpaket'
    rescue Exception => e
      if params['debug'] == 'true'
        render json: JSON.pretty_generate(Api::HelperController::Error(e, request.original_url, session));
      else
        render '/errors/500', layout: 'application_errors'
      end
    end
  end


  # -- panel controller entries bank
  def databank
    begin
      @res = params[:res]
      data_bank = Api::Account::BankController.rendering(api_url, session[:acc_token])
      if data_bank != nil
        @data = data_bank['json']['data']
      else
        @data = nil
      end

      if mobile_device?
        render 'mobile/accounts/dashboard/_profile/_edit/mobileDataBank', layout: 'application_mobile'
      else
        render 'accounts/databank/index'
      end
    rescue Exception => e
      if params['debug'] == 'true'
        render json: JSON.pretty_generate(Api::HelperController::Error(e, request.original_url, session));
      else
        render '/errors/500', layout: 'application_errors'
      end
    end

    # render json: data_bank['json']['data']
  end

  def addbank
    @res = params[:res]
    if mobile_device?
      render 'mobile/accounts/dashboard/_profile/_edit/mobileAddDataBank', layout: 'application_mobile'
    else
      render 'accounts/databank/add'
    end
  end

  def editbank
    begin
      data_bank = Api::Account::BankController.editBank(api_url, session[:acc_token], params[:id])
      @data = JSON.parse(data_bank)['detail']
      if mobile_device?
        render 'mobile/accounts/dashboard/_profile/_edit/mobileEditDataBank', layout: 'application_mobile'
      else
        render 'accounts/databank/edit'
      end
    rescue Exception => e
      if params['debug'] == 'true'
        render json: JSON.pretty_generate(Api::HelperController::Error(e, request.original_url, session));
      else
        render '/errors/500', layout: 'application_errors'
      end
    end
  end

  # -- panel paket keagenan
  def paketagen
    begin
      data = Api::Account::PaketUmrahAgenController.rendering(api_url, session[:acc_token], params['page'], params['debug'])
      @data = data[:data]
      @page = data[:page]
      render 'accounts/paket/paketagen'
    rescue Exception => e
      if params['debug'] == 'true'
        render json: JSON.pretty_generate(Api::HelperController::Error(e, request.original_url, session));
      else
        render '/errors/500', layout: 'application_errors'
      end
    end
    # render json: @data
  end

  # -- panel syarat & ketentuan
  def syaratketentuan
    begin
      data = Api::Account::PaketUmrahAgenController.renderingDetail(params[:id_produk], params['kk'], session[:acc_token], params['bln'], params['th'])
      if data.nil?
        @data = ""
      else
        @data = data['umrah_detail']['sk']
      end
      render 'accounts/paket/syaratketentuan'
    rescue Exception => e
      if params['debug'] == 'true'
        render json: JSON.pretty_generate(Api::HelperController::Error(e, request.original_url, session));
      else
        render '/errors/500', layout: 'application_errors'
      end
    end
    # data = nil
    # render json: data
  end


  # -- panel controller transaksi umrah
  def pembayaranpacket
    begin
      @res = params['res']
      data = Api::Account::TransaksiController.logTransaksiPaket(api_url, session[:acc_token], '10', params['page'], params['filter'], 'umrah')
      @data = data[:data]
      @page = data[:page]

      if mobile_device?
        render 'mobile/transaction/umrah/mobileUmrahTransaction', layout: 'application_mobile'
      else
        render 'accounts/transaksi/pembayaranumrah'
      end

    rescue Exception => e
      if params['debug'] == 'true'
        render json: JSON.pretty_generate(Api::HelperController::Error(e, request.original_url, session));
      else
        render '/errors/500', layout: 'application_errors'
      end
    end
  end

  def pembayaran_paket_detail
    begin
      kode = params[:kode_transaksi]
      @data = Api::Account::TransaksiController.log_transaksi_paket_detail(api_url, session[:acc_token], kode)

      if mobile_device?
        render 'mobile/transaction/umrah/mobileUmrahTransactionDetail', layout: 'application_mobile'
      else
        render 'mobile/transaction/umrah/mobileUmrahTransactionDetail', layout: 'application_mobile' # belum ada view
      end

    rescue Exception => e
      if params['debug'] == 'true'
        render json: JSON.pretty_generate(Api::HelperController::Error(e, request.original_url, session));
      else
        render '/errors/500', layout: 'application_errors'
      end
    end
  end

  def transaksiumrah
    # begin
    @res = params['res']
    data = Api::Account::TransaksiController.logTransaksiPaket(api_url, session[:acc_token], '10', params['page'], params['filter'], 'umrah')
    @data = data[:data]
    @page = data[:page]
    # render json: @page
    if mobile_device?
      render 'mobile/transaction/umrah/mobileUmrahHistoryTransaction', layout: 'application_mobile'
    else
      render 'accounts/transaksi/umrah'
    end
    # rescue Exception => e
    #   Error.log(e, request.original_url)
    #   render "errors/500", layout: 'application_errors'
    # end
  end

  def transaksievoucher
    filter = params[:filter]
    begin
      data = PpobHelper.historyNew(session[:acc_token], filter)
      data = data['data']
      # render json: data and return
      # @data = []
      # data.each do |item|
      #   if item['kodeTipe'] != 'TIP006'
      #     @data << {'data' => item}
      #   end
      # end
      # render json: @data
      if mobile_device?
        render 'mobile/transaction/evoucher/mobileEvoucherTransaction', layout: 'application_mobile'
      else
        render 'accounts/transaksi/evoucher', locals: {data: data}
      end
    rescue Exception => e
      if params['debug'] == 'true'
        render json: JSON.pretty_generate(Api::HelperController::Error(e, request.original_url, session));
      else
        render '/errors/500', layout: 'application_errors'
      end
    end
  end


  # -- panel controller transaksi haji
  def transaksihaji
    if mobile_device?
      render 'mobile/transaction/haji/mobileHajiTransaction', layout: 'application_mobile'
    else
      render 'accounts/haji/transaksi'
    end
  end

  # -- panel controller transaksi Souvenir
  def transaksisouvenir
    render 'accounts/souvenir/transaksi'
  end

  def detailsouvenir
    render 'accounts/souvenir/detail'
  end


  # -- panel controller e-voucher
  def pulsa
    render 'accounts/evoucher/pulsa'
  end

  def paketdata
    render 'accounts/evoucher/paketdata'
  end

  def tokenlistrik
    render 'accounts/evoucher/tokenlistrik'
  end

  def vouchergame
    render 'accounts/evoucher/vouchergame'
  end

  def bpjskesehatan
    render 'accounts/evoucher/bpjs_kesehatan'
  end

  # -- panel controller detail pembelian evoucher
  def detailevoucher
    render 'accounts/evoucher/detail_evoucher'
  end

  # -- panel controller tagihan evoucher
  def tagihanevoucher
    render 'accounts/invoices/tagihan_evoucher'
  end

  # ari
  def detailevoucherPost
    begin
      params[:productCode] = params[:nominal]
      data = PpobPulsaHelper.available(params, session[:acc_token])
      # render json: data and return
      telepon = params[:msisdn]
      render 'accounts/evoucher/detail_evoucher_isi', locals: {data: data, telepon: telepon}
    rescue Exception => e
      if params['debug'] == 'true'
        render json: JSON.pretty_generate(Api::HelperController::Error(e, request.original_url, session));
      else
        render '/errors/500', layout: 'application_errors'
      end
    end
  end

  # -- panel controller notification
  def notification
    if mobile_device?
      render 'mobile/accounts/inbox/index', layout: 'application_mobile'
    else
      render 'accounts/notification/index'
    end
  end

  # -- panel controller pengaturan akun
  def editprofile
    begin
      @res = params[:res]
      user_detail = Api::Account::UserProfilController.user_detail(session[:acc_token])

      data_provinsi = Api::Account::LokasiController.renderProvinsi(api_url, session[:acc_token])
      data_detail_provinsi = Api::Account::LokasiController.renderProvinsiSl(session[:acc_token])

      data_kabkot = Api::Account::LokasiController.renderKabKot(session[:acc_token])
      data_kabkot_detail = Api::Account::LokasiController.renderKabKotSl(session[:acc_token])
      data_kabkot_provinsi = Api::Account::LokasiController.renderKabKotSl(session[:acc_token])

      data_kecamatan_detail = Api::Account::LokasiController.renderKecSl(session[:acc_token])

      @user_detail = JSON.parse(user_detail)

      @provinsi = data_provinsi
      @provinsi_detail = data_detail_provinsi

      # @kabkot = JSON.parse(data_kabkot)
      @kabkot_detail = data_kabkot_detail
      # @kabkot_provinsi = JSON.parse(data_kabkot_provinsi)

      @kecamatan_detail = data_kecamatan_detail

      if mobile_device?
        render 'mobile/accounts/dashboard/_profile/_edit/mobileEditProfileUsers', layout: 'application_mobile'
      else
        render 'accounts/pengaturan/editprofile'
      end
    rescue Exception => e
      if params['debug'] == 'true'
        render json: JSON.pretty_generate(Api::HelperController::Error(e, request.original_url, session));
      else
        render '/errors/500', layout: 'application_errors'
      end
    end
    # render json: @provinsi_detail
  end

  def edit_profile_type
    begin
      @res = params[:res]
      type = params[:type]
      user_detail = Api::Account::UserProfilController.user_detail(session[:acc_token])

      data_provinsi = Api::Account::LokasiController.renderProvinsi(api_url, session[:acc_token])
      data_detail_provinsi = Api::Account::LokasiController.renderProvinsiSl(session[:acc_token])
      data_kabkot_detail = Api::Account::LokasiController.renderKabKotSl(session[:acc_token])
      data_kecamatan_detail = Api::Account::LokasiController.renderKecSl(session[:acc_token])

      @user_detail = JSON.parse(user_detail)
      @provinsi = data_provinsi
      @provinsi_detail = data_detail_provinsi
      @kabkot_detail = data_kabkot_detail
      @kecamatan_detail = data_kecamatan_detail
      # render json: @user_detail and return
      if mobile_device?
        if type == "data-pribadi"
          render 'mobile/accounts/dashboard/_profile/_edit/mobileFormDataPribadi', layout: 'application_mobile'
        elsif type == "data-alamat"
          render 'mobile/accounts/dashboard/_profile/_edit/mobileFormAlamat', layout: 'application_mobile'
        elsif type == "nomor-telepon"
          render 'mobile/accounts/dashboard/_profile/_edit/mobileFormTelepon', layout: 'application_mobile'
        elsif type == "akun-email"
          render 'mobile/accounts/dashboard/_profile/_edit/mobileFormEmail', layout: 'application_mobile'
        else
          render 'mobile/accounts/dashboard/_profile/_edit/mobileEditProfileUsers', layout: 'application_mobile'
        end
      end
    rescue Exception => e
      if params['debug'] == 'true'
        render json: JSON.pretty_generate(Api::HelperController::Error(e, request.original_url, session));
      else
        render '/errors/500', layout: 'application_errors'
      end
    end
  end

  # -- panel controller invoices
  def invoices
    render 'accounts/invoices/evoucher'
  end

  def ubahpassword
    @res = params[:res]
    if mobile_device?
      render 'mobile/accounts/dashboard/_profile/_edit/mobileFormPassword', layout: 'application_mobile'
    else
      render 'accounts/pengaturan/ubahpass'
    end
  end

  def otpubahpassword
    if mobile_device?
      render 'mobile/accounts/dashboard/_profile/_edit/mobileFormOTP', layout: 'application_mobile'
    else
      render 'accounts/pengaturan/otpubahpass'
    end
  end

  # -- panel controller transaksi tiket pesawat
  def pembeliantiket
    # begin
    @res = params['res']
    # @dataPassenger = Api::Account::TiketPesawatController.eTiket(session[:acc_token], params[:kode])
    @data = Api::Account::TiketPesawatController.historyTiket(session[:acc_token], session[:tiket], params[:filter])

    # render json: @data
    if params['abutest'] == 'true'
      render json: {:data => @data}
    else
      render 'accounts/transaksi/ticketpesawat'
    end
    # rescue Exception => e
    #   Error.log(e, request.original_url)
    #   render "errors/500", layout: 'application_errors'
    # end
  end

  def searchticketwo
    render 'accounts/evoucher/tiket-pesawat/ticketwo'
  end

  def mutasideposit
    @data = Api::Account::SaldoController.mutasiDeposit(session[:acc_token])
    render 'accounts/transaksi/mutasideposit'
  end

  # contorller refund
  def TermsConditions
    render 'accounts/refund/conditions_refund'
  end

  def FormulirRefund
    @res = params['res']
    if params['develope'] == 'on'
      @data = Api::Account::JamaahController.ebookJamaahDetail(api_url, session[:acc_token], params['no_trans'])['data']
      render json: @data
    else
      @data = Api::Account::JamaahController.ebookJamaahDetail(api_url, session[:acc_token], params['no_trans'])['data']
      @data_bank = Api::Account::BankController.rendering(api_url, session[:acc_token], '')['json']['data']
      render 'accounts/refund/formulir_refund'
    end
  end

  def OtpRefund
    @res = params['res']
    if cookies[:XCOR].to_i > 3
      message = {
          'otp_notification' => 'Kode OTP tidak dapat dikirim secara otomatis. Silahkan Anda klik link \'Kirim ulang kode\' '
      }
      @message = JSON.parse(JSON[message])
    end
    render 'accounts/refund/otp_refund'
  end

  def ResendOtpRefund
    begin
      no_cookies_refund = !cookies[:XCROR].nil? ? cookies[:XCROR] : 0
      cookies_refund = cookies[:XCROR] = cookies[:XCROR].to_i + 1

      res = RestClient.post api_url + '/refund/resend_otp', {

      }, {
                                'Authorization' => "Bearer #{session[:acc_token]}",
                                'x-no-trans-refund' => params['no_trans_refund'],
                                'x-otp-via' => 'sms'
                            }
      message = {
          'otp_notification' => 'Kode OTP berhasil dikirim ke nomor telepon Anda'
      }
      @message = JSON.parse(JSON[message])

      render 'accounts/refund/otp_refund'
    rescue RestClient::ExceptionWithResponse => e
      redirect_to "/verifikasi-otp-refund/#{params[:no_trans]}?res=fails", :flash => {:message => JSON.parse(e.response)['message'], :status => true}
    end
  end

  def InvoiceRefund
    @data = Api::Account::RefundController.detailRefund(api_url, params, session[:acc_token])['data']
    render 'accounts/refund/invoice_refund'
  end

  # controller transaksi refund
  def TransaksiRefund
    render 'accounts/transaksi/refund/index'
  end

  # controller pengajuan penambahan biaya
  def pengajuan
    @res = params[:res]
    @data_maklumat_penambahan_biaya = Api::Account::MaklumatController.maklumatDaftarPengajuan(session[:acc_token])['data']
    # render json: @data_maklumat_penambahan_biaya
    if mobile_device?
      render 'mobile/accounts/additionalcosts/pengajuan/index', layout: 'application_mobile'
    else
      render 'accounts/additional_costs/pengajuan/index'
    end
  end
  # def detailpengajuan
  #   render 'accounts/additional_costs/pengajuan/detailpengajuan'
  # end

  # controller daftar pengajuan penambahan biaya
  def daftarpenambahanbiaya
    @data_maklumat_penambahan_biaya = Api::Account::MaklumatController.maklumatDaftarPengajuan(session[:acc_token])['data']
    @data_maklumat_penambahan_biaya_detail = []
    @data_maklumat_penambahan_biaya.each do |item|
      @data_maklumat_penambahan_biaya_detail << data_maklumat_penambahan_biaya_detail = Api::Account::MaklumatController.maklumatDaftarPengajuanDetail(session[:acc_token], item['no_request'])['data']
    end    

    if mobile_device?
      render 'mobile/accounts/additionalcosts/daftarpengajuan/index', layout: 'application_mobile'
    else
      render 'accounts/additional_costs/daftarpengajuan/index'
    end

  end

  def pilihpenambahanbiaya
    @maklumat_check = Api::Account::MaklumatController.maklumatCheck(params[:token])
    render 'accounts/additional_costs/daftarpengajuan/select_costs'
  end

  def penambahanbiaya
    transaksi = Api::Account::MaklumatController.new
    data_transaksi = transaksi.maklumatTransaksi(api_url, session[:acc_token], params[:token])
    @data = Api::Account::MaklumatController.maklumatTransaksiDetail(session[:acc_token], data_transaksi['data']['no_trans'])
    # render json: @data
    render 'accounts/additional_costs/daftarpengajuan/invoice_tambahan'
  end

  # controller history penambahan biaya
  def historypenambahanbiaya
    @data = Api::Account::MaklumatController.maklumatRiwayatTransaksi(session[:acc_token])
    # render json: @data
    render 'accounts/additional_costs/historypenambahanbiaya/index'
  end
end

