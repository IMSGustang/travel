class Api::Account::PaketUmrahAgenController < ApplicationController
	include VariableHelper
	require 'rest-client'
	# require 'json'
	# $url = api_url
	@url = VariableHelper.api_url


	def self.rendering(api_url, ses, params_page, debug, x_bulan = nil, x_tahun = nil)
		begin
		@res = RestClient.post api_url + '/produk/partnership', {}, {
			'x-kode-kantor' => '',
			'x-jenis-paket' => '',
			'x-tahun' => x_tahun,
			'x-bulan' => x_bulan,
			'x-per-page' => '10',
			'x-page' => params_page,
			'Authorization' => "Bearer #{ses}", 
			'Accept' => 'application/json'
		}
		@json = JSON.parse(@res)
		# Paginator

		#Link Prev
		if @json['current_page'] > 1
			@link_prev = @json['current_page'] - 1
		else
			@link_prev = @json['current_page']
		end

		# Link Next
		if @json['current_page'] >= 1 and @json['current_page'] < @json['total_pages']
			@link_next = @json['current_page'] + 1
		else
			@link_next = @json['current_page']
		end

		@page_html = []
		# Pagination kurang dari 5
		if @json['current_page'] < 5
			if @json['total_pages'] < 5
				(1..@json['total_pages']).each do |i|
					if i == @json['current_page']
						@page_html << "<li class='page-item active'><a class='page-link' href='?page=#{i}''>#{i}</a></li>"
					else
						@page_html << "<li class='page-item'><a class='page-link' href='?page=#{i}''>#{i}</a></li>"
					end
				end
			else
				(1..5).each do |i|
					if i == @json['current_page']
						@page_html << "<li class='page-item active'><a class='page-link' href='?page=#{i}''>#{i}</a></li>"
					else
						@page_html << "<li class='page-item'><a class='page-link' href='?page=#{i}''>#{i}</a></li>"
					end
				end
			end
					
		end

		# Pagination lebih dari 5
		if @json['current_page'] >= 5
			if @json['current_page'] - 2 != 0

				if @json['current_page'] == @json['total_pages']
					
					(@json['current_page'] - 4..@json['total_pages']).each do |x|
						if x == @json['current_page']
							@page_html << "<li class='page-item active'><a class='page-link' href='?page=#{x}''>#{x}</a></li>"
						else
							@page_html << "<li class='page-item'><a class='page-link' href='?page=#{x}''>#{x}</a></li>"
						end
					end
				elsif @json['current_page'] + 2 > @json['total_pages']
					(@json['current_page'] - 3..@json['total_pages']).each do |x|
						if x == @json['current_page']
							@page_html << "<li class='page-item active'><a class='page-link' href='?page=#{x}''>#{x}</a></li>"
						else
							@page_html << "<li class='page-item'><a class='page-link' href='?page=#{x}''>#{x}</a></li>"
						end
					end
				else
					(@json['current_page'] - 2..@json['current_page'] + 2).each do |x|
					if x == @json['current_page']
						@page_html << "<li class='page-item active'><a class='page-link' href='?page=#{x}''>#{x}</a></li>"
					else
						@page_html << "<li class='page-item'><a class='page-link' href='?page=#{x}''>#{x}</a></li>"
					end
				end
				end

				
			else

			end
		end

		if @json['current_page'] + 2 < @json['total_pages']
			@page_html << "<li class='page-item'><a class='page-link' href='#''>...</a></li>"
			@page_html << "<li class='page-item'><a class='page-link' href='?page=#{@json['total_pages']}''>#{@json['total_pages']}</a></li>"
		end

		page = {
			:link_prev => "<a class='page-link btn btn-success' href='?page=#{@link_prev}'>Prev</a>",
			:link_next => "<a class='page-link btn btn-success' href='?page=#{@link_next}'>Next</a>",
			:html => @page_html
		}
		
		# Debug Mode
		if debug == 'true'
			return page
		elsif debug == 'true2'
			return @json
		else
			return data = {:data => @json['data'], :page => page}
		end
		rescue RestClient::ExceptionWithResponse => err
			return data = {:data => nil}
		end
	end

	def self.renderingDetail(kode, kd_kantor, session, x_bulan, x_tahun)
		begin
		res = RestClient.get @url + '/produk/partnership/' + kode, {
			Authorization: "Bearer #{session}",
			'x-kode-kantor' => kd_kantor,
			'x-tahun' => x_tahun,
			'x-bulan' => x_bulan
		}
		@json = JSON.parse(res)
		return @json
		rescue RestClient::ExceptionWithResponse => err
			@err_respon = JSON.parse(err.response)
			@err_json = {
				:status => false
			}
			return @err_json
		end
	end

	def self.renderingDetailImage(kode, kd_kantor, session)
		begin
		res = RestClient.get @url + '/produk/partnership/' + kode, {
			Authorization: "Bearer #{session}",
			'x-kode-kantor' => kd_kantor
		}
		@json = JSON.parse(res)
			begin
				return @json['umrah_detail']['gambar']
			rescue
				return ""
			end
		rescue RestClient::ExceptionWithResponse => err
			puts err.response
		end
	end

end
