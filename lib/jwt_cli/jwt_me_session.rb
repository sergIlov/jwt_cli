require 'clipboard'

module JwtCli
  class JwtMeSession
    REQUIRED_FIELDS = %w[user_id email].freeze
    WAIT_KEY_STATE = :wait_key
    WAIT_VALUE_STATE = :wait_value
    WAIT_CONTINUE_STATE = :wait_continue
    FINISHED_STATE = :finished
    VALIDATORS = { email: JwtCli::EmailValidator }.freeze
    YES = 'yes'.freeze

    def initialize
      @key = nil
      @storage = {}
      @error = nil
      wait_key!
    end

    def process(message)
      @error = nil
      case @state
      when WAIT_KEY_STATE
        process_key(message)
      when WAIT_VALUE_STATE
        process_value(message)
      when WAIT_CONTINUE_STATE
        process_continue(message)
      end
    rescue => e
      @error = e.message
    end

    def state_message
      @error.to_s + (@error.nil? ? '' : ' ') +
      case @state
      when WAIT_KEY_STATE
        "Enter key #{@storage.size.next}"
      when WAIT_VALUE_STATE
        "Enter #{@key} value"
      when WAIT_CONTINUE_STATE
        'Any additional inputs? (yes/no)'.freeze
      when FINISHED_STATE
        'The JWT has been copied to your clipboard!'
      else
        ''
      end
    end

    def finished?
      @state == FINISHED_STATE
    end

    private

    def process_key(message)
      validate_key(message)
      store_key(message)
      wait_value!
    end

    def process_value(message)
      validate_value(message)
      store_value(message)
      clear_key!
      if required_filled?
        wait_continue!
      else
        wait_key!
      end
    end
    
    def validate_value(message)
      VALIDATORS[@key.to_sym].new.validate(message) if VALIDATORS.key? @key.to_sym
    end
    
    def validate_key(key)
      KeyNameValidator.new.validate(key)
      raise ValidationError("Key #{key} already added") if @storage.key?(key)
    end
    
    def store_value(value)
      @storage[@key] = value
    end
    
    def store_key(key)
      @key = key
    end
    
    def clear_key!
      @key = nil
    end

    def process_continue(message)
      if message == YES
        wait_key!
      else
        finish!
      end
    end

    def required_filled?
      (REQUIRED_FIELDS - @storage.keys).empty?
    end

    def wait_key!
      @state = WAIT_KEY_STATE
    end

    def wait_value!
      @state = WAIT_VALUE_STATE
    end

    def wait_continue!
      @state = WAIT_CONTINUE_STATE
    end

    def finish!
      @state = FINISHED_STATE
      Clipboard.copy TokenGenerator.new.generate(@storage)
    end

    def wait_key?
      @state == WAIT_KEY_STATE
    end

    def wait_value?
      @state == WAIT_VALUE_STATE
    end

    def wait_continue?
      @state == WAIT_CONTINUE_STATE
    end
  end
end