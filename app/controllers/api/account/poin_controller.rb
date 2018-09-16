class Api::Account::PoinController < ApplicationController
	skip_before_action :verify_authenticity_token
	include VariableHelper
	require 'rest-client'
	def self.renderPoin(api_url, token)
		begin
			@res = RestClient.get api_url + '/poin', {
				'Authorization' => "Bearer #{token}"
			}
			return JSON.parse(@res)
		rescue RestClient::ExceptionWithResponse => err
			return err.response
		end
	end

	def self.poinReward(api_url, token)
		begin
			@res = RestClient.get api_url + '/reward',{
				'Authorization' => "Bearer #{token}"
			}
			return JSON.parse(@res)
		rescue RestClient::ExceptionWithResponse => err
			return err.response
		end
	end

	def self.history(api_url, token)
		begin
			@res = RestClient.get api_url + '/poin/history-tukar',{
				'Authorization' => "Bearer #{token}"
			}
			return JSON.parse(@res)
		rescue RestClient::ExceptionWithResponse => err
			return err.response
		end
	end

	def tukarPoin
		begin
			@res = RestClient.post api_url + '/poin/tukar', {}, {
					'Authorization' => "Bearer #{session[:acc_token]}",
					'x-id-reward' => params[:id_reward]
				}
			json = JSON.parse(@res)
			redirect_to '/tukar-poin?res=success', :flash => { :message => json['message'], :status => true}
		rescue RestClient::ExceptionWithResponse => err
			json = JSON.parse(err.response)
			redirect_to '/tukar-poin?res=fails', :flash => { :message => json['message'], :status => true}
		end	
	end
end
