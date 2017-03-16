# Wrapper for the owlbot dictionary API

require 'open-uri'
require 'json'

# Allows you to pass word to lookup as an argument

lookup = ARGV.first
# Function to read url and parse output
def read_url(url)
  raw_output = open(url).read
  content = JSON.parse(raw_output)
  puts content
end

# Base url for queries to the owlbot,accepts arguement and sets format to json.
# format could also be set to "api"

read_url("https://owlbot.info/api/v1/dictionary/#{lookup}?format=json")
