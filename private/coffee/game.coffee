shuffle = require 'shuffle-array'
sets = require 'simplesets'

class Game
  constructor: (data, @$page) ->
    @questionDataOrder = shuffle(data)
    @currentQuestionIndex = 0
    @score = 0
    @guess = ''

    # Generate valid character
    @validCharacters = new sets.Set()
    for questionData in @questionDataOrder
      for char in questionData.name
        @validCharacters.add(char.toLowerCase())

    @validCharacters.remove(' ')

    @$page.find('.progress .total').text(@questionDataOrder.length)

  # Sets the game difficulty
  setDifficulty: (@difficulty) -> @

  # Loads the next person
  nextQuestion: ->
    ++@currentQuestionIndex
    questionData = @questionDataOrder[@currentQuestionIndex]
    splitName = questionData.name.split(' ')
    firstName = splitName[0]
    lastName = splitName[1]
    
    # Update DOM
    @$page.find('.person .picture').attr('src', questionData.image)
    @$page.find('.person .name').text(firstName)
    @$page.find('.person .title').text(questionData.title)

  # ## Guessing

  # Returns true if the character is a valid guess
  isValidChar: (char) ->
    return @validCharacters.has(char)

  # Adds a character to the guess
  addChar: (char) ->
    @guess += char
    console.log @guess

  # Removes a character from the guess
  removeChar: ->
    @guess = @guess.substring(0, @guess.length - 1)
    console.log @guess


module.exports = Game