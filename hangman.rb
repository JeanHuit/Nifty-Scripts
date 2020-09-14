# The hangman game 

def retrieve_word
  arr_words = Marshal.load File.read('defined.txt')
  arr_words[rand(arr_words.length)].strip
end

def create_test(num)
  test_array = []
  while num.positive?
    test_array << '_'
    num -= 1
  end
  test_array
end

# def decider(word)
#   num_of_tries = 8
#   word = word.split('')
#   test_word = create_test(word.length)
#   until num_of_tries.zero?
#     guessed_letter = gets.chomp
#     if word.include?(guessed_letter)
#       index_num = word.index(guessed_letter)
#       test_word[index_num] = guessed_letter
#       p test_word.join('')
#     else
#       num_of_tries -= 1
#       puts "Sorry, wrong guess, you have #{num_of_tries} tries left"
#     end
#   end
# end

def start_game
  puts 'Begin Game: You have 8 tries to get the word right'
  puts '**************************************************'
  word = retrieve_word
  puts 'Your word is : ' + '_' * word.length
  decider(word)
  puts 'Your word was: ' + word
end

start_game
