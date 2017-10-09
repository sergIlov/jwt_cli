module JwtCli
  class KeyNameValidator
    ERROR_MESSAGE = 'Invalid key name!'.freeze
    REGEX = /\A[a-z_]+\z/i
    
    def validate(value)
      raise ValidationError.new(ERROR_MESSAGE) unless REGEX =~ value
    end
  end
end