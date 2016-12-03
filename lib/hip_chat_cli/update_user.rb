require 'hipchat'

module HipChatCli
  class UpdateUser
    def initialize(params)

      [:username].each do |key|
        raise OptionParser::MissingArgument, "#{key} is a required option" if params[key].nil?
      end
      @username = params[:username]

      # FIXME: This is duplicated in Message.
      @client = HipChat::Client.new(params[:token1]) if params[:token1]
      @client = HipChat::Client.new(params[:token2], :api_version => 'v2') if params[:token2]
      raise OptionParser::MissingArgument, "Missing token options" unless @client
    end

    def update(new_fields)
      user = @client.user(@username).view

      require 'pp'; pp user
    end
  end
end
