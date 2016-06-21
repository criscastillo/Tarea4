require 'slack-ruby-bot'
require 'rest-client'

def responder(mensaje)
	url = 'https://yoda.p.mashape.com/yoda?sentence=' + mensaje
	respuesta = RestClient.get url, "X-Mashape-Key" => ENV['YODA_KEY'], "Accept" => "text/plain"

	return respuesta.to_s
end

class Bot < SlackRubyBot::Bot
	command 'say' do |client, data, match|
		client.say(text: responder(match['expression'].to_s), channel: data.channel)
	end
end
