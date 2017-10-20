# Need the following to make http request and read/parse
# JSON formats.

require 'open-uri'
require 'json'

# This block of code is inapropriately named. It rather reads each line of a txt
# file and writes to an array. It strips the words of extra spaces

def write_word
  filename = 'words.txt'
  arr_words = []
  txt = File.open(filename, 'r')
  txt.each_line { |line| arr_words.push(line) }
  txt.close
  arr_words.each { |word| dict(word.strip) }
end

# The following block, takes each word from the array and verifies it
# against the owl dictionary.
# The final output is another text file with defineable words.

def dict(lookup)
  url = "https://owlbot.info/api/v1/dictionary/#{lookup.downcase}?format=json"
  raw_output = open(url).read
  content = JSON.parse(raw_output)
  puts content[0]['defenition']
rescue NoMethodError
  puts 'bad word'
rescue OpenURI::HTTPError
  puts 'bad word'
else
  newfile = 'defined.txt'
  File.open(newfile, 'a') { |to_append| to_append.write("#{lookup}\n") }
end

write_word
