module Error
	def self.validator(code)
		if code == 500
			return '/'
		end
	end

	def self.log(error, url)
		open('public/error_log.txt', 'a+') do |f|
	      f.puts "-----------------------------------"
	      f.puts "|			ERROR LOG				|"
	      f.puts "-----------------------------------"
	      f.puts Time.new
	      f.puts "----------------------------------"
	      f.puts error.to_s
	      f.puts "----------------------------------"
	      f.puts url.to_s
	      f.puts ""
	    end
	end

	def self.redirect(status)
		if status == 400
			return 'errors.400'
		elsif status == 404
			return 'errors.404'
		elsif status == 500
			return 'errors.500'
		end
	end

	def self.code(code)
		if code == 200
			return "success"
		else
			return "fails"
		end
	end
end