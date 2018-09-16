class EmailController < ApplicationController
  protect_from_forgery unless: -> { request.format.json? }
  layout 'application_email'

  skip_before_action :verify_authenticity_token, only: [:api_send_email_etiket]

  include ActionView::Helpers::TextHelper


  def verifikasi
    render 'email/verifikasi'
  end

  def invoices
    render 'email/invoices'
  end

  def tiketumrah
    render 'email/tiketumrah'
  end

  def EticketEmail
    render 'email/e-ticket_email'
  end

  def tiket2
    # require 'RMagick'
    # include Magick
    # img = ImageList.new('lib/template_tiket.png')
    # txt = Draw.new
    # img.annotate(txt, 0,0,0,0, "In ur Railz, annotatin ur picz."){
    #   txt.gravity = Magick::SouthGravity
    #   txt.pointsize = 25
    #   txt.stroke = '#000000'
    #   txt.fill = '#ffffff'
    #   txt.font_weight = Magick::BoldWeight
    # }
    require 'mini_magick'

    nomor_tiket = 'ABU-123456789'
    estimasi = 'JAN 2018'
    nama_paket1 = 'UMRAH REGULER 9 HARI QUAD PLUS DUBAI DAN TURKI'
    nama_paket2 = word_wrap(nama_paket1, line_width: 25, break_sequence: '\n')

    # path = "#{Rails.public_path}#{ActionController::Base.helpers.asset_path('lib/template_tiket.png')}"
    path = "#{Rails.root}/lib/assets/template_tiket.png"
    img = MiniMagick::Image.open(path)
    img.combine_options do |c|
      c.gravity 'NorthWest'
      c.font 'ArialB'
      c.fill 'black'
      c.pointsize '24'
      c.draw "text 240,18 'E-TIKET UMRAH'"

      c.font 'Arial'
      c.pointsize '12'

      c.fill 'gray'
      c.draw "text 240,55 'Nomor Invoice'"

      c.font 'ArialB'
      c.fill 'black'
      c.draw "text 240,71 '#{nomor_tiket}'"

      c.font 'Arial'
      c.fill 'gray'
      c.draw "text 240,105 'Estimasi Keberangkatan'"


      c.font 'ArialB'
      c.fill 'black'
      c.draw "text 240,121 '#{estimasi}'"

      c.font 'Arial'
      c.fill 'gray'
      c.draw "text 240,155 'Program'"

      c.font 'ArialB'
      c.pointsize '12'
      c.fill 'black'
      c.draw "text 240,171 '#{nama_paket1}'"

      c.pointsize '12'
      c.fill 'gray'
      c.font 'ArialI'
      c.draw "text 240,200 'Tiket berlaku untuk satu kali transaksi'"


      c.font "#{Rails.root}/lib/fonts/code39.ttf"
      c.fill 'black'
      c.pointsize '8'
      c.draw "text 240, 220 '#{nomor_tiket}'"

      c.pointsize '12'
      c.font 'Arial'
      c.gravity 'North'
      c.fill 'gray'
      c.draw "text -285,70 'Nomor Invoice'"
      c.font 'ArialB'
      c.fill 'black'
      c.draw "text -285,90 '#{nomor_tiket}'"

      c.font 'Arial'
      c.fill 'gray'
      c.draw "text -285,120 'Estimasi Keberangkatan'"
      c.font 'ArialB'
      c.fill 'black'
      c.draw "text -285,140 '#{estimasi}'"

      c.font 'Arial'
      c.fill 'gray'
      c.draw "text -285,170 'Program'"
      c.font 'ArialB'
      c.fill 'black'
      # c.draw "text -285,190 '#{nama_paket}'"

      c.annotate '0,0,-285,190', "#{nama_paket2}"

      c.font "#{Rails.root}/lib/fonts/code39.ttf"
      c.fill 'black'
      c.pointsize '8'
      c.draw "text -285, 240 '#{nomor_tiket}'"

      c.font 'Arial'
      c.fill 'red'
      c.pointsize '11'
      c.draw "text -285,272 'Time: #{Time.current.utc}'"

    end
    # img.format = 'jpeg'
    send_data img.to_blob, :stream => 'false', :filename => 'etiket.jpg', :type => 'image/jpeg', :disposition => 'inline'
  end

  def tes_kirim_email
    AbuMailer.e_ticket_email(session[:acc_token], 'ABU967272EVC').deliver
    render :text => 'Email terkirim'
  end

  def api_send_email_etiket
    if params[:kode_transaksi]
      AbuMailer.e_ticket_email(nil, params[:kode_transaksi]).deliver
      render json: { success: true }, status: 200
    end
  end

  def konfirmasiagen
    render 'email/konfirmasitoko'
  end

  def ebooking
    render 'email/e-booking'
  end

  def ebooking_pdf

    data = Api::Account::JamaahController.detail_jamaah_for_publik(api_url,params[:kode_booking])
    Rails.logger.info(data)
    if data && data['data']
      @data = data['data']
      respond_to do |format|
        format.pdf do
          render :pdf => "#{params[:kode_booking]}-#{params[:stupid_hash]}",
                 :disposition => "inline",
                 viewport_size: '1024x768',
                 :template => "email/e-booking_pdf.html.erb",
                 :layout => "application_email_pdf",
                 disable_smart_shrinking: true,
                 book: false,
                 image_quality: 100,
                 lowquality: false,
                 zoom: 1,
                 print_media_type: true,
                 margin: {
                     top: 0,
                     left: 0,
                     right: 0,
                     bottom: 0
                 }
        end
        format.html
      end
    else
        redirect_to '/error/404'
    end
  end

  def eticketnew
    render 'email/e-ticketnew'
  end

  def eticketnew_pdf
    data = Api::Account::JamaahController.detail_tiket_for_publik(api_url,params[:kode_tiket])
    Rails.logger.info(data)
    if data && data['data']
      @data = data['data']
      respond_to do |format|
        format.pdf do
          render :pdf => "#{params[:kode_tiket]}-#{params[:sambarang]}",
                 :disposition => "inline",
                 viewport_size: '1024x768',
                 :template => "email/e-ticketnew_pdf.html.erb",
                 :layout => "application_email_pdf",
                 disable_smart_shrinking: true,
                 book: false,
                 image_quality: 100,
                 lowquality: false,
                 zoom: 1,
                 print_media_type: true,
                 margin: {
                     top: 0,
                     left: 0,
                     right: 0,
                     bottom: 0
                 }
        end
        format.html
      end
    else
      redirect_to '/error/404'
    end
  end
end
