module Paginator
	def self.render(json)
		#Link Prev
		if json['current_page'] > 1
			@link_prev = json['current_page'] - 1
		else
			@link_prev = json['current_page']
		end

		# Link Next
		if json['current_page'] >= 1 and json['current_page'] < json['total_pages']
			@link_next = json['current_page'] + 1
		else
			@link_next = json['current_page']
		end

		@page_html = []
		# Pagination kurang dari 5
		if json['current_page'] < 5
			if json['total_pages'] < 5
				(1..json['total_pages']).each do |i|
					if i == json['current_page']
						@page_html << "<li class='page-item active'><a class='page-link' href='?page=#{i}'>#{i}</a></li>"
					else
						@page_html << "<li class='page-item'><a class='page-link' href='?page=#{i}'>#{i}</a></li>"
					end
				end
			else
				(1..5).each do |i|
					if i == json['current_page']
						@page_html << "<li class='page-item active'><a class='page-link' href='?page=#{i}'>#{i}</a></li>"
					else
						@page_html << "<li class='page-item'><a class='page-link' href='?page=#{i}'>#{i}</a></li>"
					end
				end
			end
					
		end

		# Pagination lebih dari 5
		if json['current_page'] >= 5
			if json['current_page'] - 2 != 0

				if json['current_page'] == json['total_pages']
					
					(json['current_page'] - 4..json['total_pages']).each do |x|
						if x == json['current_page']
							@page_html << "<li class='page-item active'><a class='page-link' href='?page=#{x}'>#{x}</a></li>"
						else
							@page_html << "<li class='page-item'><a class='page-link' href='?page=#{x}'>#{x}</a></li>"
						end
					end
				elsif json['current_page'] + 2 > json['total_pages']
					(json['current_page'] - 3..json['total_pages']).each do |x|
						if x == json['current_page']
							@page_html << "<li class='page-item active'><a class='page-link' href='?page=#{x}'>#{x}</a></li>"
						else
							@page_html << "<li class='page-item'><a class='page-link' href='?page=#{x}'>#{x}</a></li>"
						end
					end
				else
					(json['current_page'] - 2..json['current_page'] + 2).each do |x|
					if x == json['current_page']
						@page_html << "<li class='page-item active'><a class='page-link' href='?page=#{x}'>#{x}</a></li>"
					else
						@page_html << "<li class='page-item'><a class='page-link' href='?page=#{x}'>#{x}</a></li>"
					end
				end
				end

				
			else

			end
		end

		if json['current_page'] + 2 < json['total_pages']
			@page_html << "<li class='page-item'><a class='page-link' href='#'>...</a></li>"
			@page_html << "<li class='page-item'><a class='page-link' href='?page=#{json['total_pages']}'>#{json['total_pages']}</a></li>"
		end

		return {:link_prev => @link_prev, :link_next => @link_next, :page => @page_html}
	end

	def self.renderCustom(json, params)
		#Link Prev
		if json['current_page'] > 1
			@link_prev = json['current_page'] - 1
		else
			@link_prev = json['current_page']
		end

		# Link Next
		if json['current_page'] >= 1 and json['current_page'] < json['total_pages']
			@link_next = json['current_page'] + 1
		else
			@link_next = json['current_page']
		end

		@page_html = []
		# Pagination kurang dari 5
		if json['current_page'] < 5
			if json['total_pages'] < 5
				(1..json['total_pages']).each do |i|
					if i == json['current_page']
						@page_html << "<li class='page-item active'><a class='page-link' href='?page=#{i}#{params}'>#{i}</a></li>"
					else
						@page_html << "<li class='page-item'><a class='page-link' href='?page=#{i}#{params}'>#{i}</a></li>"
					end
				end
			else
				(1..5).each do |i|
					if i == json['current_page']
						@page_html << "<li class='page-item active'><a class='page-link' href='?page=#{i}#{params}'>#{i}</a></li>"
					else
						@page_html << "<li class='page-item'><a class='page-link' href='?page=#{i}#{params}'>#{i}</a></li>"
					end
				end
			end
					
		end

		# Pagination lebih dari 5
		if json['current_page'] >= 5
			if json['current_page'] - 2 != 0

				if json['current_page'] == json['total_pages']
					
					(json['current_page'] - 4..json['total_pages']).each do |x|
						if x == json['current_page']
							@page_html << "<li class='page-item active'><a class='page-link' href='?page=#{x}#{params}'>#{x}</a></li>"
						else
							@page_html << "<li class='page-item'><a class='page-link' href='?page=#{x}#{params}'>#{x}</a></li>"
						end
					end
				elsif json['current_page'] + 2 > json['total_pages']
					(json['current_page'] - 3..json['total_pages']).each do |x|
						if x == json['current_page']
							@page_html << "<li class='page-item active'><a class='page-link' href='?page=#{x}#{params}'>#{x}</a></li>"
						else
							@page_html << "<li class='page-item'><a class='page-link' href='?page=#{x}#{params}'>#{x}</a></li>"
						end
					end
				else
					(json['current_page'] - 2..json['current_page'] + 2).each do |x|
					if x == json['current_page']
						@page_html << "<li class='page-item active'><a class='page-link' href='?page=#{x}#{params}'>#{x}</a></li>"
					else
						@page_html << "<li class='page-item'><a class='page-link' href='?page=#{x}#{params}'>#{x}</a></li>"
					end
				end
				end

				
			else

			end
		end

		if json['current_page'] + 2 < json['total_pages']
			@page_html << "<li class='page-item'><a class='page-link' href='#'>...</a></li>"
			@page_html << "<li class='page-item'><a class='page-link' href='?page=#{json['total_pages']}#{params}'>#{json['total_pages']}</a></li>"
		end

		return {:link_prev => @link_prev, :link_next => @link_next, :page => @page_html}
	end
end