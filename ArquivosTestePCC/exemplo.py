from libraryA import      functionX
import libraryB
from libraryC   import functionY
class Compilator:
	
	def translate( this, language,  word, baseClass  ):
	this.language = language
		this.word=   word
		this.baseClass    =baseClass
		return baseClass.transform(word )
	
	def compare ( this  ,word1,  word2 ):
				return functionX   (word1,word2)
	
	def   generate ( this ):
	this.word = functionY(this.language   )
	