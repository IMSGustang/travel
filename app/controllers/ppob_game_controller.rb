class PpobGameController < ApplicationController
  skip_before_action :verify_authenticity_token
  include ApplicationHelper
  require 'helper/time'
  require 'helper/number'
  require 'helper/strg'

  def index
    begin
      token = session['acc_token']
      id = params[:id]
      data = JSON.parse(RestClient.get PpobHelper.api_url + "game/inquiry-game", {Authorization: "Bearer #{token}"})
      render 'accounts/evoucher/game/index', locals: { data: data}
    rescue Exception => e
      Error.log(e, request.original_url)
      render "errors/500", layout: 'application_errors'
    end
  end

  def inquiry
    begin
      token = session['acc_token']
      id = params[:id]
      res = JSON.parse(RestClient.get PpobHelper.api_url + "game/inquiry-nominal/" + id, {Authorization: "Bearer #{token}"})
      jason = '
      [
      {
          "product_id": "P118325",
          "voucher": "XL",
          "nominal": "5.000",
          "price": "5750"
      },
      {
          "product_id": "P790972",
          "voucher": "XL",
          "nominal": "10.000",
          "price": "10800"
      }]'
      render json: res and return
    rescue Exception => e
      Error.log(e, request.original_url)
      render "errors/500", layout: 'application_errors'
    end
  end

  def inquiryNew
    begin
      token = session['acc_token']
      id = params[:id]
      res = JSON.parse(RestClient.get PpobHelper.api_url + "game/inquiry-nominal-new/" + id, {Authorization: "Bearer #{token}"})
      render json: res and return
    rescue Exception => e
      Error.log(e, request.original_url)
      render json: e.response and return
    end
  end

  def detail
    begin
      params[:productCode] = params[:nominal]
      token = session[:acc_token]
      data = JSON.parse(RestClient.get PpobHelper.api_url + "game/detail-game/" + params[:productCode], {Authorization: "Bearer #{token}"})

      if mobile_device?
        render 'mobile/sites/pages/vouchergame/detail', locals: {data: data}, layout: 'application_mobile'
      else
        render 'accounts/evoucher/game/detail', locals: {data: data}
      end

    rescue Exception => e
      Error.log(e, request.original_url)
      render "errors/500", layout: 'application_errors'
    end
  end

  def beli
    begin
      token = session['acc_token']
      data = {
          kodeProduk: params[:product]
      }
      res = JSON.parse(RestClient.post PpobHelper.api_url + "game/beli", data, {Authorization: "Bearer #{token}"})
      if res['status'] == 200
        kodeTransaksi = res['data']['kode_transaksi']
        redirect_to '/evoucher/beli/' + kodeTransaksi
      else
        render json: 'gagal'
      end
    rescue Exception => e
      Error.log(e, request.original_url)
      render "errors/500", layout: 'application_errors'
    end
  end

  def history
    render 'accounts/transaksi/evoucher'
  end
end
