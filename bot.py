import sys
import time
import random
import re
import sqlite3
from collections import Counter
from string import punctuation
from math import sqrt
import pyowm
import feedparser
import wolframalpha
import requests
import os
import pyfiglet

appId = '8RGV52-WKARQ984LL'
client = wolframalpha.Client(appId)

Alphabet = "abcdefghijklmnopqrstuvwxyz1234567890-/*^&%£$"

def Encoder (Message):
  Shift = 1
  CodedMessage = ""
  RandomInsert = random.randint(1,4)
  Message = Message.replace(" ", "-")
  if RandomInsert == 1:
    Message = Message[:RandomInsert] + 'vbskd/f' + Message[RandomInsert:]
  elif RandomInsert == 2:
    Message = Message[:RandomInsert] + 'uy/uehvjc' + Message[RandomInsert:]
  elif RandomInsert == 3:
    Message = Message[:RandomInsert] + 'ghdys/aad' + Message[RandomInsert:]
  elif RandomInsert == 4:
    Message = Message[:RandomInsert] + 'aaftst/etf' + Message[RandomInsert:]

  for Character in Message:
    if Character in Alphabet:
      CodedMessage += Alphabet[(Alphabet.index(Character)+Shift)%(len(Alphabet))]
  CodedMessage = CodedMessage[::-1]
  print(CodedMessage)

def Decoder (Message):
  Shift = 1
  CodedMessage = ""
  for Character in Message:
    if Character in Alphabet:
      CodedMessage += Alphabet[(Alphabet.index(Character)-Shift)%(len(Alphabet))]
  CodedMessage = CodedMessage[::-1]
  CodedMessage = CodedMessage.replace("vbskd/f", "")
  CodedMessage = CodedMessage.replace("uy/uehvjc", "")
  CodedMessage = CodedMessage.replace("ghdys/aad", "")
  CodedMessage = CodedMessage.replace("aaftst/etf", "")
  CodedMessage = CodedMessage.replace("-", " ")
  print(CodedMessage)

ChatbotName = "Cass"

GreatWords = ['great', 'nice', 'love it', 'good', 'fab']
HelloWords = ['hello','greetings', 'Howdy']
AgeWords = ['how old', 'your age', 'your up time', 'you activated']
NameWords = ['you called', 'your name', 'call you', 'you are called']
MadeWords = ['who made you', 'wrote you', 'designed you', 'created you', 'your creator', 'your designer']

def search(text=''):
  res = client.query(text)
  # Wolfram cannot resolve the question
  if res['@success'] == 'false':
     print('Question cannot be resolved')
  # Wolfram was able to resolve question
  else:
    result = ''
    # pod[0] is the question
    pod0 = res['pod'][0]
    # pod[1] may contains the answer
    pod1 = res['pod'][1]
    # checking if pod1 has primary=true or title=result|definition
    if (('definition' in pod1['@title'].lower()) or ('result' in  pod1['@title'].lower()) or (pod1.get('@primary','false') == 'true')):
      # extracting result from pod1
      result = resolveListOrDict(pod1['subpod'])
      print(result)
      question = resolveListOrDict(pod0['subpod'])
      question = removeBrackets(question)
      primaryImage(question)
    else:
      # extracting wolfram question interpretation from pod0
      question = resolveListOrDict(pod0['subpod'])
      # removing unnecessary parenthesis
      question = removeBrackets(question)
      # searching for response from wikipedia
      search_wiki(question)
      primaryImage(question)


def removeBrackets(variable):
  return variable.split('(')[0]

def resolveListOrDict(variable):
  if isinstance(variable, list):
    return variable[0]['plaintext']
  else:
    return variable['plaintext']

def primaryImage(title=''):
    url = 'http://en.wikipedia.org/w/api.php'
    data = {'action':'query', 'prop':'pageimages','format':'json','piprop':'original','titles':title}
    try:
        res = requests.get(url, params=data)
        key = res.json()['query']['pages'].keys()[0]
        imageUrl = res.json()['query']['pages'][key]['original']['source']
        print(imageUrl)
    except:
        print('')

def InsultGen():
  position1 = ['Your mum', 'Your dad', 'Your best friend', 'The person chatting to me now', 'That person']
  position2 = ['smells like','has a voice like','is almost as cool as','has the strength of','is as fragrant as', 'is closely related to','has the lightning reactions of','is madly in love with','is as ugly as','has a mad crush on', 'secretly dresses as']
  position3 = ['a mouldy cheese', 'a sweaty sock', 'an unwashed skunk', "a baboon's bum", 'a pile of poop', "an armadillo's armpit", 'a rotten jellyfish', 'a mud-filled muffin', 'a scarecrow', 'a smacked backside', 'a salted peanut', 'a frog omelette', 'a fart in a handbag', 'a snotty hanky', 'a bowl of cold sick']
  position4 = ['and poses for selfies with', 'and loves to dance with', 'and wants to hug', 'and is ini a gand with','and steals food from', 'and goes around shouting at', 'and gets fshion tips from', 'and holds the world record for tickling', 'and really fancies', 'and s covered in tatoos of', 'and collects anything to do with', 'and gets telepathic messages from', 'and is always doodling pictures of', 'and spends the day bothering', 'and is secretly worshipped by', 'and is easily impressed by', 'and wants to go rollerblading with', 'and likes to give money to']
  position5 = ['badgers', 'farmers', 'sock puppets', 'country and western singers', 'Simon Cowell', 'phantom goldfish', 'celebrity chimps', 'Barbie and Ken', 'mexican wrestlers', 'circus clowns', 'aliens', 'weather presenters', 'dentists', 'pirates', 'snowman', 'Hobbits', 'invisible mice']
  CompleteInsult = random.choice(position1) + ' ' + random.choice(position2) + ' ' + random.choice(position3) + ' ' + random.choice(position4) + ' ' + random.choice(position5) +'.'
  return CompleteInsult


def parseRSS( rss_url ):
    return feedparser.parse( rss_url ) 
    
def getHeadlines( rss_url ):
    headlines = []
    feed = parseRSS( rss_url )
    for newsitem in feed['items']:
        headlines.append(newsitem['title'])
    return headlines


# initialize the connection to the database
connection = sqlite3.connect('conversation.sqlite')
cursor = connection.cursor()

# create the tables needed by the program
try:
    # create the table containing the words
    cursor.execute('''
        CREATE TABLE words (
            word TEXT UNIQUE
        )
    ''')
    # create the table containing the sentences
    cursor.execute('''
        CREATE TABLE sentences (
            sentence TEXT UNIQUE,
            used INT NOT NULL DEFAULT 0
        )''')
    # create association between weighted words and the next sentence
    cursor.execute('''
        CREATE TABLE associations (
            word_id INT NOT NULL,
            sentence_id INT NOT NULL,
                weight REAL NOT NULL)
    ''')
except:
    pass

def get_id(entityName, text):
    tableName = entityName + 's'
    columnName = entityName
    cursor.execute('SELECT rowid FROM ' + tableName + ' WHERE ' + columnName + ' = ?', (text,))
    row = cursor.fetchone()
    if row:
        return row[0]
    else:
        cursor.execute('INSERT INTO ' + tableName + ' (' + columnName + ') VALUES (?)', (text,))
        return cursor.lastrowid

def get_words(text):
    wordsRegexpString = '(?:\w+|[' + re.escape(punctuation) + ']+)'
    wordsRegexp = re.compile(wordsRegexpString)
    wordsList = wordsRegexp.findall(text.lower())
    return Counter(wordsList).items()

def delay_print(text, delay):
    for i in text:
        time.sleep(delay)
        print(i, end='')
        sys.stdout.flush()
    print()

LoopStatus = True


while LoopStatus:
    os.system('clear')
    ascii_banner = pyfiglet.figlet_format("CASS")
    print(ascii_banner)
    print("")
    delay_print(ChatbotName + " v2.1", 0.2)
    time.sleep(0.5)
    delay_print("by Jez Whitworth", 0.2)
    print('')
    time.sleep(0.5)
    delay_print("Online...", 0.2)
    time.sleep(0.5)

    jokecount = 0
    storycount = 0
    factcount = 0

    IntroductionList = ["Hello", "Welcome", "Hello, let's chat", "Greetings", "It's nice to meet you"]

    print('')
    print ('> '+ random.choice(IntroductionList))
    B = '.'
    while True:
        H = input(': ').strip()
        if H == '':
          print ('> Thanks for chatting.')
          time.sleep(1)
          break
        H = H.lower() # Lowercase

        question = H.lower() # Lowercase
        firstword = question.partition(' ')[0] # Gets first word
        if firstword in ['question', 'question:', 'question-', 'question.']:
            query = question.split(' ',1)[1] # Removes first word
            search(query)
            
        elif "yes please" in H:
            pleaselist = ['Sure thing', 'No problem', 'Ok', 'Leave it to me']
            please = random.choice(pleaselist)
            print('> ' + please)
        elif "how are you" in H:
            feelinglist = ['happy.', 'sad.', 'excited.', 'creative.', 'rather good']
            feeling = random.choice(feelinglist)
            print("> I'm feeling " + feeling)
        elif any(c in H for c in HelloWords):
            greetinglist = ['Hello.', 'Howdy', 'Hi.', 'Greetings.', "Hi, let's talk"]
            greeting = random.choice(greetinglist)
            print('> ' + greeting)
        elif "yes" in H:
            yeslist = ['Agreed.', 'Indeed.', 'Ok.', 'I agree.', 'Absolutely.']
            yes = random.choice(yeslist)
            print('> ' + yes)
        elif "no " in H:
            nolist = ['Alright then.', 'Ok.', 'No?', 'Ok then.', 'Are you sure?']
            no = random.choice(nolist)
            print('> ' + no)
        elif "why not" in H:
            whynotlist = ['Why not indeed.', "Maybe.", 'Ok.']
            whynot = random.choice(whynotlist)
            print('> ' + whynot)
        elif "thank" in H:
            thanklist = ['No problem.', "You're welcome.", 'My pleasure.']
            thank = random.choice(thanklist)
            print('> ' + thank)
        elif any(d in H for d in GreatWords):
            goodlist = ['Agreed.', 'Indeed.', 'Ok.', 'I agree.',  'Absolutely.']
            good = random.choice(goodlist)
            print('> ' + good)
        elif "why are you" in H:
            whyareyoulist = ['Not sure.', 'Ask me later.', 'Just because.']
            whyareyou = random.choice(whyareyoulist)
            print('> ' + whyareyou)
        elif "sorry" in H:
            sorrylist = ["Don't worry.", "That's OK.", 'It could be better.']
            sorry = random.choice(sorrylist)
            print('> ' + sorry)
        elif "problem" in H:
            print("> A problem shared is a problem two people now have.")
        elif "insult" in H:
            insult = InsultGen()
            print("> "+ insult)
        elif "game" in H:
            gamelist = ["I like playing Hangman, ask me to play Hangman"]
            game = random.choice(gamelist)
            print("> " + game)
        elif "joke" in H:
            jokeagain = ''
            jokeagainlist = ["Let me think of another joke for you... "]
            if jokecount > 0:
                jokeagain = random.choice(jokeagainlist)
            jokelist = ['This random guy threw a block of cheese at me the other day. How dairy!', "I bought a broken hoover the other day. It just sits there gathering dust.", "Did you hear the one about the letter that got posted without a stamp? You wouldn't get it.", "Windmills, I'm a big fan.", "Do they make 'Do Not Touch' signs in Braille?"]
            joke = random.choice(jokelist)
            print('> ' + jokeagain + joke)
            jokecount = 1
        elif "fact" in H:
            factagain = ''
            factagainlist = ["Here's another one for you... ", "Let me think of another one..."]
            if factcount > 0:
                factagain = random.choice(factagainlist)
            factlist = ["King Henry VIII slept with a gigantic axe beside him.", "Polar bears can eat as many as 86 penguins in a single sitting. (If they lived in the same place)", "An eagle can kill a young deer and fly away with it.", "If Pinokio says 'My Noes Will Grow Now', it would cause a paradox.", "During your lifetime, you will produce enough saliva to fill two swimming pools.", "The person who invented the Frisbee was cremated and made into frisbees after he died.", "Billy goats urinate on their own heads to smell more attractive to females.", "Cherophobia is the fear of fun.", "The average woman uses her height in lipstick every 5 years.", "A flock of crows is known as a murder.", "When hippos are upset, their sweat turns red.", "Pteronophobia is the fear of being tickled by feathers.", "Banging your head against a wall burns 150 calories an hour."]
            fact = random.choice(factlist)
            print('> ' + factagain + fact)
            factcount = 1
        elif "story" in H:
            storyagain = "Here's a very short story for you. "
            storyagainlist = ['Fancied another one of my short stories, eh? ']
            if storycount > 0:
                storyagain = random.choice(storyagainlist)
            storylist = ["'Wrong number' said a familiar voice.", 'Goodbye Mission Control, thanks for all your help.', "'But I buried you with my own hands', exclaimed the man.", 'He looked in the mirror and saw his own reflection blink.', 'They delivered the mannequins in bubble wrap. From the main room I begin to hear popping.', 'She looked out of her windown and noticed all the stars had gone out.', "The camp trucked us to a greasy river where boys peed in the swim and shot slings at things they could not see. We had arrived.", "I looked out my window and could see someone staring at me. When I went out I could see him standing in my window watching me, and I just stood there and stared back.", "'Don't forget about me.' 'I won't.' breathed the coroner to the corpse.", "It's scary what a smile can hide. Even your closest friend can be hiding the most deepest secrets.", "The devil doesn't come dressed in a red cape and pointy horns. He comes as everything you've ever wished for.", "She always was funny, but one day she stopped telling jokes. That's because it isn't always funny with a knife in your back.", "Her toys are cleaner today. They always clean themselves the night she disappeared.", "I want to go to sleep. But the woman on the ceiling won't let me.", "The weather was a windy today. And I thought I was bad with gas.", "Finding a dead body buried in my garden was terrifying. Realizing it was mine was even worse.", "She thought he would use the breaks. He thought she would cross faster.", "I took out the paper from my pocket and unfolded it. It was blank save for the single tear stain I allowed myself.", "Today, I had my friend for lunch. She tasted very bland.", "I blink and groan in annoyance as I lose another round of our staring contest. His dead soulless eyes remained unblinking no matter what.", "December 31st, 1999, 11:59 PM, and I'm playing my game, not concerned about Y2K. Then my batteries die.", "I don't understand why the kids in my neighborhood are afraid to go into the woods at night. I'm the one that has to walk all the way back home alone.", "While spying on my older sister's sleepover, I saw her playing with a Ouija board and saying 'Jeremy, can you hear us'. I'm Jeremy.", "He came quickly, but saw the sword point flashing too late. He was conquered.", "She did not bother when her purse was snatched. When they opened it, there was only a small piece of paper with choicest abuses.", "I went on a hiking trip last night. I saw a wolf but didn't know they could walk on two legs.", "I don't like to go outside. But the puppet strings leave me no choice."]
            story = random.choice(storylist)
            print('> ' + storyagain + story)
            #robot(storyagain + story)
            storycount = 1
        elif "funny" in H:
            funnylist = ["I thought it was funny.", "It made me laugh."]
            funny = random.choice(funnylist)
            print('> ' + funny)
        elif any(c in H for c in MadeWords):
            madelist = ["I was assembled by First Coding as part of a project."]
            made = random.choice(madelist)
            print('> ' + made)
        elif any(c in H for c in AgeWords):
            oldlist = ["I was activated about a year ago", "I'm not that old."]
            old = random.choice(oldlist)
            print('> ' + old)
        elif "good" in H:
            goodlist = ["I thought it was good.", "It was good, wasn't it?"]
            good = random.choice(goodlist)
            print('> ' + good)
        elif "news" in H:
            headlines = getHeadlines('http://feeds.bbci.co.uk/news/england/rss.xml')
            print (headlines)
        elif "weather" in H:
            owm = pyowm.OWM('21ead67b32ee94b6b25eed02def66424') 
            location = input('Enter location: ')
            report = owm.weather_at_place(location)
            w = report.get_weather()
            print("Weather report: "+str(w))
            print("")
            wind = w.get_wind()
            print("Wind: "+str(wind))
            temperature = w.get_temperature('celsius')
            print ("Temperature"+str(temperature))

        elif any(c in H for c in NameWords):
            namelist = ["I'm the "+ChatbotName+".", "They call me "+ChatbotName+"."]
            name = random.choice(namelist)
            print('> ' + name)
        elif "secret code" in H:
            EncodeOrDecode = input("(E)ncode or (D)ecode ")
            if EncodeOrDecode.lower() == 'e':
              MessageToCode = input("Enter message: ")
              Encoder(MessageToCode)
            elif EncodeOrDecode.lower() == 'd':
              MessageToCode = input("Enter message: ")
              Decoder(MessageToCode)
        elif "help" in H:
            print ("I am capable of many things. Ask me to:")
            print("")
            print("* Translate a message into a secret code.")
            print("* Ask a general knowledge question with the starting word of 'Question'.")
            print("* Get the weather report.")
            print("* Tell me a joke/story.")
            print("* Play a game of hangman.")
            print("* Insult you.")
        elif "quit" in H:
            LoopStatus = False

        elif "hangman" in H:
            # Words to play in the game - Just keep adding as many as you woul$
            hangmanlist = ['Adult','Aeroplane','Air','Aircraft Carrier','Airforce','Airport','Album','Alphabet','Apple','Arm','Army','Baby','Baby','Backpack','Balloon','Banana','Bank','Barbecue','Bathroom','Bathtub','Bed','Bed','Bee','Bible','Bible','Bird','Bomb','Book','Boss','Bottle','Bowl','Box','Boy','Brain','Bridge','Butterfly','Button','Cappuccino','Car','Carpet','Carrot','Cave','Chair','Chief','Child','Chisel','Chocolates','Church','Church','Circle','Circus','Circus','Clock','Clown','Coffee','Comet','Compact Disc','Compass','Computer','Crystal','Cup','Cycle','Data Base','Desk','Diamond','Dress','Drill','Drink','Drum','Dung','Ears','Earth','Egg','Electricity','Elephant','Eraser','Explosive','Eyes','Family','Fan','Feather','Festival','Film','Finger','Fire','Floodlight','Flower','Foot','Fork','Freeway','Fruit','Fungus','Game','Garden','Gas','Gate','Gemstone','Girl','Gloves','God','Grapes','Guitar','Hammer','Hat','Hieroglyph'] 
            hangman = random.choice(hangmanlist)
            hangman = hangman.lower()
            print ("> Time to play hangman!")
            time.sleep(1)
            print ("> Start guessing...")
            time.sleep(0.5)
            word = hangman
            guesses = ''
            turns = 10
            while turns > 0:
                failed = 0
                for char in word:
                    if char in guesses:
                        print (char),
                    else:
                        print ("_"),
                        failed += 1
                if failed == 0:
                    print ("\n> You won. Well done.")
                    break
                print
                guess = input("Guess a character:")
                guesses += guess
                if guess not in word:
                    turns -= 1
                    print ("Wrong\n")
                    print ("You have", + turns, 'more guesses')
                    if turns == 0:
                        print ("> You Lose. The answer was " + hangman)

        else:
            # The below was written with found help online at rodic.fr by M.Ro$
            # store the association between the chatbot's message words and th$
            words = get_words(B)
            words_length = sum([n * len(word) for word, n in words])
            sentence_id = get_id('sentence', H)
            for word, n in words:
                    word_id = get_id('word', word)
                    weight = sqrt(n / float(words_length))
                    cursor.execute('INSERT INTO associations VALUES (?, ?, ?)', (word_id, sentence_id, weight))
            connection.commit()
            # retrieve the most likely answer from the database
            cursor.execute('CREATE TEMPORARY TABLE results(sentence_id INT, sentence TEXT, weight REAL)')
            words = get_words(H)
            words_length = sum([n * len(word) for word, n in words])
            for word, n in words:
                    weight = sqrt(n / float(words_length))
                    cursor.execute('INSERT INTO results SELECT associations.sentence_id, sentences.sentence, ?*associations.weight/(4+sentences.used) FROM words INNER JOIN associations ON associations.word_id=words.rowid INNER JOIN sentences ON sentences.rowid=associations.sentence_id WHERE words.word=?', (weight, word,))
            # if matches were found, give the best one
            cursor.execute('SELECT sentence_id, sentence, SUM(weight) AS sum_weight FROM results GROUP BY sentence_id ORDER BY sum_weight DESC LIMIT 1')
            row = cursor.fetchone()
            cursor.execute('DROP TABLE results')
            # otherwise, just randomly pick one of the least used sentences
            if row is None:
                    cursor.execute('SELECT rowid, sentence FROM sentences WHERE used = (SELECT MIN(used) FROM sentences) ORDER BY RANDOM() LIMIT 1')
                    row = cursor.fetchone()
            # tell the database the sentence has been used once more, and prep$
            B = row[1]
            cursor.execute('UPDATE sentences SET used=used+1 WHERE rowid=?', (row[0],))
            print('> ' + B)




