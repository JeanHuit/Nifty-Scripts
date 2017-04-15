
##What is this repo?
- Currently this repo contains scripts that do several things
- Scripts I find useful after I branch out to test an idea.


##TheOwlBot  - ```owlbot_dictionary.rb```
The OwlBot Dictionary API allows developers to get definitions and, in some cases, example sentences for English words. OwlBot searches the internet for English vocabulary definitions and saves them to its database. The Dictionary API is provided free for public use.
- API endpoint : [OwlBot](https://owlbot.info/)
- SSL Support : Yes
- Supported Format : JSON, XML
- Architectural Style :REST

      Usage
      ruby owlbot_dictionary.rb <Word>



##The Huge Thesaurus - ```the_huge_thesaurus.rb```
The Huge Thesaurus API allows for a specific number of calls. The difference here is a call outputs 'synonyms', 'antonyms', 'rhymes with' and many other options.
- API endpoint : [BigHugeLabs](https://words.bighugelabs.com)
- SSL Support : Yes
- Supported Format : JSON, XML

        Usage
        ruby the_huge_thesaurus.rb <Word>



##Dictionary test  ```dict_test.rb```
Just a sample script that takes in a list of words and checks if they are *real* words, according to TheOwlBot and writes the real words to another text file. Simple enough to understand from the code. No magic there.
