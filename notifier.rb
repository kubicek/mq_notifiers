require 'rubygems'
require 'mq'
require 'json'

Signal.trap('INT') { AMQP.stop{ EM.stop } }
Signal.trap('TERM'){ AMQP.stop{ EM.stop } }

module Notifiers
  def self.load_notifiers
    Dir.glob("notifiers/*.rb").each{ |file| require file }
  end

  def self.listen
    AMQP.start(:host => '192.168.1.134') { load_notifiers }
  end

  class Notifier
    def self.perform
      MQ.queue("#{self.topic_key} notifications").bind(MQ.topic('notifications'), :key => "notifications.#{self.topic_key}").subscribe(:ack => true){ |h,payload|
        payload = JSON.load(payload.unpack("m*").first)
        puts payload.inspect
        begin
          perform_notification(payload)
        rescue Exception => e
          puts "CHYBA {#{e.inspect}}"
        else
          h.ack
          puts "ACKed"
        end
      }
    end
  end
end

Notifiers.listen