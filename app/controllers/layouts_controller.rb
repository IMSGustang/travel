class LayoutsController < ApplicationController
  def index
     render template: 'index'
  end

  def penambahanbiaya
    if mobile_device?
      render 'mobile/sites/pages/penambahanbiaya/index', layout: 'application_mobile'
    else
      render 'additional_costs/index'
    end
  end
end