module JwtCli
  class EmailValidator
    ERROR_MESSAGE = 'Invalid email entered!'.freeze
    REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
    
    def validate(value)
      raise ValidationError.new(ERROR_MESSAGE) unless value =~ REGEX
    end
  end
end
