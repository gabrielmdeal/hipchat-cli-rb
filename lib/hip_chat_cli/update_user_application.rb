module HipChatCli
  class UpdateUserApplication < Application
    def initialize(argv)
      super(argv)
    end

    def run
      HipChatCli::UpdateUser.new(@options).update(@options[:user])
    end

    def parse_application_specific_options(parser, options)
      parser.on("--new-status", "The new user status to set (away, chat, dnd).") do |new_status|
        options[:user][:new_status] = new_status
      end
    end
  end
end
