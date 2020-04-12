# Wrapper for the owlbot dictionary API

require 'open-uri'
require 'json'
require 'dotenv'

Dotenv.load

# Function to read url and parse output
def read_url(url)
  key = ENV['owls_key']
  raw_output = URI.open(url, 'Authorization' => "Token #{key}").read
  content = JSON.parse(raw_output)
  # Using rescue to catch errors that may pop up
rescue NoMethodError
  puts 'bad word'
rescue OpenURI::HTTPError
  puts 'word does not exist, please try another'
else
  puts content
  # content['definitions][0]['type','definition','example','image_url''emoji','pronunciation]
  # content['definitions'][0]['definition'] - for definition alone
end

# Base url for queries to the owlbot,accepts arguement and sets format to json.
# format could also be set to "api"
def start_up
  # Allows you to pass word to lookup as an argument

  lookup = ARGV.first
  read_url("https://owlbot.info/api/v4/dictionary/#{lookup.downcase}?format=json")
end

if !ARGV.first
  puts 'syntax: ruby owlbot_dictionary.rb <word>'
else
  start_up
end
