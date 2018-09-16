class PpobPlnController < ApplicationController
  skip_before_action :verify_authenticity_token
  include ApplicationHelper
  require 'helper/time'
  require 'helper/number'
  require 'helper/strg'

  def index
    # render json: PpobHelper.api_url and return
    render 'accounts/evoucher/pln/index'
  end

  def inquiry
    token = session[:acc_token]
    id = params[:id]
    res = JSON.parse(RestClient.get PpobHelper.api_url + "pulsa/inquiry/" + id, {Authorization: "Bearer #{token}"})
    # jason = '
    # [
    # {
    #     "product_id": "P118325",
    #     "voucher": "XL",
    #     "nominal": "5.000",
    #     "price": "5750"
    # },
    # {
    #     "product_id": "P790972",
    #     "voucher": "XL",
    #     "nominal": "10.000",
    #     "price": "10800"
    # },
    # {
    #     "product_id": "P790972",
    #     "voucher": "XL BB",
    #     "nominal": "20.000 BB Gaul Unlimited + Pulsa 7hr",
    #     "price": "20725"
    # },
    # {
    #     "product_id": "P790972",
    #     "voucher": "XL BB",
    #     "nominal": "25.000 BB Full Bis Lite 7 Hari",
    #     "price": "25725"
    # },
    # {
    #     "product_id": "P790972",
    #     "voucher": "XL BB",
    #     "nominal": "30.000 BB Full Bis Lite Unli 7hr",
    #     "price": "30725"
    # },
    # {
    #     "product_id": "P790972",
    #     "voucher": "XL BB",
    #     "nominal": "50.000 BB XmartPlan Gaul 50mnt + 50SMS, 30hr",
    #     "price": "45725"
    # }
    # ]'
    render json: res and return
  end

  def inquiryPrepaid
    token = session[:acc_token]
    id = params[:id]
    dataBody = {

    }
    dataHeader = {
        "Authorization" => "Bearer #{token}",
        "x-id-pelanggan" => id
    }
    # render json: dataHeader and return
    begin
      res = JSON.parse(RestClient.post PpobHelper.api_url + "pln-prepaid/inquiry-headers", dataBody, dataHeader)
      render json: res and return
    rescue RestClient::ExceptionWithResponse => e
      render json: e.response and return
    end
  end

  def detail
    token = session[:acc_token]
    nominal = params[:nominal]
    idPelanggan = params[:id_pelanggan]
    dataPost = {
        idPelanggan: params[:id_pelanggan]
    }
    data = JSON.parse(RestClient.post PpobHelper.api_url + "pln-prepaid/inquiry", dataPost, {Authorization: "Bearer #{token}"})

    if mobile_device?
      render 'mobile/sites/pages/tokenlistrik/detail', locals: {data: data, idPelanggan: idPelanggan, nominal: nominal}, layout: 'application_mobile'
    else
      render 'accounts/evoucher/pln/detail', locals: {data: data, idPelanggan: idPelanggan, nominal: nominal}
    end
  end

  def beli
    token = session['acc_token']
    dataHeader = {
        "Authorization" => "Bearer #{token}",
        "x-id-pelanggan" => params[:id_pelanggan],
        "x-ref-id" => params[:ref_id],
        "x-nominal" => params[:nominal]
    }
    dataPost = {

    }
    res = JSON.parse(RestClient.post PpobHelper.api_url + "pln-prepaid/beli-headers", dataPost, dataHeader)
    if res['status'] == 200
      kodeTransaksi = res['data']['kode_transaksi']
      redirect_to '/evoucher/beli/' + kodeTransaksi
    else
      render json: 'gagal'
    end
  end

  def invoice
    render 'accounts/evoucher/pay-invoice', layout: 'application' and return
  end

  def history
    render 'accounts/transaksi/evoucher'
  end
end
