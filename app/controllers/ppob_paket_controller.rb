class PpobPaketController < ApplicationController
  skip_before_action :verify_authenticity_token
  include ApplicationHelper
  require 'helper/time'
  require 'helper/number'
  require 'helper/strg'

  def index
    # render json: PpobHelper.api_url and return
    render 'accounts/evoucher/paket-data/inquiry'
  end

  def inquiryOld
    begin
      token = session[:acc_token]
      id = params[:id]
      begin
        res = JSON.parse(RestClient.get PpobHelper.api_url + "data/inquiry/" + id, {Authorization: "Bearer #{token}"})
        render json: res and return
      rescue RestClient::ExceptionWithResponse => e
        # puts e.response + "\n " + e.backtrace.join("\n ")
        render json: e.response and return
      end
    rescue Exception => e
      Error.log(e, request.original_url)
      render "errors/500", layout: 'application_errors'
    end
  end

  def inquiry
    begin
      token = session[:acc_token]
      id = params[:id]
      begin
        data = RestClient.get PpobHelper.api_url + "data/inquiry-new/" + id, {Authorization: "Bearer #{token}"}
        res = JSON.parse(data)
        render json: res['data'] and return
      rescue RestClient::ExceptionWithResponse => e
        # puts e.response + "\n " + e.backtrace.join("\n ")
        res = JSON.parse(e.response)
        render json: res, status: res['status'] and return
      end
    rescue Exception => e
      Error.log(e, request.original_url)
      render "errors/500", layout: 'application_errors'      
    end
  end

  def inquiryNews
    token = session[:acc_token]
    id = params[:id]
    begin
      res = JSON.parse(RestClient.get PpobHelper.api_url + "data/inquiry-new/" + id, {Authorization: "Bearer #{token}"})
      render json: res and return
    rescue RestClient::ExceptionWithResponse => e
      render json: e.response and return
    end
  end

  def detail
    begin
      params[:productCode] = params[:nominal]
      token = session[:acc_token]
      data = PpobPulsaHelper.available(params, session[:acc_token])
      data = JSON.parse(RestClient.get PpobHelper.api_url + "pulsa/available-new/" + params[:productCode], {Authorization: "Bearer #{token}"})['data']
      telepon = params[:msisdn]

      if mobile_device?
        render 'mobile/sites/pages/paketdata/detail', locals: {data: data, telepon: telepon}, layout: 'application_mobile'
      else
        render 'accounts/evoucher/paket-data/detail', locals: {data: data, telepon: telepon}
      end

    rescue Exception => e
      Error.log(e, request.original_url)
      render "errors/500", layout: 'application_errors'
    end
  end

  def beli
    begin
      # render 'accounts/evoucher/pulsa/metode', layout: 'application_payments' and return
      token = session['acc_token']
      data = {
          telepon: params[:msisdn],
          kodeProduk: params[:product]
      }
      res = JSON.parse(RestClient.post PpobHelper.api_url + "data/beli", data, {Authorization: "Bearer #{token}"})
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
