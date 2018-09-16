class LandingController < ApplicationController
  require 'helper/time'
  require 'helper/error'

  def home
    begin
      return_data = Api::Account::PaketUmrahController.rendering(api_url, session[:acc_token], params['page'], '8', params['debug'])
      # cabang = Api::Account::LokasiController.CabangKotaAbutours()
      # @cabang = cabang['data']
      @paket = return_data["data"]

      return_data_all = Api::Account::PaketUmrahController.rendering(api_url, session[:acc_token], params['page'], '200', params['debug'])
      @paket_all = return_data_all["data"]
      pra_cari = Api::Account::PaketUmrahController.pre_search(api_url, session[:acc_token], '', '', '', '')
      @data_pre_search = pra_cari['data'] if pra_cari && pra_cari['status']
      @paket_haji = Api::Account::PaketHajiController.searchSuggestionPaketHaji(session[:acc_token])
      @paket_haji_list = Api::Account::PaketHajiController.rendering(api_url, session[:acc_token], '', '4', params['debug'])['data']
      # render json: @paket_haji_list and return
      # tiket pesawat
      @bandara = Api::Account::TiketPesawatController.bandara(session[:acc_token], session[:tiket])
      @bandara_terdekat = @bandara #Api::Account::TiketPesawatController.bandara(session[:acc_token], session[:tiket])

      @bandara_terdekatApi = Api::Account::TiketPesawatController.bandaraTerdekat(session[:acc_token], session[:tiket])
      # puts @bandara_terdekatApi
      # @bandara_terdekat.unshift(@bandara_terdekatApi[0])

      @provider = JSON.parse(RestClient.get PpobHelper.api_url + "game/inquiry-game", {Authorization: "Bearer #{session[:acc_token]}"})

      data = Api::Account::NotifikasiController.render_notifikasi(api_url, session[:acc_token], params[:page], 10)
      @informasi = data[:data]
      @notifikasi = data[:notifikasi]

      slider = JSON.parse(RestClient.get api_url + "slider2", {
          'Accept' => 'application/json',
          'x-kategori' => 'promo'
      })
      @data_slider = slider['data']


      # Paket
      get_paket_populer = Api::Account::PaketUmrahController.new
      @paket_populer = get_paket_populer.paketPopular(session, jumlah_kota = '5', jumlah_page = '8', 'with_paket')

      # render json: @bandara_terdekatApi

      if mobile_device?
        render 'mobile/sites/pages/mobileHome', layout: 'application_mobile'
      else
        render 'landing/home'
      end


    rescue => e
      if params['debug'] == 'true'
        render json: JSON.pretty_generate(Api::HelperController::Error(e, request.original_url, session));
      else
        render '/errors/500', layout: 'application_errors'
      end
    end
  end

  def tentang
    begin
      about = JSON.parse(RestClient.get api_url + "artikel/about_us", {Accept: 'application/json'})
      @about_us = about['data']
    rescue RestClient::ExceptionWithResponse => err
      @about_us = nil
    end

    if mobile_device?
      render 'mobile/sites/pages/about/index', layout: 'application_mobile'
    else
      render 'landing/tentang'
    end
  end

  def layananumrah
    render 'landing/layanan_umrah'
  end

  def partnership
    render 'landing/partnership'
  end

  def formpartnership
    render 'landing/form_partnership'
  end

  def blog
    begin
      @res = params['res']
      dat = Api::Artikel::BlogController.listBlog(api_url, session[:acc_token], '10', params['page'])
      dat_side = Api::Artikel::BlogController.listBlog(api_url, session[:acc_token], '5', params['page'])
      data_kategori = Api::Artikel::BlogController.kategoriBlog(api_url, session[:acc_token])['data']
      data = dat[:data]
      page = dat[:page]
      side = dat_side[:data]
      @page = JSON.parse(page.to_json)
      if mobile_device?
        render 'mobile/sites/pages/blog/index', locals: {data: data, data_side: side, page: page, data_kategori: data_kategori}, layout: 'application_mobile'
      else
        render 'landing/blog', locals: {data: data, data_side: side, page: page, data_kategori: data_kategori}
      end
    rescue Exception => e
      if params['debug'] == 'true'
        render json: JSON.pretty_generate(Api::HelperController::Error(e, request.original_url, session));
      else
        render '/errors/500', layout: 'application_errors'
      end
    end
  end

  def blogdetil
    begin
      @res = params['res']
      data = Api::Artikel::BlogController.detailBlog(api_url, session[:acc_token], '10', params['page'], params[:id])['data']
      data_kategori = Api::Artikel::BlogController.kategoriBlog(api_url, session[:acc_token])['data']

      if mobile_device?
        render 'mobile/sites/pages/blog/detailBlog', locals: {data: data, data_kategori: data_kategori}, layout: 'application_mobile'
      else
        render 'landing/blog-detail', locals: {data: data, data_kategori: data_kategori}
      end

    rescue Exception => e
      Error.log(e, request.original_url)
      render "errors/500", layout: 'application_errors'
    end
  end

  def faq
    require 'restclient'
    url = api_url + 'artikel/bantuan'
    begin
      res = RestClient.get url, {'Accept' => 'application/json'}
      data = JSON.parse(res)
      if data['status'] == 200
        @data_faq = data['data']
        if mobile_device?
          render 'mobile/sites/pages/helps/index', layout: 'application_mobile'
        else
          render 'landing/faq'
        end
      else
        redirect_to '/error/404'
      end
    rescue RestClient::ExceptionWithResponse => err
      Rails.logger.info(err)
      redirect_to '/error/404'
    end
  end

  def toko_agen
    require 'restclient'
    url = api_url + 'users/toko/' + params[:nama_toko]
    url2 = url + '/paket'
    begin
      res = RestClient.get url, {'Accept' => 'application/json', 'x-client-id' => clientId}
      data = JSON.parse(res)
      if data['status'] == 200
        @data_toko = data['data']
        @data_user = data['user']

        res2 = RestClient.get url2, {
            'Accept' => 'application/json',
            'x-per-page' => 4,
            'x-page' => params[:page],
            'x-client-id' => clientId
        }
        data2 = JSON.parse(res2)
        if data2['status'] == 200
          page_html = Paginator::render(data2)
          @data_paket = data2['data']
          @data_page = {
              :link_prev => "<a class='page-link btn btn-success' href='?page=#{page_html[:link_prev]}'>Prev</a>",
              :link_next => "<a class='page-link btn btn-success' href='?page=#{page_html[:link_next]}'>Next</a>",
              :html => page_html[:page]
          }
        end

        render 'tokoagen/index.html'
      else
        redirect_to '/error/404'
      end
    rescue RestClient::ExceptionWithResponse => err
      Rails.logger.info(err)
      redirect_to '/error/404'
    end
  end
end