module Encryption
	def self.hmac_secret
		@hmac_secret = 'fdb629dd543caa0cb993aeef2e8a0b83'
		return @hmac_secret
	end
	def self.encode(payload)
	    token = JWT.encode payload, self.hmac_secret, 'HS256'
	    return token
	end

	def self.decode(token)
		decoded = JWT.decode token, self.hmac_secret, true, { algorithm: 'HS256' }
		return decoded
	end
end