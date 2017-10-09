module JwtCli
  class Main
    def initialize
      @session = nil
    end

    def start
      while running?
        message = read
        if @session.nil?
          process_command(message)
        else
          @session.process(message)
          puts @session.state_message
        end
      end
    end

    private

    def process_command(message)
      case message.to_sym
      when :jwt_me
        start_jwt_me_session
      else
        help
      end
    end

    def start_jwt_me_session
      @session = JwtCli::JwtMeSession.new
      puts 'Starting with JWT token generation.'
      puts @session.state_message
    end

    def help
      puts 'To start JWT token generation type jwt_me'
    end

    def read
      print '$ '
      gets.chomp
    end

    def running?
      @session.nil? || !@session.finished?
    end
  end
end
