# Wrapper for the huge thesaurus

require 'open-uri'
require 'json'
require 'dotenv'

Dotenv.load

lookup = ARGV.first

def read_url(url)
  raw_output = open(url).read
  content = JSON.parse(raw_output)
  puts content
end
my_secret_key = ENV['my_secret_key']

read_url("http://words.bighugelabs.com/api/2/#{my_secret_key}/#{lookup.downcase}/json")
