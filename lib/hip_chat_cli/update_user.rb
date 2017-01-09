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

    def update(new_attrs)
      new_attrs ||= {}
      new_presence = new_attrs.delete(:presence) || {}
      raise OptionParser::MissingArgument, "Not given any fields to update" if new_attrs.empty? && new_presence.empty?

      user = to_hash(@client.user(@username).view)
      user.merge!(new_attrs)
      user[:presence].merge!(new_presence)

      @client.user(@username).update(user)
    end

    def to_hash(user)
      # https://www.hipchat.com/docs/apiv2/method/update_user
      attr_names = [
        :name,
        :roles,
        :title,
        :mention_name,
        :is_group_admin,
        :timezone,
        # :password - can update, but can't view.
        :email
      ]

      user_hash = Hash[attr_names.map { |attr_name| [attr_name, user.method(attr_name).call] }]
      user_hash[:presence] = {}
      if user.presence
        user_hash[:presence][:show] = user.presence[:show]
        user_hash[:presence][:status] = user.presence[:status]
      end

      user_hash
    end
  end
end
