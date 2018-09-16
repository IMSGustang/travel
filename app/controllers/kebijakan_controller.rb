class KebijakanController < ApplicationController
  layout 'application_abutours'

  def syaratketentuan
    render 'UI/kebijakanAbu/syarat&ketentuan'
  end

  def kebijakanprivasi
    render 'UI/kebijakanAbu/kebijakanprivasi'
  end
end
