class PpobAllController < ApplicationController
  skip_before_action :verify_authenticity_token
  include ApplicationHelper
  require 'helper/time'
  require 'helper/number'
  require 'helper/strg'
  require 'rest-client'
  require 'json'
  require "base64"
  require 'fileutils'
  require 'carrierwave/orm/activerecord'

  # def beliDetail #hapus
  #   bank = params[:bank]
  #   id = params[:id]
  #   token = session[:acc_token]
  #   kodeTransaksi = params[:id]
  #
  #
  #   # data = JSON.parse(RestClient.get PpobHelper.api_url + "all/detail/" + id, {Authorization: "Bearer #{token}"})
  #   data = JSON.parse(RestClient.get PpobHelper.api_url + "all/history/" + id, {Authorization: "Bearer #{token}"})
  #   # render json: data and return
  #
  #   if data['bank_penerima']
  #     dataBank = JSON.parse(RestClient.get api_url + 'bank/' + bank, {Authorization: "Bearer #{token}"})
  #     bank = Api::Account::BankController.listBank(api_url)['data']
  #     data = JSON.parse(RestClient.get PpobHelper.api_url + "all/history/" + id, {Authorization: "Bearer #{token}"})
  #     render 'accounts/evoucher/pay-tagihan',
  #            layout: 'application_payments',
  #            locals: {data: data, bank: bank, dataBank: dataBank, kodeTransaksi: kodeTransaksi} and return
  #   else
  #     if bank
  #       dataPost = {
  #           kodeTransaksi: params[:id],
  #           bankPenerima: bank
  #       }
  #       # update data bank
  #       data = JSON.parse(RestClient.post PpobHelper.api_url + "all/update-data", dataPost, {Authorization: "Bearer #{token}"})
  #       PusherHelper.push('dashboard-abutours', 'my-event', {title: 'Transaksi Terbaru ' + id, message: 'Pembelian Pulsa terbaru'})
  #       #
  #       dataBank = JSON.parse(RestClient.get api_url + 'bank/' + bank, {Authorization: "Bearer #{token}"})
  #       bank = Api::Account::BankController.listBank(api_url)['data']
  #       data = JSON.parse(RestClient.get PpobHelper.api_url + "all/history/" + id, {Authorization: "Bearer #{token}"})
  #       render 'accounts/evoucher/pay-tagihan',
  #              layout: 'application_payments',
  #              locals: {data: data, bank: bank, dataBank: dataBank, kodeTransaksi: kodeTransaksi} and return
  #     else
  #
  #             # dataBank = JSON.parse(RestClient.get api_url + 'user_bank', {Authorization: "Bearer #{token}"})
  #             # dataBank = dataBank['json']['data']
  #       bank = Api::Account::BankController.listBank(api_url)['data']
  #       data = JSON.parse(RestClient.get PpobHelper.api_url + "all/history/" + id, {Authorization: "Bearer #{token}"})
  #       render 'accounts/evoucher/pay-metode-new',
  #              layout: 'application_payments',
  #              locals: {data: data, bank: bank, kodeTransaksi: kodeTransaksi} and return
  #     end
  #   end
  # end

  def beliDetailMetode
    begin
      bank = params[:bank]
      id = params[:id]
      token = session[:acc_token]
      kodeTransaksi = params[:id]

      if bank #jika ada bank
        begin
          data = JSON.parse(RestClient.get PpobHelper.api_url + "all/history/" + id, {Authorization: "Bearer #{token}"})
          dataMethod = JSON.parse(RestClient.get PpobHelper.api_url + "all/choose-payment/?v=1&kodeTransaksi=#{id}&kodeBank=#{bank}", {Authorization: "Bearer #{token}"})

          redirect_to("/evoucher/beli/#{id}/tagihan") and return
        rescue RestClient::ExceptionWithResponse => err
          if err.response.code == 500
            if params['debug'] == 'true'
              render json: JSON.pretty_generate(Api::HelperController::Error(e, request.original_url, session));
            else
              render '/errors/500', layout: 'application_errors'
            end
          else
            render json: err and return
          end
        end
      else
        begin
          data = JSON.parse(RestClient.get PpobHelper.api_url + "all/history/" + id, {Authorization: "Bearer #{token}"})
          dataMethod = JSON.parse(RestClient.get PpobHelper.api_url + "all/available-payment/" + id, {Authorization: "Bearer #{token}"})
          # render json: dataMethod and return
          bank = Api::Account::BankController.listBank(api_url)['data']

          data_local = {data: data, bank: bank, kodeTransaksi: kodeTransaksi, dataMethod: dataMethod}
          if mobile_device?
            render '/payment/mobile/metode', layout: 'application_mobile', locals: data_local and return
          else
            render 'accounts/evoucher/pay-metode-new', layout: 'application_payments',
                   locals: data_local and return
          end
        rescue RestClient::ExceptionWithResponse => err
          if err.response.code == 500
            if params['debug'] == 'true'
              render json: JSON.pretty_generate(Api::HelperController::Error(e, request.original_url, session));
            else
              render '/errors/500', layout: 'application_errors'
            end
          else
            render json: err and return
          end
        end
      end

      begin
        data = JSON.parse(RestClient.get PpobHelper.api_url + "all/history/" + id, {Authorization: "Bearer #{token}"})
        dataMethod = JSON.parse(RestClient.get PpobHelper.api_url + "all/available-payment/" + id, {Authorization: "Bearer #{token}"})
        # render json: dataMethod and return
            bank = Api::Account::BankController.listBank(api_url)['data']
        render 'accounts/evoucher/pay-metode-new',
                   layout: 'application_payments',
                   locals: {data: data, bank: bank, kodeTransaksi: kodeTransaksi, dataMethod: dataMethod} and return
      rescue RestClient::ExceptionWithResponse => err
        if err.response.code == 500
          if params['debug'] == 'true'
            render json: JSON.pretty_generate(Api::HelperController::Error(e, request.original_url, session));
          else
            render '/errors/500', layout: 'application_errors'
          end
        else
          return {:status => false}
        end
      end
    rescue Exception => e
      Error.log(e, request.original_url)
      render "errors/500", layout: 'application_errors'
    end

    # if data['bank_penerima']
    #   dataBank = JSON.parse(RestClient.get api_url + 'bank/' + bank, {Authorization: "Bearer #{token}"})
    #   bank = Api::Account::BankController.listBank(api_url)['data']
    #   data = JSON.parse(RestClient.get PpobHelper.api_url + "all/history/" + id, {Authorization: "Bearer #{token}"})
    #   render 'accounts/evoucher/pay-tagihan',
    #          layout: 'application_payments',
    #          locals: {data: data, bank: bank, dataBank: dataBank, kodeTransaksi: kodeTransaksi} and return
    # else
    #   if bank
    #     dataPost = {
    #         kodeTransaksi: params[:id],
    #         bankPenerima: bank
    #     }
    #     # update data bank
    #     data = JSON.parse(RestClient.post PpobHelper.api_url + "all/update-data", dataPost, {Authorization: "Bearer #{token}"})
    #     PusherHelper.push('dashboard-abutours', 'my-event', {title: 'Transaksi Terbaru ' + id, message: 'Pembelian Pulsa terbaru'})
    #     #
    #     dataBank = JSON.parse(RestClient.get api_url + 'bank/' + bank, {Authorization: "Bearer #{token}"})
    #     bank = Api::Account::BankController.listBank(api_url)['data']
    #     data = JSON.parse(RestClient.get PpobHelper.api_url + "all/history/" + id, {Authorization: "Bearer #{token}"})
    #     render 'accounts/evoucher/pay-tagihan',
    #            layout: 'application_payments',
    #            locals: {data: data, bank: bank, dataBank: dataBank, kodeTransaksi: kodeTransaksi} and return
    #   else
    #
    #     # dataBank = JSON.parse(RestClient.get api_url + 'user_bank', {Authorization: "Bearer #{token}"})
    #     # dataBank = dataBank['json']['data']
    #     bank = Api::Account::BankController.listBank(api_url)['data']
    #     data = JSON.parse(RestClient.get PpobHelper.api_url + "all/history/" + id, {Authorization: "Bearer #{token}"})
    #     render 'accounts/evoucher/pay-metode',
    #            layout: 'application_payments',
    #            locals: {data: data, bank: bank, kodeTransaksi: kodeTransaksi} and return
    #   end
    # end
  end

  def metodeAbupay
    begin
      bank = params[:bank]
      id = params[:id]
      token = session[:acc_token]
      kodeTransaksi = params[:id]

      begin

        data = JSON.parse(RestClient.get PpobHelper.api_url + "all/history/" + id, {Authorization: "Bearer #{token}"})
        # {{API_URL}}/v1/ppob/all/choose-payment?v=1&kodeTransaksi=ABU463711EVC
        dataMethod = JSON.parse(RestClient.get PpobHelper.api_url + "all/choose-payment?v=3&kodeTransaksi=" + id, {Authorization: "Bearer #{token}"})
        if dataMethod['status'] == 200
          data_local = {data: data, kodeTransaksi: kodeTransaksi}
          if mobile_device?
            render '/payment/mobile/metode-deposit', layout: 'application_mobile', locals: data_local and return
          else
            render 'accounts/evoucher/pay-konfirmasi-deposit',
                   layout: 'application_payments',
                   locals: data_local and return
          end
        end
        # render json: dataMethod and return
      rescue RestClient::ExceptionWithResponse => err
        if err.response.code == 500
          if params['debug'] == 'true'
            render json: JSON.pretty_generate(Api::HelperController::Error(e, request.original_url, session));
          else
            render '/errors/500', layout: 'application_errors'
          end
        else
          return {:status => false}
        end
      end
    rescue Exception => e
      Error.log(e, request.original_url)
      render "errors/500", layout: 'application_errors'
    end
  end

  def metode_abupay_otp
    begin
      bank = params[:bank]
      id = params[:id]
      token = session[:acc_token]
      kodeTransaksi = params[:id]

      begin

        data = JSON.parse(RestClient.get PpobHelper.api_url + "all/history/" + id, {Authorization: "Bearer #{token}"})
        dataMethod = JSON.parse(RestClient.get PpobHelper.api_url + "all/choose-payment?v=3&kodeTransaksi=" + id, {Authorization: "Bearer #{token}"})
        if dataMethod['status'] == 200
          data_local = {data: data, kodeTransaksi: kodeTransaksi}
          if mobile_device?
            render '/payment/mobile/metode-deposit-otp', layout: 'application_mobile', locals: data_local and return
          else
            render 'accounts/evoucher/pay-konfirmasi-deposit',
                   layout: 'application_payments',
                   locals: data_local and return
          end
        end
          # render json: dataMethod and return
      rescue RestClient::ExceptionWithResponse => err
        if err.response.code == 500
          if params['debug'] == 'true'
            render json: JSON.pretty_generate(Api::HelperController::Error(e, request.original_url, session));
          else
            render '/errors/500', layout: 'application_errors'
          end
        else
          return {:status => false}
        end
      end
    rescue Exception => e
      Error.log(e, request.original_url)
      render "errors/500", layout: 'application_errors'
    end
  end

  def metode_transfer
    begin
      bank = params[:bank]
      id = params[:id]
      token = session[:acc_token]
      kodeTransaksi = params[:id]

      begin
          data = JSON.parse(RestClient.get PpobHelper.api_url + "all/history/" + id, {Authorization: "Bearer #{token}"})
          bank = Api::Account::BankController.listBank(api_url)['data']
          data_local = {data: data, bank: bank, kodeTransaksi: kodeTransaksi}
          if mobile_device?
            render '/payment/mobile/metode-transfer', layout: 'application_mobile', locals: data_local and return
          else
            redirect_to '/evoucher/beli/' + kodeTransaksi
          end
      rescue RestClient::ExceptionWithResponse => err
        if err.response.code == 500
          if params['debug'] == 'true'
            render json: JSON.pretty_generate(Api::HelperController::Error(e, request.original_url, session));
          else
            render '/errors/500', layout: 'application_errors'
          end
        else
          return {:status => false}
        end
      end
    rescue Exception => e
      Error.log(e, request.original_url)
      render "errors/500", layout: 'application_errors'
    end
  end

  def tambahBank
    begin
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
      redirect_to '/evoucher/beli/' + kodeTransaksi + '/tagihan'
    rescue Exception => e
      if params['debug'] == 'true'
        render json: JSON.pretty_generate(Api::HelperController::Error(e, request.original_url, session));
      else
        render '/errors/500', layout: 'application_errors'
      end
    end
  end

  def tagihan
    begin
      id = params[:id]
      token = session[:acc_token]
      data = JSON.parse(RestClient.get PpobHelper.api_url + "all/history/" + id, {Authorization: "Bearer #{token}"})
      bank = Api::Account::BankController.detailBank(api_url, data['dataMain']['bank_penerima'])
      render 'accounts/evoucher/pay-tagihan', layout: 'application_payments',
             locals: {data: data, bank: bank}
    rescue Exception => e
      if params['debug'] == 'true'
        render json: JSON.pretty_generate(Api::HelperController::Error(e, request.original_url, session));
      else
        render '/errors/500', layout: 'application_errors'
      end
    end
  end

  def invoice
    begin
      id = params[:id]
      token = session[:acc_token]
      data = JSON.parse(RestClient.get PpobHelper.api_url + "/history/" + id, {Authorization: "Bearer #{token}"})['data']
      data_local = {data: data}
      if mobile_device?
        render 'mobile/transaction/invoice/index-ppob', layout: 'application_mobile', locals: data_local and return
      else
        render 'accounts/evoucher/pay-invoice-general', layout: 'application', locals: data_local and return
      end
    rescue Exception => e
      if params['debug'] == 'true'
        render json: JSON.pretty_generate(Api::HelperController::Error(e, request.original_url, session));
      else
        render '/errors/500', layout: 'application_errors'
      end
    end
  end

  def konfirmasi

    id = params[:id]
    token = session[:acc_token]
    data = JSON.parse(RestClient.get PpobHelper.api_url + "all/history/" + id, {Authorization: "Bearer #{token}"})
    # @bank = Api::Account::BankController.listBank(api_url)['data']
    @bank = Bank::abutours(data['dataMain']['bank_penerima'])
    begin
      if data['dataMain']['tanggal_konfirmasi']
        redirect_to '/evoucher/beli/' + id + '/invoice'
      else
        # render json: data and return
        if data['jenisPembayaran'] == "DEPOSIT"
          redirect_to('/evoucher/beli/' + data['kodeTransaksi'] + '/ABUPAY')
        else
          render 'accounts/evoucher/pay-konfirmasi',
                 layout: 'application',
                 locals: {data: data}
        end
      end
      # render json: @bank
    rescue Exception => e
      if params['debug'] == 'true'
        render json: JSON.pretty_generate(Api::HelperController::Error(e, request.original_url, session));
      else
        render '/errors/500', layout: 'application_errors'
      end
    end

  end

  def konfirmasiPembayaran
    begin
      if params[:jumlah] == nil or params[:gambar].nil?
        # render json: 'ada yang kosong'
        redirect_to "/transaksi-evoucher?res=fails", :flash => { :message => "Transaksi Gagal", :status => true, :type => 0}
      else
        kodeTransaksi = params[:kode_transaksi]
        jumlah = params[:jumlah].gsub(/[^0-9]/, '')
        gambar = params[:gambar]
        bankPengirim = params[:bank_pengirim]
        bankPenerima = params[:bank_penerima]

        begin
          uploader = AvatarUploader.new
          uploader.store!(params['gambar'])
          uploader.retrieve_from_store!('xdk')

          image = File.open(Rails.root.to_s+"/public/temp-file/#{uploader.identifier}") {|img| img.read}
          encoded_image = Base64.encode64 image
          data_image = MiniMagick::Image.open(Rails.root.to_s+"/public/temp-file/#{uploader.identifier}")
          base64_image = "data:image/#{data_image.type};base64,#{encoded_image}"
          base64_image =  base64_image.gsub!(/\s+/, '')

          dataHeader = {
              "Authorization" => "Bearer #{session[:acc_token]}",
              "x-kode-transaksi" => kodeTransaksi
          }

          dataPost = {
              kodeTransaksi: kodeTransaksi,
              nominal: jumlah,
              bankPenerima: bankPenerima,
              bukti_transfer: base64_image
          }

          res = RestClient.post PpobHelper.api_url + 'all/konfirmasi', dataPost, dataHeader
          @json = JSON.parse(res)
          redirect_to "/transaksi-evoucher?res=success", :flash => { :message => 'Konfirmasi telah berhasil', :status => true, :type => 0}
        rescue RestClient::ExceptionWithResponse => err
          @err_data = JSON.parse(err.response)
          # render json: err.response and return
          redirect_to "/transaksi-evoucher?res=fails", :flash => { :message => @err_data['message'], :status => true, :type => 0}
        end
      end
    rescue Exception => e
      if params['debug'] == 'true'
        render json: JSON.pretty_generate(Api::HelperController::Error(e, request.original_url, session));
      else
        render '/errors/500', layout: 'application_errors'
      end
    end
  end

  def konfirmasiPembayaranAbupay
    begin
      kodeTransaksi = params[:id]
      begin
        konfirmasi = JSON.parse(RestClient.post PpobHelper.api_url + 'all/konfirmasi', {kodeTransaksi: kodeTransaksi}, {"Authorization" => "Bearer #{session[:acc_token]}"})
        token = session[:acc_token]
        data = JSON.parse(RestClient.get PpobHelper.api_url + "/history/" + kodeTransaksi, {Authorization: "Bearer #{session[:acc_token]}"})
        render json: data and return

        render 'accounts/evoucher/pay-invoice', layout: 'application', locals: {data: data}
      rescue RestClient::ExceptionWithResponse => err
        if err.response.code == 500
          render '/errors/500', layout: 'application_errors'
        else
          return {:status => false}
        end
      end
      
    rescue Exception => e
      if params['debug'] == 'true'
        render json: JSON.pretty_generate(Api::HelperController::Error(e, request.original_url, session));
      else
        render '/errors/500', layout: 'application_errors'
      end
    end
    # Handle form kosong

  end

end
