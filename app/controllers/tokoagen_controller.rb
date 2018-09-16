class TokoagenController < ApplicationController
  def tokoagen
    render 'tokoagen/index'
  end

  def detailproductoko
    require 'restclient'
    url = api_url + 'users/toko/' + params[:nama_toko] + '/paket/' + params[:kode_paket]
    begin
      res = RestClient.get url, { 'Accept' => 'application/json', 'x-client-id' => '1cec286c6a4078358e12f5324c33aaed5486170a950ef893f13b78e096141d6f' }
      data = JSON.parse(res)
      if data['status'] == 200
        @detail_paket = data['data']
        @data = data['detail_umrah']
        render 'tokoagen/detailpacket'
      else
        redirect_to '/error/404'
      end
    rescue RestClient::ExceptionWithResponse => err
      Rails.logger.info(err)
      redirect_to '/error/404'
    end
  end

  def konfirmasipembelianpaketagen
    require 'restclient'
    url = api_url + 'users/toko/' + params[:nama_toko] + '/bank'
    begin
      res = RestClient.get url, { 'Accept' => 'application/json', 'x-client-id' => '1cec286c6a4078358e12f5324c33aaed5486170a950ef893f13b78e096141d6f' }
      data = JSON.parse(res)
      if data['status'] == 200
        @bank = data['data']
      else
        @bank = nil
      end
    rescue RestClient::ExceptionWithResponse => err
      Rails.logger.info(err)
      redirect_to '/error/404'
    end
    if request.post?
      begin
        if params[:file].present?
          files = Api::UploaderController.new
          file = files.uploader(params[:file])
        end
        url = api_url + 'ownership/public/konfirmasi_bayar/' + params[:kode_booking]
        res = RestClient.post(url, {
                                  kode_bank: params[:bank],
                                  jumlah: params[:nominal].gsub(',','').gsub('Rp ',''),
                                  gambar: file
                              },
                              {
                                  'Accept' => 'application/json', 'x-client-id' => '1cec286c6a4078358e12f5324c33aaed5486170a950ef893f13b78e096141d6f'
                              }
        )
        @result = JSON.parse(res)
        if @result['status'] == 200
          @success = true
        end
        puts @result
      rescue RestClient::ExceptionWithResponse => err
        Rails.logger.info(err.response)
        @error = true
        @result = JSON.parse(err.response)
        @kode_booking = params[:kode_booking]
        @nominal = params[:nominal]
        @kode_bank = params[:bank]
      end
    end
    render 'tokoagen/konfirmasipemesanan'
  end
end
