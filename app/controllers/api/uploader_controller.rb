class Api::UploaderController < ApplicationController
	def uploader(files)
	 	uploader = AvatarUploader.new
		uploader.store!(files)
		uploader.retrieve_from_store!('')

		image = File.open("#{Rails.public_path}/temp-file/#{uploader.identifier}") {|img| img.read}
		encoded_image = Base64.encode64 image

		image = MiniMagick::Image.open("#{Rails.public_path}/temp-file/#{uploader.identifier}")

		base64_image = "data:image/#{image.type};base64,#{encoded_image}"
		return base64_image.gsub!(/\s+/, '')
	end
end
