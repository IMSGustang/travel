class StoreController < ApplicationController
  def homestore
    render 'store/home'
  end

  def store
    render 'store/product'
  end

  def detailstore
    if mobile_device?
      render 'mobile/sites/pages/store/mDetailProduct', layout: 'application_mobile'
    else
      render 'store/detailproduct'
    end
  end

  def cart
    render 'store/cart'
  end
end
