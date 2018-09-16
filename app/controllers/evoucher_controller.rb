class EvoucherController < ApplicationController
  def ticketpesawat
    render 'evoucher/tiketpesawat'
  end

  def searchingticket_s1
    render 'evoucher/searchticket_s1'
  end

  def searchingticket_s2
    render 'evoucher/searchticket_s2'
  end

  def pulsa
    render 'evoucher/pulsa'
  end

  def paketdata
    render 'evoucher/paketdata'
  end

  def tokenlistrik
    render 'evoucher/tokenlistrik'
  end

  def vouchergame
    render 'evoucher/vouchergame'
  end
end
