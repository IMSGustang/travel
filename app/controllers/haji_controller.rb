class HajiController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :Authentication, except: [:pakethaji, :detail]
  def pakethaji
    begin
      header = {
          "Authorization" => "Bearer #{session[:acc_token]}",
          "x-kode-kantor" => params['kota'],
          "x-jenis-paket" => params['paket'],
          "x-tahun" => params['tahun'],
          "x-bulan" => "",
          "x-per-page" => 8,
          "x-page" => params[:page],
          "x-order-by" => "",
          "x-order-dir" => ""
      }
      data = JSON.parse(RestClient.post VariableHelper.api_url + "produk/haji", {}, header)
      # render json: data and return

      @page_html = Paginator::renderCustom(data, "&kota=#{params['kota']}&paket=#{params['paket']}&tahun=#{params['tahun']}")

      page = {
        :link_prev => "<a class='page-link btn btn-success' href='?page=#{@page_html[:link_prev]}&kota=#{params['kota']}&paket=#{params['paket']}&tahun=#{params['tahun']}'>Prev</a>",
        :link_next => "<a class='page-link btn btn-success' href='?page=#{@page_html[:link_next]}&kota=#{params['kota']}&paket=#{params['paket']}&tahun=#{params['tahun']}'>Next</a>",
        :html => @page_html[:page]
      }

      @page = JSON.parse(page.to_json)
      if mobile_device?
        render 'mobile/sites/pages/haji/mListSearch', layout: 'application_mobile', locals: {data: data}
      else
        render 'haji/index', locals: {data: data}
      end
      
    rescue RestClient::ExceptionWithResponse => e
      # Error Handler
      data = e.response
      render 'haji/index', locals: {data: data}
    end
  end

  def detail
    begin
      kode_kantor = params[:kode_kantor]
      bulan = params[:bulan]
      tahun = params[:tahun]
      header = {
          "Authorization" => "Bearer #{session[:acc_token]}",
          "x-kode-kantor" => kode_kantor,
          "x-bulan" => bulan,
          "x-tahun" => tahun,
      }
      data = JSON.parse(RestClient.get VariableHelper.api_url + "produk/haji/#{params[:kode_produk]}", header)
      # render json: data and return

      if mobile_device?
        render 'mobile/sites/pages/haji/mDetailsPacket', locals: {data: data, bulan: bulan, tahun: tahun, kode_kantor: kode_kantor}, layout: 'application_mobile'
      else
        render 'haji/detail', locals: {data: data, bulan: bulan, tahun: tahun, kode_kantor: kode_kantor}
      end

    rescue RestClient::ExceptionWithResponse => e
      if params['debug'] == 'true'
        render json: JSON.pretty_generate(Api::HelperController::Error(e, request.original_url, session));
      else
        render '/errors/500', layout: 'application_errors'
      end
    end
  end

  #-- panel controller Haji -->
  def transaksihaji
    begin
      @res = params['res']
      data = Api::Account::TransaksiController.logTransaksiPaket(api_url, session[:acc_token], '10', params['page'], params['filter'],'haji')
      @data = data[:data]
      @page = data[:page]

      if mobile_device?
        render 'mobile/transaction/haji/mobileHajiTransaction', layout: 'application_mobile'
      else
        render 'accounts/transaksi/haji/transaksi'
      end

    rescue Exception => e
      if params['debug'] == 'true'
        render json: JSON.pretty_generate(Api::HelperController::Error(e, request.original_url, session));
      else
        render '/errors/500', layout: 'application_errors'
      end
    end
  end

  def historytransaksihaji
    begin
      @res = params['res']
      data = Api::Account::TransaksiController.logTransaksiPaket(api_url, session[:acc_token], '10', params['page'], params['filter'], 'haji')
      @data = data[:data]
      @page = data[:page]

      render 'accounts/transaksi/haji/history'
    rescue Exception => e
      if params['debug'] == 'true'
        render json: JSON.pretty_generate(Api::HelperController::Error(e, request.original_url, session));
      else
        render '/errors/500', layout: 'application_errors'
      end
    end
  end
  # paket haji untuk agen / mitra
  def account_index
    begin
      header = {
          "Authorization" => "Bearer #{session[:acc_token]}",
          "x-kode-kantor" => "",
          "x-jenis-paket" => "",
          "x-tahun" => "",
          "x-bulan" => "",
          "x-per-page" => 8,
          "x-page" => params[:page],
          "x-order-by" => "",
          "x-order-dir" => ""
      }
      data = JSON.parse(RestClient.post VariableHelper.api_url + "produk/haji", {}, header)

      @page_html = Paginator::render(data)

      page = {
          :link_prev => "<a class='page-link btn btn-success' href='?page=#{@page_html[:link_prev]}'>Prev</a>",
          :link_next => "<a class='page-link btn btn-success' href='?page=#{@page_html[:link_next]}'>Next</a>",
          :html => @page_html[:page]
      }

      # render json: page and return
      @page = JSON.parse(page.to_json)
      render 'accounts/haji/index', locals: {data: data}
    rescue RestClient::ExceptionWithResponse => e
      data = e.response
      render 'accounts/haji/index', locals: {data: data}
    end
  end

  def account_detail
    begin
      kode_kantor = params[:kode_kantor]
      bulan = params[:bulan]
      tahun = params[:tahun]
      header = {
          "Authorization" => "Bearer #{session[:acc_token]}",
          "x-kode-kantor" => kode_kantor,
          "x-bulan" => bulan,
          "x-tahun" => tahun,
      }
      data = JSON.parse(RestClient.get VariableHelper.api_url + "produk/haji/#{params[:kode_produk]}", header)
      # render json: data and return
      # render json: data and return
      render 'accounts/haji/detail', locals: {data: data, bulan: bulan, tahun: tahun, kode_kantor: kode_kantor}
    rescue RestClient::ExceptionWithResponse => e
      if params['debug'] == 'true'
        render json: JSON.pretty_generate(Api::HelperController::Error(e, request.original_url, session));
      else
        render '/errors/500', layout: 'application_errors'
      end
    end

    # render 'accounts/naurah/detailnaurah'
  end
end
