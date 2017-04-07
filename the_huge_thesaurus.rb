# Wrapper for the huge thesaurus

require 'open-uri'
require 'json'
require 'dotenv'

Dotenv.load

lookup = ARGV.first

def read_url(url)
  raw_output = open(url).read
  content = JSON.parse(raw_output)
  # Puts out the whole result
  puts content
  puts '#' * 10
  # puts out results specific to nouns
  puts content['noun']
  puts '#' * 10
  # puts our verbs
  puts content['verb']
  puts '#' * 10
  #  drills down into nouns and picks out the antonymn of the word
  puts content['noun']['ant']
end
# Using Dotenv to load and keep api keys out of the puclic view
my_secret_key = ENV['my_secret_key']

read_url("http://words.bighugelabs.com/api/2/#{my_secret_key}/#{lookup.downcase}/json")
