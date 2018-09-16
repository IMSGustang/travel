class DownloadController < ApplicationController
  layout 'application_download'

  def download
    render 'download/index'
  end
end
