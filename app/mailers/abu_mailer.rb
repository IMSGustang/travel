class AbuMailer < ApplicationMailer
  include AbstractController::Callbacks

  def e_ticket_email(token, kode_transaksi)
    @data = Api::Account::TiketPesawatController.eTiket(token, kode_transaksi)
    if @data && @data['dataMain'] && @data['dataMain'][0]['con_email_address']
      data_main = @data['dataMain'][0]
      recipients = data_main['con_email_address']
      subject = "[Abutours] E-tiket #{data_main['airlines_name']} Anda - No. Pesanan #{data_main['order_id']}"
      @server_url = Rails.env.production? ? 'http://abutours.com' : 'http://rails.abutours.com'
      mail(to: recipients, subject: subject)
      puts 'EMAIL SENT'
    else
      puts 'NO DATA'
    end
  end

  def konfirmasi_pemesanan(api_url, token, kode_booking)
    @server_url = Rails.env.production? ? 'http://abutours.com' : 'http://rails.abutours.com'
    @data_pesan = Api::Account::OwnershipController.get_order_detail(api_url, token, kode_booking)
    to = @data_pesan['detail_pelanggan'] ? @data_pesan['detail_pelanggan']['email'] : 'hardie@caryta.com'
    if @data_pesan
      if @data_pesan['pesan_via'] == 'microsite'
        res = RestClient.get api_url + "/ownership/me", {
            'Authorization' => "Bearer #{token}"
        }
        data_owner = JSON.parse(res)['data']
        @logo_perusahaan = data_owner['logo']['url'] if data_owner['logo']
        @nama_perusahaan = data_owner['nama_perusahaan']
        @url_konfirmasi = "http://#{data_owner['brand']}.abutours.com"
      else
        res = RestClient.get api_url + "/users/toko", {
            'Authorization' => "Bearer #{token}"
        }
        data_owner = JSON.parse(res)['data']
        @logo_perusahaan = data_owner['logo']['url'] if data_owner['logo']
        @nama_perusahaan = data_owner['nama_toko']
        @url_konfirmasi = "#{@server_url}/u/data_owner['nama_toko']"
      end

      res = RestClient.get api_url + '/user_bank', {
          'x-per-page' => '4',
          'Authorization' => "Bearer #{token}"
      }
      data = JSON.parse(res)
      @data_bank = data['json']['data'] if data['json'] && data['json']['data']
      @data_bank.each do |bank|
        attachments.inline["#{bank['nama_bank']}.png"] = File.read("#{Rails.root}/app/assets/images/lib/payment-icon/#{bank['nama_bank']}.png")
      end
      subject = "[#{@nama_perusahaan}] Pemesanan Paket Anda - No. Pesanan #{@data_pesan['notrans']}"
      mail(to: to, subject: subject)
    end
  end

  def status_pemesanan(api_url, token, nomor_bayar)
    @server_url = Rails.env.production? ? 'http://abutours.com' : 'http://rails.abutours.com'
    @data_pesan = Api::Account::OwnershipController.get_pembayaran_detail(api_url, token, nomor_bayar)
    to = @data_pesan['detail_pelanggan'] ? @data_pesan['detail_pelanggan']['email'] : 'hardie@caryta.com'
    if @data_pesan
      if @data_pesan['pesan_via'] == 'microsite'
        res = RestClient.get api_url + "/ownership/me", {
            'Authorization' => "Bearer #{token}"
        }
        data_owner = JSON.parse(res)['data']
        @logo_perusahaan = data_owner['logo']['url'] if data_owner['logo']
        @nama_perusahaan = data_owner['nama_perusahaan']
        @url_konfirmasi = "http://#{data_owner['brand']}.abutours.com"
      else
        res = RestClient.get api_url + "/users/toko", {
            'Authorization' => "Bearer #{token}"
        }
        data_owner = JSON.parse(res)['data']
        @logo_perusahaan = data_owner['logo']['url'] if data_owner['logo']
        @nama_perusahaan = data_owner['nama_toko']
        @url_konfirmasi = "#{@server_url}/u/#{data_owner['nama_toko']}"
      end

      res = RestClient.get api_url + '/user_bank', {
          'x-per-page' => '4',
          'Authorization' => "Bearer #{token}"
      }
      data = JSON.parse(res)
      @data_bank = data['json']['data'] if data['json'] && data['json']['data']
      @data_bank.each do |bank|
        attachments.inline["#{bank['nama_bank']}.png"] = File.read("#{Rails.root}/app/assets/images/lib/payment-icon/#{bank['nama_bank']}.png")
      end
      subject = "[#{@nama_perusahaan}] Status Konfirmasi Pembayaran Anda - No. Pesanan #{@data_pesan['notrans']}"
      mail(to: to, subject: subject)
    end
  end

end