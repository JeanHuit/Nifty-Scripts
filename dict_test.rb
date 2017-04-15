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
