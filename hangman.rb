def load_words(filename = "words.txt")
  File.readlines(filename).map(&:strip).map(&:downcase).reject(&:empty?)
end

def hangman
  words = load_words
  secret_word = words.sample
  guessed_letters = []
  tries = 5

  puts "Welcome to Hangman!"
  puts "You have #{tries} tries."

  while tries > 0
    # Display word progress
    display_word = secret_word.chars.map { |c| guessed_letters.include?(c) ? c : "_" }.join(" ")
    puts "\nWord: #{display_word}"
    puts "Guessed letters: #{guessed_letters.empty? ? "None" : guessed_letters.join(", ")}"
    puts "Tries left: #{tries}"

    print "Enter a letter or guess the full word: "
    guess = gets.chomp.downcase.strip

    if guess.length > 1
      if guess == secret_word
        puts "Correct! The word was '#{secret_word}'. You win!"
        return
      else
        tries -= 1
        puts " Wrong word guess."
      end
    else
      if guessed_letters.include?(guess)
        puts "You already guessed that letter."
        next
      end

      guessed_letters << guess

      if secret_word.include?(guess)
        puts "✅ Correct letter!"
        if secret_word.chars.all? { |c| guessed_letters.include?(c) }
          puts "🎉 You win! The word was '#{secret_word}'."
          return
        end
      else
        tries -= 1
        puts "Wrong letter."
      end
    end
  end

  puts " Game over! The word was '#{secret_word}'."
end

hangman
