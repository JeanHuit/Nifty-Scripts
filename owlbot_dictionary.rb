# Wrapper for the owlbot dictionary API
require 'open-uri'
require 'json'

lookup = ARGV.first

def read_url(url)
  raw_output = open(url).read
  content = JSON.parse(raw_output)
  puts content
end

read_url("https://owlbot.info/api/v1/dictionary/#{lookup}?format=json")
