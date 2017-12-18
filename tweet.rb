# Gems that need to be installed -> [twitter] & [dotenv]
# The code below will require and use the above installed gem

require 'twitter'
require 'dotenv'
Dotenv.load('.env')

# Passing in Oauth code
# Took advantage of the .env to separate auth keys and token.

client = Twitter::REST::Client.new do |config|
  config.consumer_key        = ENV['consumer_key']
  config.consumer_secret     = ENV['consumer_secret']
  config.access_token        = ENV['access_token']
  config.access_token_secret = ENV['access_token_secret']
end

# Variable called text that accepts concatenated arguments
# Concatenate into a string

text = ARGV.join(' ' + '')
text = text.to_s

if text.empty?
  client.update('Check out the latest Blog post@ http://jeanhuit.github.io')
else
  client.update("#{text} @ http://jeanhuit.github.io")
end
