class UmrahController < ApplicationController
  include VariableHelper
  require 'helper/strg'
  require 'uri'

  def packet
    begin
      kota = params[:kota].gsub(',', ';') if params[:kota]
      puts "kota: #{kota}"
      url = request.url
      uri = URI(url)
      # uri = ''
      if uri.query
        uri_query = "&"+uri.query.sub("page=#{params[:page]}", '')
        uri = uri_query.sub("&&", "&").sub("&&&", "&") if uri_query
      else
        uri = ''
      end

      return_data = Api::Account::PaketUmrahController.pencarianPaket(
          api_url,
          session[:acc_token],
          params[:tahun],
          params[:bulan],
          '12',
          params[:page],
          kota, params[:paket], params['order'], nil, {:url => uri}
      )
      @data = return_data["data"]
      @page = return_data["page"]
      return_data = Api::Account::PaketUmrahController.rendering(api_url, session[:acc_token], params['page'], '8', params['debug'])
      @paket = return_data["data"]

      pra_cari = Api::Account::PaketUmrahController.pre_search(api_url, session[:acc_token], '', '', '', '')
      @data_pre_search = pra_cari['data'] if pra_cari && pra_cari['status']
      if mobile_device?
        render 'mobile/sites/pages/umrah/mListSearch', layout: 'application_mobile'
      else
        render 'umrah/packet'
      end

    rescue => e
      puts e + "\n " + e.backtrace.join("\n ")
      Error.log(e, request.original_url)
      render "errors/500", layout: 'application_errors'
    end
    # render json: @data
  end

  def detailpacket
    begin
      @data = Api::Account::PaketUmrahController.renderingDetail(api_url, params[:kode], params['kk'], session[:acc_token], params['bln'], params['th'])
      # render json: @data
      if mobile_device?
        render '/mobile/sites/pages/umrah/mDetailPacket', layout: 'application_mobile'
      else
        render 'umrah/detailpacket'
      end
    rescue Exception => e
      if params['debug'] == 'true'
        render json: JSON.pretty_generate(Api::HelperController::Error(e, request.original_url, session));
      else
        render '/errors/500', layout: 'application_errors'
      end
    end
  end
end