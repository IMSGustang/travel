class UiController < ApplicationController
  def umrah
    begin
      @res = RestClient.get api_url + "/produk/umrah/kota_populer",{
          'Authorization' => "Bearer #{session[:acc_token]}"
      }
      data = JSON.parse(@res)['data']

      pra_cari = Api::Account::PaketUmrahController.pre_search(api_url, session[:acc_token], '', '', '', '')
      @data_pre_search = pra_cari['data'] if pra_cari && pra_cari['status']

      return_data = Api::Account::PaketUmrahController.rendering(api_url, session[:acc_token], params['page'], '8', params['debug'])
      @paket = return_data["data"]

      slider = JSON.parse(RestClient.get api_url + "slider2", {
          'Accept' => 'application/json',
          'x-kategori' => 'umrah'
      })
      @data_slider = slider['data']

      if mobile_device?
        render 'mobile/sites/pages/umrah/mSearch', locals: {data: data}, layout: 'application_mobile'
      else
        render 'UI/umrah/index', locals: {data: data}
      end
    rescue RestClient::ExceptionWithResponse => err
      @err = JSON.parse(err.response)
      return @err
    end
  end

  def flight
    begin
      # tiket pesawat
      @bandara = Api::Account::TiketPesawatController.bandara(session[:acc_token], session[:tiket])
      @bandara_terdekat = @bandara #Api::Account::TiketPesawatController.bandara(session[:acc_token], session[:tiket])
      @bandara_terdekatApi = Api::Account::TiketPesawatController.bandaraTerdekat(session[:acc_token], session[:tiket])
      @bandara_terdekat.unshift(@bandara_terdekatApi[0])

      slider = JSON.parse(RestClient.get api_url + "slider2", {
          'Accept' => 'application/json',
          'x-kategori' => 'tiket'
      })
      @data_slider = slider['data']


      if mobile_device?
        render 'mobile/sites/pages/tiketpesawat/mTiketpesawat', layout: 'application_mobile'
      else
        render 'UI/tiketpesawat/index'
      end

      
    rescue => e
      # Error.log(e, request.original_url)
      logger.error e.message
      logger.error e.backtrace.join("\n")
      redirect_to '/error/500'
    end
  end

  def haji
    begin
      @search = Api::Account::PaketHajiController.searchSuggestionPaketHaji(session[:acc_token])
      slider = JSON.parse(RestClient.get api_url + "slider2", {
          'Accept' => 'application/json',
          'x-kategori' => 'umrah'
      })
      @data_slider = slider['data']

      # Haji
      @paket_haji_list = Api::Account::PaketHajiController.rendering(api_url, session[:acc_token], '', '4', params['debug'])['data']
      if mobile_device?
        render 'mobile/sites/pages/haji/mSearch', layout: 'application_mobile'
      else
        render 'UI/haji/index'
      end
    rescue RestClient::ExceptionWithResponse => e
      puts e.response
    end
  end

  def belipulsa
    slider = JSON.parse(RestClient.get api_url + "slider2", {
        'Accept' => 'application/json',
        'x-kategori' => 'pulsa'
    })
    @data_slider = slider['data']
    if mobile_device?
      render 'mobile/sites/pages/pulsa/mPulsa', layout: 'application_mobile'
    else
      render 'UI/evoucher/pulsa'
    end
  end

  def belipaketdata
    slider = JSON.parse(RestClient.get api_url + "slider2", {
        'Accept' => 'application/json',
        'x-kategori' => 'data'
    })
    @data_slider = slider['data']
    if mobile_device?
      render 'mobile/sites/pages/paketdata/mPaketdata', layout: 'application_mobile'
    else
      render 'UI/evoucher/paketdata'
    end
  end

  def belitokenlistrik
    slider = JSON.parse(RestClient.get api_url + "slider2", {
        'Accept' => 'application/json',
        'x-kategori' => 'listrik'
    })
    @data_slider = slider['data']
    if mobile_device?
      render 'mobile/sites/pages/tokenlistrik/mTokenlistrik', layout: 'application_mobile'
    else
      render 'UI/evoucher/tokenlistrik'
    end
    
  end

  def belivouchergames
    begin
      token = session['acc_token']
      id = params[:id]
      data = JSON.parse(RestClient.get PpobHelper.api_url + "game/inquiry-game", {Authorization: "Bearer #{token}"})

      slider = JSON.parse(RestClient.get api_url + "slider2", {
          'Accept' => 'application/json',
          'x-kategori' => 'game'
      })
      @data_slider = slider['data']

      if mobile_device?
        render 'mobile/sites/pages/vouchergame/mVouchergame', layout: 'application_mobile', locals: { data: data}
      else
        render 'UI/evoucher/games', locals: { data: data}
      end
    rescue Exception => e
      Error.log(e, request.original_url)
      render "errors/500", layout: 'application_errors'
    end
  end

end
