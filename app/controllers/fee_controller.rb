class FeeController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :Authentication
  include ApplicationHelper
  include ActionView::Helpers::TextHelper
  require 'helper/time'
  require 'helper/number'
  require 'helper/strg'
  require 'helper/error'

  # -- panel pencairan fee --
  def index
    @res = params['res']
    begin
      bank = JSON.parse(RestClient.get VariableHelper.api_url + "user_bank", {Authorization: "Bearer #{session[:acc_token]}"})
      dataBank = bank['json']['data']
    rescue RestClient::ExceptionWithResponse => e
      redirect_to '/tambah-data-bank?res=success', :flash => {:message => "Anda belum memiliki data bank, silahkan buat terbelih dahulu", :status => true} and return
      render(:status => response.code)
    end

    # -- transaksi pencairan
    begin
      res = JSON.parse(RestClient.get VariableHelper.api_url + "fee/history-pencairan", {Authorization: "Bearer #{session[:acc_token]}"})
      data = res['data']
    rescue RestClient::ExceptionWithResponse => e
      if params['debug'] == 'true'
        render json: JSON.pretty_generate(Api::HelperController::Error(e, request.original_url, session));
      else
        render '/errors/500', layout: 'application_errors'
      end
    end

    if mobile_device?
      render 'mobile/accounts/fee/index', layout: 'application_mobile', locals: {dataBank: dataBank, data: data}
    else
      render 'accounts/fee/index'
    end
  end

  def pencairan
    @res = params['res']
    begin
      bank = JSON.parse(RestClient.get VariableHelper.api_url + "user_bank", {Authorization: "Bearer #{session[:acc_token]}"})
      dataBank = bank['json']['data']
    rescue RestClient::ExceptionWithResponse => e
      redirect_to '/tambah-data-bank?res=success', :flash => {:message => "Anda belum memiliki data bank, silahkan buat terbelih dahulu", :status => true} and return
      render(:status => response.code)
    end
    render 'accounts/fee/pencairan', locals: {dataBank: dataBank}
  end

  def aksi_pencairan
    header = {
        "Authorization" => "Bearer #{session[:acc_token]}",
        "x-metode" => params[:metode],
        "x-kode-bank" => params[:bank],
    }
    begin
      data = JSON.parse(RestClient.post VariableHelper.api_url + "fee/cair", {}, header)
      status = data['status']
      success = data['success']
    rescue RestClient::ExceptionWithResponse => e
      if params['debug'] == 'true'
        render json: JSON.pretty_generate(Api::HelperController::Error(e, request.original_url, session));
      else
        render '/errors/500', layout: 'application_errors'
      end
    end
    redirect_to '/fee/transaksi-pencairan'
  end

  def transaksi_pencairan
    begin
      res = JSON.parse(RestClient.get VariableHelper.api_url + "fee/history-pencairan", {Authorization: "Bearer #{session[:acc_token]}"})
      data = res['data']
    rescue RestClient::ExceptionWithResponse => e
      if params['debug'] == 'true'
        render json: JSON.pretty_generate(Api::HelperController::Error(e, request.original_url, session));
      else
        render '/errors/500', layout: 'application_errors'
      end
    end
    render 'accounts/fee/transaksi-pencairan', locals: {data: data}
  end

  def fee_pasif
    render 'accounts/fee/index-pasif'
  end

  def transaksi_fee
    render 'accounts/fee/transaksi'
  end
end
