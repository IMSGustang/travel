class HotelController < ApplicationController
  require 'helper/time'
  require 'uri'
  include VariableHelper
  include ActionView::Helpers::NumberHelper
  def index
    slider = JSON.parse(RestClient.get api_url + "slider2", {
        'Accept' => 'application/json',
        'x-kategori' => 'hotel'
    })

    # request token kalo belum login, token ini harus di kirim terus selama pencarian
    unless session[:acc_token]
      token = JSON.parse(RestClient.get api_url + 'ppob/hotel/get-token', {'Accept' => 'application/json', })
      puts "token hotel: #{token}"
      session[:hotel_token] = token['token']
    end

    @data_slider = slider['data']
    render 'UI/hotel/index'
  end

  def listhotel
    render 'UI/hotel/searchinghotel'
  end

  def cari_detail_hotel
    
  end

  def detailhotel
    begin
      # data = JSON.parse(RestClient.get params[:redirect], {params: params.except(:redirect).as_json, headers: {}})
      # render 'UI/hotel/detailhotel', locals: { data: data}
      res = RestClient.get cookies[:hotel_uri], {

      }
      @data = JSON.parse(res)
      render 'UI/hotel/detailhotel', locals: { data: @data}
    rescue Exception => e
      if params['debug'] == 'true'
        render json: JSON.pretty_generate(Api::HelperController::Error(e, request.original_url, session));
      else
        render '/errors/500', layout: 'application_errors'
      end
    end
  end

  def autocomplete
    begin
      if session[:acc_token]
        url = api_url + "/ppob/hotel/search-autocomplete?q=#{params[:search]}"
      else
        url = api_url + "/ppob/hotel/search-autocomplete?q=#{params[:search]}&token=#{session[:hotel_token]}"
      end

      res = RestClient.get url,{
        'Authorization' => "Bearer #{session[:acc_token]}"
      }

      puts res
      render json: JSON.parse(res)
    rescue Exception => e
      if params['debug'] == 'true'
        render json: JSON.pretty_generate(Api::HelperController::Error(e, request.original_url, session));
      else
        render '/errors/500', layout: 'application_errors'
      end
    end
  end

  def cari_hotel
    begin
      params[:startdate] = TimeFormat::indonesiaCustom(params[:startdate], {:format => 'hbt', :operator => '/', :locale => 'en'})
      params[:enddate] = TimeFormat::indonesiaCustom(params[:enddate], {:format => 'hbt', :operator => '/', :locale => 'en'})
      unless session[:acc_token]
        params[:token] = session[:hotel_token]
      end

      puts params[:token]
      data = JSON.parse(RestClient.get PpobHelper.api_url + "hotel/search", {params: params.as_json, headers: {'Authorization' => "Bearer #{session[:acc_token]}"}})
      puts data
      @url = params.to_s
      if params['abutest'] == 'true'
        render json: ['data' => data]
      else
        render 'UI/hotel/searchinghotel', locals: { data: data}
      end
    rescue Exception => e
      if params['debug'] == 'true'
        render json: JSON.pretty_generate(Api::HelperController::Error(e, request.original_url, session));
      else
        render '/errors/500', layout: 'application_errors'
      end
    end
  end

  def cari_hotel_js
    begin
    replacment_finder = [
        {:finder => '{', :replacement => ''},
        {:finder => '}', :replacement => ''},
        {:finder => '[', :replacement => ''},
        {:finder => ']', :replacement => ''},
        {:finder => ']', :replacement => ''},
        {:finder => '"', :replacement => ''},
        {:finder => '=>', :replacement => '='},
        {:finder => ', ', :replacement => '&'},
        {:finder => '/', :replacement => '-'}
      ]
      @array_url = params['url']
      replacment_finder.each do |replace|
        @array_url = @array_url.to_s.gsub(replace[:finder], replace[:replacement])
      end
      # data = RestClient.get api_url + '/ppob/hotel/search?q=Indonesia&startdate=2012-06-11&night=1&enddate=2012-06-12&room=1&adult=3&child=0&token={{tiket_token}}&output=json', {
      data_api = RestClient.get api_url + '/ppob/hotel/search?' + URI.escape(@array_url) + "#{params['params_added']}" + "&page=#{params[:page]}", {

      }
      data = JSON.parse(data_api)['results']['result']
      html_array = []
      numb = 0
      data.each do |item|
        star = []
        for i in 0..item['star_rating'].to_i
          star[i] = '<i class="ion-android-star"></i>'
        end

        html_array[numb = numb + 1] = [
          '<div class="card w-packet-table mb-2">',
          '<table class="table table-paket m-0">',
          '<tr>',
          '<td class="w-packet__tablebody">',
          '<div class="media">',
          '<div class="img-thumbnail img-thumbnail-hotel">',
          '<img src="'+item['photo_primary'].gsub('.sq2.', '.m.')+'" class="images-product images-product-hotel d-flex align-self-center mr-3"></img>',
          '</div>',
          '<div class="media-body">',
          '<p class="item-link item-line mt-2">',
          item['name'],
          '</p>',
          '<p class="packet-rate mb-0 mt-2">',
          star,
          '</p>',
          '<p class="card-text packet-city m-0">',
          item['regional'],
          '</p>',
          if item['tripadvisor_avg_rating']
            '<p class="tripadvisor mb-0"><img src="'+item['tripadvisor_avg_rating']['image_url']+'" style="height: 12px;margin-top: -2px"></img>'+item['tripadvisor_avg_rating']['review_count']+'</p>'
          end,
          '</div>',
          '</div>',
          '</td>',
          '<td width="200" class="c-packet__tablefooter">',
          '<h2 class="packet-price mt-1 mb-3 text-right">',
          'IDR ' + "#{number_with_delimiter(item['total_price'].to_i)}",
          '</h2>',
          '<a href="/rincian-hotel/'+item['province_name'].gsub(' ', '-')+'/'+item['regional'].gsub(' ', '')+'/'+item['name'].gsub(' ', '-')+'" class="btn btn-block btn-danger text-uppercase" onclick="document.cookie = \'hotel_uri='+item['business_uri']+'\'" target="_blank">',
          'Rincian Hotel',
          ' </a>',
          '</td>',
          '</tr>',
          '</table>',
          '</div>'
        ].join(" ")
      end
      # Pagination Condition
      if "#{params[:page]}".to_i < JSON.parse(data_api)['pagination']['lastPage']
        page = JSON.parse(data_api)['pagination']['current_page'].to_i + 1
        if page == JSON.parse(data_api)['pagination']['lastPage'].to_i
          page_finish = true
        else
          page_finish = false
        end
      end
      render json: {:html => html_array, :total_data => numb, :page => page, :total_page => JSON.parse(data_api)['pagination']['lastPage'], :page_finish => page_finish}
      urls = URI(params['url_added'])
    rescue Error => e
      if params['debug'] == 'true'
        render json: JSON.pretty_generate(Api::HelperController::Error(e, request.original_url, session));
      else
        render '/errors/500', layout: 'application_errors'
      end
    end
  end
end