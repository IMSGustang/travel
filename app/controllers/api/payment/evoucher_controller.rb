class Api::Payment::EvoucherController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :Authentication

  def getDepositOtp
    begin
      dataHeader = {
          "Authorization" => "Bearer #{session[:acc_token]}",
          "x-kode-transaksi" => params[:kode_transaksi],
          "x-otp-via" => 'sms'
      }
      data = JSON.parse(RestClient.get PpobHelper.api_url + 'all/otp', dataHeader)
      render json: data and return
    rescue RestClient::ExceptionWithResponse => err
      if err.response.code == 500
        render '/errors/500', layout: 'application_errors'
      else
        render json: JSON.parse(err.response) and return
      end
    end
  end

  def confirmDepositOtp
    otp = params[:otp]

    data = []
    otp.each_with_index do |row, i|
      data[i] = row
    end
    # render json: data and return
    realOtp = data.join("")
    begin
      dataHeader = {
          "Authorization" => "Bearer #{session[:acc_token]}",
          "x-kode-transaksi" => params[:kode_transaksi],
          "x-kode-otp" => realOtp
      }
      dataBody = {
          kodeTransaksi: params[:kode_transaksi]
      }
      data = JSON.parse(RestClient.post PpobHelper.api_url + 'all/konfirmasi', dataBody, dataHeader)
      render json: data and return
    rescue RestClient::ExceptionWithResponse => err
      render json: JSON.parse(err.response) and return
      if err.response.code == 500
        render '/errors/500', layout: 'application_errors'
      else
        render json: err and return
      end
    end
  end
end
