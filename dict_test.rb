require 'open-uri'
require 'json'

def write_word
  filename = 'words.txt'
  arr_words = []
  txt = File.open(filename, 'r')
  txt.each_line { |line| arr_words.push(line) }
  txt.close
  arr_words.each { |word| dict(word.strip) }
  # dict(arr_words[593].strip)
end


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
