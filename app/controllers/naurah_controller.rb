class NaurahController < ApplicationController
  before_action :Authentication
  def naurah
    render 'naurah/index'
  end

  def naurahcustomer
    render 'accounts/naurah/index'
  end

  def naurahdetail
    render 'naurah/detailpacket'
  end

  def naurahcustomerdetail
    render 'accounts/naurah/detailnaurah'
  end

  # transaksi naurah
  def pembayarannaurah
    render 'accounts/transaksi/naurah/pembayaran'
  end

  def historypembayarannaurah
    render 'accounts/transaksi/naurah/historypembayaran'
  end
end
