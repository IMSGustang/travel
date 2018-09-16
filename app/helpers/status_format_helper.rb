module StatusFormatHelper
  def self.status_pembayaran_ppob(status)
    case status
      when 0
        'Menunggu Pembayaran'
      when 1
        'Order'
      when 2
        'Menunggu Approval'
      else
        'Unknown'
    end
  end
end
