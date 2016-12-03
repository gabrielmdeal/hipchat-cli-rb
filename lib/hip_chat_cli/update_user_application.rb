module HipChatCli
  class UpdateUserApplication < Application
    def initialize(argv)
      super(argv)
    end

    def run
      new_user_values = @options.delete(:new_user_values)
      HipChatCli::UpdateUser.new(@options).update(new_user_values)
    end

    def parse_application_specific_options(parser, options)
      options[:new_user_values] = {
        presence: {}
      }

      parser.on("--new-status-code STATUS_CODE", "The new user status (away, chat, dnd, xa).") do |value|
        options[:new_user_values][:presence][:show] = value
      end
      parser.on("--new-status-message STATUS_MESSAGE", "The new status message.") do |value|
        options[:new_user_values][:presence][:status] = value
      end
    end
  end
end
