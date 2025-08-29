import random

def load_words(filename="words.txt"):
    with open(filename, "r") as f:
        words = [line.strip().lower() for line in f if line.strip()]
    return words

def hangman():
    words = load_words()
    secret_word = random.choice(words)
    guessed_letters = set()
    tries = 5

    print(" Welcome to Hangman!")
    print(f"You have {tries} tries.")

    while tries > 0:
        # Display word progress
        display_word = " ".join([letter if letter in guessed_letters else "_" for letter in secret_word])
        print(f"\nWord: {display_word}")
        print(f"Guessed letters: {', '.join(sorted(guessed_letters)) if guessed_letters else 'None'}")
        print(f"Tries left: {tries}")

        guess = input("Enter a letter or guess the full word: ").lower().strip()

        # Full word guess
        if len(guess) > 1:
            if guess == secret_word:
                print(f" Correct! The word was '{secret_word}'. You win!")
                return
            else:
                tries -= 1
                print(" Wrong word guess.")
        else:
            # Single letter guess
            if guess in guessed_letters:
                print(" You already guessed that letter.")
                continue

            guessed_letters.add(guess)

            if guess in secret_word:
                print(" Correct letter!")
                if all(letter in guessed_letters for letter in secret_word):
                    print(f"🎉 You win! The word was '{secret_word}'.")
                    return
            else:
                print(" Wrong letter.")
                tries -= 1

    print(f" Game over! The word was '{secret_word}'.")

if __name__ == "__main__":
    hangman()
