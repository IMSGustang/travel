class AuthController < ApplicationController
  layout 'application_logister'

  def login
    begin
      @res = params['res']
      if session[:otplog] == true
        redirect_to '/app/login-otp'
      else
        
        if mobile_device?
          render 'mobile/accounts/users/_login/mobileLogin', layout: 'application_mobile'
        else
          render 'auth/login'
        end
        
      end
    rescue Exception => e
      if params['debug'] == 'true'
        render json: JSON.pretty_generate(Api::HelperController::Error(e, request.original_url, session));
      else
        render '/errors/500', layout: 'application_errors'
      end
    end
  end

  def registers
    @res = params['res']
    if session[:otpreg] == true
      redirect_to '/app/register-otp'
    else
      if mobile_device?
        render 'mobile/accounts/users/_registers/mobileRegisters', layout: 'application_mobile'
      else
        render 'auth/registers'
      end
    end
  end
  def resetpassword
    @res = params['res']
  	render 'auth/resetpassword'
  end
end
