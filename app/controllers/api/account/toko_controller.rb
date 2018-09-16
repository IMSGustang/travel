class Api::Account::TokoController < ApplicationController
	skip_before_action :verify_authenticity_token
	include VariableHelper
	require 'rest-client'
  require 'base64'

  def self.render_detail_toko(api_url, token)
    begin
      @res = RestClient.get api_url + '/users/toko', {
          'Authorization' => "Bearer #{token}",
          'Accept' => 'application/json',
      }
      @json = JSON.parse(@res)
      if @json && @json['status'] == 200
        return @json['data']
      end
    rescue RestClient::ExceptionWithResponse => err
      # puts "ERROR: #{err.response}"
      return {:data => nil}
    end
  end

  def create_or_update_toko
    if params['banner'].present?
      uploader = AvatarUploader.new
      uploader.store!(params[:banner])
      uploader.retrieve_from_store!('')
      image = File.open("#{Rails.public_path}/temp-file/#{uploader.identifier}") {|img| img.read}
      encoded_image = Base64.encode64 image
      image = MiniMagick::Image.open("#{Rails.public_path}/temp-file/#{uploader.identifier}")
      base64_banner = "data:image/#{image.type};base64,#{encoded_image}"
    end
    if params['logo'].present?
      uploader2 = AvatarUploader.new
      uploader2.store!(params[:logo])
      uploader2.retrieve_from_store!('')
      image = File.open("#{Rails.public_path}/temp-file/#{uploader2.identifier}") {|img| img.read}
      encoded_image = Base64.encode64 image
      image = MiniMagick::Image.open("#{Rails.public_path}/temp-file/#{uploader2.identifier}")
      base64_logo = "data:image/#{image.type};base64,#{encoded_image}"
    end

    begin
      res = RestClient.post api_url + '/users/toko', {
          :nama_toko => params[:toko],
          :info => params[:info],
          :catatan => params[:catatan],
          :banner => base64_banner ? base64_banner.gsub!(/\s+/, '') : nil,
          :logo => base64_logo ? base64_logo.gsub!(/\s+/, '') : nil
      },{
          'Authorization' => "Bearer #{session[:acc_token]}",
          'Accept' => 'application/json',
      }
      json = JSON.parse(res)
      Rails.logger.info(json)
      if json && json['status'] == 200
        redirect_to '/pengaturan-toko?res=success'
      else
        redirect_to '/pengaturan-toko?res=fail'
      end

    rescue RestClient::ExceptionWithResponse => e
      redirect_to '/pengaturan-toko?res=fail'
    end

  end

end
