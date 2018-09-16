class Api::Auth::Sosmed::StaticController < ApplicationController


	def index
    if session[:access_token]
      url = ENV['API_SERVER_URL'] + "/v1/identities"
      response = HTTParty.get(
          url,
          headers: {
              'Authorization' => 'Bearer ' + session[:access_token],
              'Content-Type' => 'application/json', 'Accept' => 'application/json' }
      )

      puts "\n------------------------------\n"
      puts response.body, response.code, response.message
      puts "\n------------------------------\n"

      @identities = response.parsed_response
    end
  end


end
