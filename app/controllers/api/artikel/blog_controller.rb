class Api::Artikel::BlogController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :Authentication
  include VariableHelper
  require 'rest-client'
  require 'json'
  require "base64"
  require 'fileutils'
  require 'helper/paginator'
  require 'helper/error'
  layout "application_payments"
  # require 'json'
  # $url = api_url
  @url = VariableHelper.api_url

  def self.kategoriBlog(api_url, token)
    begin
      @res = RestClient.get api_url + "/artikel/blog/kategori", {
          'Authorization' => "Bearer #{token}"
      }
      # Paginator
      @json = JSON.parse(@res)

      return @json
    rescue RestClient::ExceptionWithResponse => err
      if err.response.code == 500
        render '/errors/500', layout: 'application_errors'
      else
        return {:status => false}
      end
    end
  end

  def self.listBlog(api_url, token, per_page = "", page = "")
    begin
      @res = RestClient.get api_url + "/artikel/blog", {
          'Authorization' => "Bearer #{token}",
          'x-per-page' => per_page,
          'x-page' => page
      }
      # Paginator
      @json = JSON.parse(@res)
      @page_html = Paginator::render(@json)

      page = {
          :link_prev => "<a class='page-link btn btn-success' href='?page=#{@page_html[:link_prev]}'>Prev</a>",
          :link_next => "<a class='page-link btn btn-success' href='?page=#{@page_html[:link_next]}'>Next</a>",
          :html => @page_html[:page]
      }

      return data = {:data => @json['data'], :page => page}
    rescue RestClient::ExceptionWithResponse => err
      if err.response.code == 500
        render '/errors/500', layout: 'application_errors'
      else
        return {:status => false}
      end
    end
  end

  def self.detailBlog(api_url, token, per_page = "", page = "", id)
    begin
      @res = RestClient.get api_url + "/artikel/blog/#{id}", {
          'Authorization' => "Bearer #{token}",
          'x-per-page' => per_page,
          'x-page' => page
      }
      # Paginator
      @json = JSON.parse(@res)

      return @json
    rescue RestClient::ExceptionWithResponse => err
      if err.response.code == 500
        render '/errors/500', layout: 'application_errors'
      else
        return {:status => false}
      end
    end
  end
end
