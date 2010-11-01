require 'shout-bot'

module Notifiers
  class Irc < Notifier

    def self.topic_key
      "irc"
    end

    def self.perform_notification(payload)
      uri = "irc://#{payload['nick']}@#{payload['server']}:6667/##{payload['room']}"
      ShoutBot.shout(uri) { |channel| channel.say "MSG: #{payload['message']}" }
    end

  end
end

Notifiers::Irc.perform  