class ErrorsController < ApplicationController
  layout 'application_errors'

  def problems
    render 'errors/303'
  end

  def pageerror
    render 'errors/404'
  end

  def maintenance
    render 'errors/500'
  end

  # def not_found
  #   # render 'errors/not_found'
  #   render json: 'errors' and return
  # end

  def not_found
    render 'errors/404', layout: 'application_errors'
    # render(:status => 404)
  end

  def internal_server_error
    render 'errors/500', layout: 'application_errors'
    # render(:status => 500)
  end

  def limaratus
    # render json: '', status: 500
    render(:status => 500)
  end
end
