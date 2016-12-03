module HipChatCli
  class Application
    def initialize(args)
      @options, @msg = parse_options(args)
    end

    def run
      fail "Child class must implement this method"
    end

    def parse_application_specific_options
      fail "Child class must implement this method"
    end

    def help
      @help
    end

    def parse_options(app:, argv:)
      options = {
        username: ENV['HIPCHAT_API_USERNAME'] || "API Client",
        token: ENV['HIPCHAT_API_TOKEN'] || nil
      }

      parser = OptionParser.new
      parser.banner = "Usage: hipchat_notify [OPTIONS] message"
      parser.separator  ""
      parser.separator  "Options"

      parser.on("-t","--token API_TOKEN","[required] The API token for HipChat") do |token|
        options[:token] = token
      end

      parser.on("-u","--user USERNAME","The name of the sender. Default: API Client") do |username|
        options[:username] = username
      end

      parser.on("-h","--help","help") do
        puts parser.to_s
        exit 0
      end

      parse_application_specific_options(parser, options)

      @help = parser.to_s

      message = parser.parse(argv).join(' ')
      message = STDIN.read if message.nil? || message == ""

      [options, message]
    end
  end
end
