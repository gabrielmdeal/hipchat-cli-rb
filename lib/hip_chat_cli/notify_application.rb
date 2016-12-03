module HipChatCli
  class NotifyApplication < Application
    def initialize(argv)
      super(argv)
    end

    def run
      HipChatCli::Message.new(@options).deliver(@msg)
    end

    def parse_application_specific_options(parser, options)
      options[:color] = "yellow"
      options[:notify] = false
      options[:room] = ENV['HIPCHAT_API_ROOM'] || nil

      parser.on("-r","--room ROOM","[required] The room ID to receive the message") do |room|
        options[:room] = room
      end

      parser.on("-f","--format FORMAT","The format of the message. Default: html") do |format|
        options[:format] = format
      end

      parser.on("-c","--color COLOR",'message color: "red", "yellow", "green", "purple", "gray" or "random" (default "yellow")') do |color|
        options[:color] = color if %w(red yellow green purple gray random).include?(color.downcase)
      end

      parser.on("-n","--notify","notify the users in the room about the message") do
        options[:notify] = true
      end
    end
  end
end
