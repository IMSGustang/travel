class Api::Account::PaketHajiController < ApplicationController
  skip_before_action :verify_authenticity_token
  include VariableHelper
  require 'rest-client'
  require 'json'
  require 'helper/paginator'
  require 'helper/error'
  require 'helper/time'

  @api_url = VariableHelper.api_url
  def self.rendering(api_url, ses, params_page, per_page, debug)
    begin
      @res = RestClient.post api_url + '/produk/haji', {}, {
          'x-kode-kantor' => '',
          'x-jenis-paket' => '',
          'x-tahun' => '',
          'x-bulan' => '',
          'x-per-page' => per_page,
          'x-page' => params_page,
          'Authorization' => "Bearer #{ses}",
          'Accept' => 'application/json'
      }
      @json = JSON.parse(@res)

      # Paginator
      @page_html = Paginator::render(@json)

      page = {
          :link_prev => "<a class='page-link btn btn-success' href='?page=#{@page_html[:link_prev]}'>Prev</a>",
          :link_next => "<a class='page-link btn btn-success' href='?page=#{@page_html[:link_next]}'>Next</a>",
          :html => @page_html[:page]
      }

      # Debug Mode
      if debug == 'true'
        return page
      elsif debug == 'true2'
        return @json
      else
        data = {:data => @json['data'], :page => JSON.parse(page.to_json)}
        return JSON.parse(data.to_json)
      end
    rescue RestClient::ExceptionWithResponse => err
      return {:data => ''}
    end
  end

  def self.renderingDetail(api_url, kode, kd_kantor, session, x_bulan, x_tahun, x_jenis_paket = "", x_per_page = "", x_page = "", x_order_by = "", x_order_dir = "")
    begin
      res = RestClient.get api_url + '/produk/haji/' + kode, {
           Authorization: "Bearer #{session}",
          'x-kode-kantor' => kd_kantor,
          'x-bulan' => x_bulan,
          'x-tahun' => x_tahun,
          'x-jenis-paket' => x_jenis_paket,
          'x-per-page' => x_per_page,
          'x-page' => x_page,
          'x-order-by' => x_order_by,
          'x-order-dir' => x_order_dir
       }
      @json = JSON.parse(res)
      return @json
    rescue RestClient::ExceptionWithResponse => err
      @err_respon = JSON.parse(err.response)
      @err_json = {
          :status => false
      }
      return @err_respon
    end
  end

  def self.pencarianPaket(api_url, token, tahun, bulan, per_page, page, kantor, jenis_paket, order_by, order_dir, params = nil)
    begin
      if order_by.present?
        if order_by == '1'
          order_by1 = 'bulan'
          order_dir1 = 'asc'
        elsif order_by == '2'
          order_by1 = 'bulan'
          order_dir1 = 'desc'
        elsif order_by == '3'
          order_by1 = 'harga'
          order_dir1 = 'asc'
        elsif order_by == '4'
          order_by1 = 'harga'
          order_dir1 = 'desc'
        end
      end
      @res = RestClient.post api_url + '/produk/umrah', {}, {
          'x-kode-kantor' => kantor,
          'x-jenis-paket' => jenis_paket,
          'x-tahun' => tahun,
          'x-bulan' => bulan,
          'x-per-page' => per_page,
          'x-page' => page,
          'x-order-by' => order_by1,
          'x-order-dir' => order_dir1,
          'Authorization' => "Bearer #{token}",
          'Accept' => 'application/json'
      }

      @json = JSON.parse(@res)

      # Paginator
      paginator_var = params[:url]
      @page_html = Paginator::renderCustom(@json, paginator_var)

      page = {
          :link_prev => "<a class='page-link btn btn-success' href='?page=#{@page_html[:link_prev]}#{paginator_var}'>Prev</a>",
          :link_next => "<a class='page-link btn btn-success' href='?page=#{@page_html[:link_next]}#{paginator_var}'>Next</a>",
          :html => @page_html[:page]
      }

      # puts @request.domain

      data = {:data => @json['data'], :page => JSON.parse(page.to_json)}
      return JSON.parse(data.to_json)
    rescue RestClient::ExceptionWithResponse => err
      array = { "data" => nil}
      return JSON.parse(array.to_json)
    end
  end

  def invoicePaket
    begin
      @res = RestClient.get api_url + "/pembayaran/#{params[:kode]}", {
          'Authorization' => "Bearer #{session[:acc_token]}"
      }
      json = JSON.parse(@res)
      json_parser = {
          'nominalTransfer' => json['data']['totalbayar'],
          'kodeTransaksi' => json['data']['no_trans'],
          'kodeTipe' => json['data']['tipe_paket'],
          'namaProduk' => json['data']['nama_paket'],
          'dataMain' => {
              'metode_pembayaran' => "Deposit",
              'created_at' => json['data']['tgl_trans'],
              'harga' => json['data']['totalbayar']
          }
      }
      @data = JSON.parse(json_parser.to_json)
      # render json: @data
      render 'accounts/evoucher/pay-invoice', layout: 'application', locals: {data: @data}
    rescue RestClient::ExceptionWithResponse => err

    end
  end

  def self.pre_search(api_url, token, kk, jp, th, bl)
    begin
      res = RestClient.post api_url + '/produk/umrah/available', {}, {
          'x-kode-kantor' => kk,
          'x-jenis-paket' => jp,
          'x-tahun' => th,
          'x-bulan' => bl,
          'Authorization' => "Bearer #{token}",
          'Accept' => 'application/json'
      }
      return JSON.parse(res)
    rescue RestClient::ExceptionWithResponse => err
      puts "err: #{err}"
      return {:data => nil}
    end
  end

  def paketPopular(session, jumlah_kota, per_page, with_paket = nil)
    begin
      if !session[:acc_token].nil?
        @res = RestClient.get api_url + '/produk/umrah/kota_populer', {
            'Authorization' => "Bearer #{session[:acc_token]}",
            'x-per-page' => jumlah_kota
        }
      else
        @res = RestClient.get api_url + '/produk/umrah/kota_populer', {
            'Authorization' => "",
            'x-per-page' => jumlah_kota
        }
      end

      json_res = JSON.parse(@res)

      if with_paket == 'with_paket'
        array_res = Hash.new
        json_res['data'].each do |item|
          arr = Api::Account::PaketUmrahController.pencarianPaket(api_url, session[:acc_token], '', '', per_page, '', item['kode'], nil, '', nil, {:url => ''})['data']
          array_res[item['kota']] = arr
        end
        data_response = {:kota => json_res['data'], :paket => JSON.parse(array_res.to_json)}
        return JSON.parse(data_response.to_json)
        # return array_res
      else
        return JSON.parse(@res)
      end
    rescue RestClient::ExceptionWithResponse => err
      return err.response
    end
  end

  def self.searchSuggestionPaketHaji(session)
    begin
      res = RestClient.post @api_url + "/produk/haji/available", {

      }, {
        'Authorization' => "Bearer #{session}",
        'x-kode-kantor' => "",
        'x-jenis-paket' => "",
        'x-tahun' => "",
        'x-bulan' => ""
      }
      return JSON.parse(res)
    rescue RestClient::ExceptionWithResponse => e
      return e.response
    end
  end
end
