class PpobPulsaController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :Authentication, except: [:inquiryNews]
  include ApplicationHelper
  require 'helper/time'
  require 'helper/number'
  require 'helper/strg'

  def index
    # render json: PpobHelper.api_url and return
    render 'accounts/evoucher/pulsa/inquiry'
  end

  def inquiry
    token = session[:acc_token]
    id = params[:id]
    begin
      res = JSON.parse(RestClient.get PpobHelper.api_url + "pulsa/inquiry-new/" + id, {Authorization: "Bearer #{token}"})
      render json: res['data'] and return
    rescue RestClient::ExceptionWithResponse => e
      res = JSON.parse(e.response)
      puts res
      render json: res, status: res['status'] and return
    end
  end

  def inquiryNew
    token = session[:acc_token]
    id = params[:id]
    begin
      res = JSON.parse(RestClient.get PpobHelper.api_url + "pulsa/inquiry-new/" + id, {Authorization: "Bearer #{token}"})
      render json: res['data'] and return
    rescue RestClient::ExceptionWithResponse => e
      # render json: e.response and return
      res = JSON.parse(e.response)
      puts res
      render json: res, status: res['status'] and return
    end
  end

  def inquiryNews
    token = session[:acc_token]
    id = params[:id]
    begin
      res = JSON.parse(RestClient.get PpobHelper.api_url + "pulsa/inquiry-new/" + id, {Authorization: "Bearer #{token}"})
      render json: res and return
    rescue RestClient::ExceptionWithResponse => e
      render json: e.response and return
    end
  end

  def detail
    params[:productCode] = params[:nominal]
    token = session[:acc_token]
    data = PpobPulsaHelper.available(params, session[:acc_token])
    data = JSON.parse(RestClient.get PpobHelper.api_url + "pulsa/available-new/" + params[:productCode], {Authorization: "Bearer #{token}"})['data']
    telepon = params[:msisdn]

    if mobile_device?
      render 'mobile/sites/pages/pulsa/detail', locals: {data: data, telepon: telepon}, layout: 'application_mobile'
    else
      render 'accounts/evoucher/pulsa/detail', locals: {data: data, telepon: telepon}
    end
  end

  def beli
    # render 'accounts/evoucher/pulsa/metode', layout: 'application_payments' and return
    token = session['acc_token']
    data = {
        telepon: params[:msisdn],
        kodeProduk: params[:product]
    }
    res = JSON.parse(RestClient.post PpobHelper.api_url + "pulsa/beli", data, {Authorization: "Bearer #{token}"})
    if res['status'] == 200
      kodeTransaksi = res['data']['kode_transaksi']
      redirect_to '/evoucher/beli/' + kodeTransaksi
    else
      render json: 'gagal'
    end
  end

  def beliDetail
    bank = params[:bank]
    id = params[:id]
    token = session[:acc_token]
    kodeTransaksi = params[:id]

    data = JSON.parse(RestClient.get PpobHelper.api_url + "all/detail/" + id, {Authorization: "Bearer #{token}"})
    if data['bank_pengirim'] # apakah sudah data banks
      redirect_to '/evoucher/beli/' + kodeTransaksi + '/invoice'
    else
      if bank
        begin
          dataBank = JSON.parse(RestClient.get api_url + 'user_bank', {Authorization: "Bearer #{token}"})
          dataBank = dataBank['json']['data']
        rescue RestClient::ExceptionWithResponse => e
          render json: e.response and return
        end
        render 'accounts/evoucher/pay-bank',
               layout: 'application_payments',
               locals: {data: data, dataBank: dataBank, kodeTransaksi: kodeTransaksi}
      else
        @bank = Api::Account::BankController.listBank(api_url)['data']
        render 'accounts/evoucher/pay-metode',
               layout: 'application_payments', locals: {data: data}
      end
    end
  end

  def tagihan
    id = params[:id]
    token = session[:acc_token]
    data = JSON.parse(RestClient.get PpobHelper.api_url + "all/detail/" + id, {Authorization: "Bearer #{token}"})
    bank = Api::Account::BankController.listBank(api_url)['data']
    render 'accounts/evoucher/pay-tagihan', layout: 'application_payments',
           locals: {data: data, bank: bank}
  end

  def konfirmasi
    id = params[:id]
    token = session[:acc_token]
    data = JSON.parse(RestClient.get PpobHelper.api_url + "all/history/" + id, {Authorization: "Bearer #{token}"})
    @bank = Api::Account::BankController.listBank(api_url)['data']

    # render json: data and return
    render 'accounts/evoucher/pay-konfirmasi',
           layout: 'application',
           locals: {data: data}
  end

  def tambahBank
    token = session[:acc_token]
    kodeTransaksi = request[:kode_transaksi]
    bankPengirim = request[:bank_pengirim]

    if bankPengirim == ""
      dataPostBank = {
          user_bank: {
              nama_bank: 'MANDIRI',
              no_rekening: request[:nomor_rekening],
              atas_nama: request[:atas_nama],
              cabang: request[:cabang]
          }
      }
      tambah = JSON.parse(RestClient.post api_url + 'user_bank', dataPostBank, {Authorization: "Bearer #{token}"})
      bankPengirim = tambah['detail']['kode_bank']
    else
      bankPengirim = request[:bank_pengirim]
    end

    dataPost = {
        kodeTransaksi: request[:kode_transaksi],
        bankPengirim: bankPengirim
    }
    data = JSON.parse(RestClient.post PpobHelper.api_url + "all/update-data", dataPost, {Authorization: "Bearer #{token}"})
    redirect_to '/evoucher/beli/' + kodeTransaksi + '/invoice'
  end

  def invoice
    id = params[:id]
    token = session[:acc_token]
    data = JSON.parse(RestClient.get PpobHelper.api_url + "all/history/" + id, {Authorization: "Bearer #{token}"})

    render 'accounts/evoucher/pay-invoice', layout: 'application', locals: {data: data}
  end

  def history
    render 'accounts/transaksi/evoucher'
  end
end
