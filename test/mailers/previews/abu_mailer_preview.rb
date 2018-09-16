class AbuMailerPreview < ActionMailer::Preview

  def e_ticket_email
    AbuMailer.e_ticket_email('3b20b498d151d8f18934947e95bd82d9b216496c5abb13b9a17ce078e13ac23a', 'ABU242443EVC')
  end

  def konfirmasi_pemesanan
    AbuMailer.konfirmasi_pemesanan('http://apiv3.abutours.com/v1/', 'f053fe6f41f62a4620b32a0023af0595d727b14b15df924e98ec53fab4545865','OYV897')
  end

  def status_pemesanan
    AbuMailer.status_pemesanan('http://apiv3.abutours.com/v1/', 'f053fe6f41f62a4620b32a0023af0595d727b14b15df924e98ec53fab4545865', 'B-17051257134')
  end
end