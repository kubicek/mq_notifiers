require 'shout-bot'

module Notifiers
  class Console < Notifier

    def self.topic_key
      "console"
    end

    def self.perform_notification(payload)
      puts "MSG: #{payload['message']}"
    end

  end
end

Notifiers::Console.perform  