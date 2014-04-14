#wwii cookbook
#a program that takes the The Italian Cook Book: The Art of Eating Well by Maria Gentile
#as well as the wikipedia page content for WWII, and produces a random recipe.. for war.


import sys
import random
import nltk

###opening + reading files

#read recipe file
recipesfile = open("italiancooking.txt")


recipes = dict()

recipesandnames = set()

recipesandnames = recipesfile.read().strip().split("\n\n\n")


#read wwii file
allwikisentences = nltk.sent_tokenize(open("wwiiwiki.txt").read().strip())





##functions

def is_number(s):
    try:
        float(s)
        return True
    except ValueError:
        return False


def is_noun(s):
	tags = nltk.pos_tag([s])

	for alist in tags:		
		if alist[1] == 'NN' and len(alist[0]) > 1:
			return True
		else:
			return False


def is_plural(s):
	if is_noun(s) and s[-1] == "s":
		return True;
	else:
		return False;


def is_propernoun(s):
	tags = nltk.pos_tag([s])

	for alist in tags:		
		if alist[1] == 'NP':
			return True
		else:
			return False


#make a dictionary of recipes { name => recipe}
recipes = {}
for recipe in recipesandnames:
	recipetokens = recipe.split("\n\n")
	title = recipetokens[1]
	recipecontents = "\n\n".join(recipetokens[3:])
	recipes.update({title : recipecontents})


#get a set of all nouns in the wikipage 
allwikinouns = set()
for sentence in allwikisentences:
	words = nltk.word_tokenize(sentence)
	for word in words:
		if is_noun(word):
			allwikinouns.add(word)


#print allwikinouns

#pick a recipe at random
randomtitle = random.choice(recipes.keys())
randomrecipe = recipes[randomtitle]
print randomtitle
print "\n\n"
print randomrecipe

#make a set of nouns
allrecipenouns = set()
sentences = nltk.sent_tokenize(randomrecipe)
for sentence in sentences:
	words = nltk.word_tokenize(sentence)
	for word in words:
		if is_noun(word):
			allrecipenouns.add(word)


#print allrecipenouns
#print allwikinouns

#make a dictionary to relate nouns of recipe to nouns of war
newdictionary = {}

for noun in allrecipenouns:
	randomnoun = random.sample(allwikinouns, 1)[0]
	newdictionary[noun] = randomnoun
	newdictionary[noun.upper()] = randomnoun.upper()

print "\n\n"
print newdictionary
print "\n\n"

#iterate through words, if noun, replace with wwii noun. 
for noun in newdictionary.keys():
	randomtitle = randomtitle.replace(noun, newdictionary[noun])
	randomrecipe = randomrecipe.replace(noun, newdictionary[noun])

print randomtitle	
print "\n\n"
print randomrecipe

