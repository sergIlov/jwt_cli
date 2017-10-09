require 'jwt'

module JwtCli
  class TokenGenerator
    SECRET = 'secret'.freeze
    ALGORITHM = 'none'.freeze
    
    def generate(payload)
      JWT.encode(payload, nil, ALGORITHM)
    end
  end
end