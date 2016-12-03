require 'hipchat'

module HipChatCli
  class Message
    def initialize(params)

      %w(room).each do |key|
        raise OptionParser::MissingArgument, "#{key} is a required option" if params[key.to_sym].nil?
      end

      @room     = params[:room]
      @notify   = params[:notify]   || false
      @format   = params[:format]   || 'html'
      @color    = params[:color]    || 'yellow'
      @username = params[:username] || 'API'

      @client = HipChat::Client.new(params[:token1]) if params[:token1]
      @client = HipChat::Client.new(params[:token2], :api_version => 'v2') if params[:token2]
      raise OptionParser::MissingArgument, "Missing token options" unless @client
    end

    def deliver(message)

      raise OptionParser::MissingArgument, "message is required" if message.nil? || message == ''

      @client[@room].send(@username, message, {
          :notify => @notify,
          :message_format => @format,
          :color => @color
        }
      )
    end
  end
end
