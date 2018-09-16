class MobileController < ApplicationController
  layout 'application_mobile'
  include VariableHelper
  require 'helper/time'
  require 'helper/error'

  def mapprovalumrah
    render '/mobile/sites/pages/umrah/mApproval'
  end

  def mapprovalumrahh
    kode = params[:id_produk]
    @data = Api::Account::PaketUmrahController.renderingDetail(api_url, params[:id_produk], params[:kk], session[:acc_token], params[:bln], params[:th])
    render '/mobile/sites/pages/umrah/mApproval', locals: {kode: kode}
  end

  def mapprovalhaji
    @data = Api::Account::PaketHajiController.renderingDetail(api_url, params[:id_produk], params[:kk], session[:acc_token], params[:bln], params[:th])
    render '/mobile/sites/pages/haji/mApproval'
  end


  # controller pages accounts users
  def mlogin
    render '/mobile/accounts/users/_login/mobileLogin'
  end

  def mRegisters
    render '/mobile/accounts/users/_registers/mobileRegisters'
  end


  # controller pages accounts reset pass
  def mresetpass
    render '/mobile/accounts/users/_resetpass/mobileResetPass'
  end

  def motppass
    render '/mobile/accounts/users/_resetpass/mobileOtpPass'
  end

  def mforgotpass
    render '/mobile/accounts/users/_resetpass/mobileForgotPass'
  end


  # controller payments
  def mpaymentumrahdatabuyer
    render '/mobile/sites/payments/umrah/mobileDataBuyer'
  end

  def mpaymentumrahbill
    render '/mobile/sites/payments/umrah/mobilePaymentBill'
  end

  # controller otpdeposit
  def otpdepositmobile
    render '/mobile/sites/payments/otp/deposit'
  end

  def invoicemobile
    render '/mobile/transaction/invoice/index'
  end
end
