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

read_url("https://owlbot.info/api/v1/dictionary/#{lookup.downcase}?format=json")

# adding wikipedia search to this
# read_url("https://en.wikipedia.org/w/api.php?action=query
#             &titles=#{lookup.downcase}
#             &prop=revisions&rvprop=content&format=jsonfm&formatversion=2
#             ")
