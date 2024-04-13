##  Sheet 1 Exercise 4 : Dictionary -- That look up for words and  print its german translation
## Insertion and deletion of entry in a dictiory -- in a interactable way

import json

def main():
    while(True):
        print('Look up (1), List (2), New Entry (3), Delete Entry (4), Exit (0)?')
        try:
            opt = int(input('--> '))
            dictionary = dict(load_dictionary())
            if opt==1 :
                #Look up for word  
                print('What is the word?') 
                word = input('--> ')
                if word.casefold() in dictionary.keys():
                    print(word, '->', dictionary[word.casefold()])
                else:
                    print('Word not found!')
            elif opt == 2:
                #List the Dictonary
                if not dictionary:
                    print('Dictionary empty!!')
                else:
                    for key,value in dictionary.items():
                        print(key,'->', value)
            elif opt == 3:
                #Add a new entry
                print('What is the word?')
                word = input('--> ')
                print('what is its translation?')
                trans = input('--> ')
                dictionary[word.casefold()] = trans
                save_dictionary(dictionary)
            elif opt == 4:
                #Delete the entry
                print('What is the word?')
                word = input('--> ')
                del dictionary[word.casefold()]
                save_dictionary(dictionary)
            else:
                break
        except ValueError :
            print('Input valid Option')
        except KeyError as e:
            print(e , 'is not found in the dictionary')
    
     
def load_dictionary():
    """Loads a dictionary from file and returns it."""

    try:
        with open('words.json', 'r') as fp:
            dictionary = json.load(fp)
    except:
        print('WARNING: No dictionary found.')
        dictionary = {}

    return dictionary

def save_dictionary(dictionary):
    """Saves a dictionary to a file."""

    with open('words.json', 'w') as fp:
        json.dump(dictionary, fp, indent = 2, sort_keys = True)

if __name__ == '__main__':
    main()
