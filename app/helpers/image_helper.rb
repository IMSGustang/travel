module ImageHelper
	def self.resize
		image = MiniMagick::Image.open("https://da8hvrloj7e7d.cloudfront.net/imageResource/2017/05/05/1493958560085-80ebb93c5145568f2ce1be221e8a6250.png")
		image.resize "100x100"
		image.format "png"
		image.write "output.png"
	end
end