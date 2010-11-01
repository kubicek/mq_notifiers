require 'rubygems'
require 'mq'
require 'json'

AMQP.start(:host => '192.168.1.134') do

  def send_to_irc(message)
    payload = {
      :server=>"irc.gts.cz",
      :room=>"napalm",
      :nick=>"mydeploybot",
#      password=secret \
      :message=>message
    }
    deliver("irc", payload)
  end

  def send_to_console(message)
    payload = { :message=>message }
    deliver("console", payload)
  end
  
  def deliver(notifier, payload)
    MQ.topic('notifications').publish([payload.to_json].pack("m*"), :key => "notifications.#{notifier}")
  end

  send_to_console("Toto je zprava")
  send_to_irc("Toto je zprava")

  AMQP.stop{ EM.stop }
end
