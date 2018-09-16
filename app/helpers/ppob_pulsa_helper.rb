module PpobPulsaHelper
  require 'rest-client'
  def self.available(request, token)
    productCode = request[:productCode]
    res = JSON.parse(RestClient.get PpobHelper.api_url + 'pulsa/available-new/' + productCode, {Authorization: "Bearer #{token}"})['data']
  end
end
