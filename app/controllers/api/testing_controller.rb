class Api::TestingController < ApplicationController
	def ses
		render json: session.to_hash
	end

	def sesotp
		render json: {'Kode OTP' => session[:otp_code]}
	end

	def numbCreator
		max = 12
		title = [12]
		text = [4, 8]
		timepicker = [4]
		combobox = [4, 6]

		data = [
			{
				:html_format => 'title'
			},
			{
				:html_format => 'timepicker'
			},
			{
				:html_format => 'combobox'
			},
			{
				:html_format => 'combobox'
			},
			{
				:html_format => 'timepicker'
			},
			{
				:html_format => 'text'
			},
			{
				:html_format => 'text'
			},
			{
				:html_format => 'text'
			}
		]

		counter = 0
		data_list = data.count
		data.each do |item|
			if item[:html_format] == 'timepicker'
				if max - counter >= 4
					if counter = counter + timepicker.max <= 8
						# counter = counter + timepicker.max
					end
				else
					counter = counter + timepicker.max
				end
				item[:html_col] = counter
			# elsif item[:html_format] == 'combobox'
			# 	if counter > 8
			# 		counter = counter + combobox.min
			# 	else
			# 		counter = counter + combobox.max
			# 		if counter > combobox.max
			# 			if counter >= 12
			# 				counter = combobox.min
			# 			else
			# 				counter = combobox.max
			# 			end
			# 		end
			# 	end
			# 	item[:html_col] = counter
			# elsif item[:html_format] == 'text'
			# 	if counter > 8
			# 		counter = counter + text.min
			# 	else
			# 		counter = counter + text.max
			# 		if counter > text.max
			# 			if counter >= 12
			# 				counter = text.min
			# 			else
			# 				counter = text.max
			# 			end
			# 		end
			# 	end
			# 	item[:html_col] = counter
			# elsif item[:html_format] == 'title'
			# 	if counter > 8
			# 		counter = counter + title.min
			# 	else
			# 		counter = counter + title.max
			# 		if counter > title.max
			# 			if counter >= 12
			# 				counter = title.min
			# 			else
			# 				counter = title.max
			# 			end
			# 		else
			# 			counter = title.max
			# 		end
			# 	end
			# 	item[:html_col] = counter
			end
		end
		render json: data
		
	end

	def tiket
		info_flight = []
		info_flight = Api::Account::TiketPesawatController.infoPenumpang(session[:acc_token], session[:tiket], '402307289', params['rfi'])
		info_flight_req = []
		info_flight_req << info_flight['required']

		b = []
		strg = ""
		strg_array = []
		info_flight['required'].keys.each do |data|
			if data =~ /(separator)/
				strg = data
				strg_array << data
			else
				strg = strg
			end
			b << {:type => strg, :data => JSON.parse(info_flight_req.to_json)[0][data]}
		end
		grouping = b.group_by { |d| d[:type] }
		a = []
		html_render = []
		counter = 0
		strg_array.each do |rendering|
			grouping[rendering].each do |item|

				#Rendering

				# TYPE LABEL
				if item[:data]['type'] == 'text'
					html_render << {:type => item[:type], :html_format => item[:data]['type'], :html_col => '6', :name => item[:data]['FieldText'], :html => "<p class='card-title mt-0 mb-4'> #{item[:data]['FieldText']} </p>"}
				end

				# TYPE TEXT
				if item[:data]['type'] == 'textbox'
					html_render << {:type => item[:type], :html_format => item[:data]['type'], :html_col => '6', :name => item[:data]['FieldText'], :html => "<input type='text' class='form-control' name='#{item[:data]['FieldText'].gsub(' ', '')}' id='' placeholder='' value=''>"}
				end

				# TYPE TEXT
				if item[:data]['type'] == 'datetime'
					html_render << {:type => item[:type], :html_format => item[:data]['type'], :html_col => '6', :name => item[:data]['FieldText'], :html => "<input type='text' class='form-control datetime' name='#{item[:data]['FieldText'].gsub(' ', '')}' id='' placeholder='' value=''>"}
				end

				# TYPE DROPDOWN
				if item[:data]['type'] == 'combobox'
					string_or_array = item[:data]['resource'].is_a? String
					if string_or_array == false
						data_resource = item[:data]['resource']
					else
						data_resource = Api::Account::TiketPesawatController.listCountryForRenderToHtml(session[:acc_token], session[:tiket])
						# render json: data_resource and return
					end
					resources = data_resource
					resources_html = []
					resources.each do |resources_item|
                        resources_html << "<option value='#{resources_item['id']}' title='Out of Stock'>#{resources_item['name']}</option>"
                    end
					html = "<select id='dewasa' name='#{item[:data]['FieldText']}' class='prettydrop'> <option value='' title='Out of Stock' disabled>Pilih #{item[:data]['FieldText']}...</option>" + resources_html.join(' ') +"</select>"
					html_render << {:type => item[:type], :html_format => item[:data]['type'], :html_col => '6', :name => item[:data]['FieldText'], :html => html}
				end
				# a << item
			end
		end
		data_html = html_render.group_by {|a| a[:type]}

		tiket = []
		strg_array.each do |rendering|
			tiket << {:total => data_html[rendering].count, :data => data_html[rendering]}
		end
		@tiket = tiket
		# render json: @tiket
		render "accounts/evoucher/tiket-pesawat/book-test", layout: 'application_payments'
	end


	def dumperCode()
		begin
			backtrace 
		rescue Exception => e
			if params['debug'] == 'true'
				render json: Api::HelperController::Error(e, request.original_url, session);
			else
				render '/errors/500', layout: 'application_errors'
			end
		end
	end

	def banq
		return 'aaa'
	end

	def developerTeam
		json = {
			ui: {
				name: 'Gustang',
				position: 'UI Design'
			},
			frontend: [
				{
					name: 'Dimas Adi Satria',
					position: 'API Frontend'
				},
				{
					name: 'Ari Maulana',
					position: 'API Frontend'
				},
				{
					name: 'Wanda Riswanda',
					position: 'Api Frontend'
				}
			]
		}
		render json: json
	end
end
