
## What is this repo? :notebook:
- Currently this repo contains scripts that do several things
- Scripts I find useful after I branch out to test an idea.


## TheOwlBot  - ```owlbot_dictionary.rb``` :memo:
The OwlBot Dictionary API allows developers to get definitions and, in some cases, example sentences for English words. OwlBot searches the internet for English vocabulary definitions and saves them to its database. The Dictionary API is provided free for public use.
- API endpoint : [OwlBot](https://owlbot.info/)
- SSL Support : Yes
- Supported Format : JSON, XML
- Architectural Style :REST

      Usage
      ruby owlbot_dictionary.rb <Word>



## The Huge Thesaurus - ```the_huge_thesaurus.rb``` :memo:
The Huge Thesaurus API allows for a specific number of calls. The difference here is a call outputs 'synonyms', 'antonyms', 'rhymes with' and many other options.
- API endpoint : [BigHugeLabs](https://words.bighugelabs.com)
- SSL Support : Yes
- Supported Format : JSON, XML

        Usage
        ruby the_huge_thesaurus.rb <Word>



## Dictionary test  ```dict_test.rb``` :memo:
Just a sample script that takes in a list of words and checks if they are *real* words, according to TheOwlBot and writes the real words to another text file. Simple enough to understand from the code. No magic there.


## MySQL2Excel  ```mysql2excel.rb``` :memo:
This is a simple script that pulls data from a mysql database or any database for that matter, via sequel.
This then converts, creates and store data in excel format.


## Rise and Set  ```risenset.rb``` :memo:
This is a simple script that takes in location address and gets the sunset and sunrise times for said location.
Nothing special.

## Unshorten  ```unshorten.rb``` :memo:
This is a simple script that takes in a short url/link and unravels it, showing the main long link.
