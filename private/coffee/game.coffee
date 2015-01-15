shuffle = require 'shuffle-array'
ucfirst = require 'ucfirst'
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

    # Add first and last name to data structure
    for i, questionData of @questionDataOrder
      splitName = questionData.name.split(' ')
      @questionDataOrder[i].firstName = splitName[0]
      @questionDataOrder[i].lastName = splitName[1]

    @$name = @$page.find('.person .name')
    @$page.find('.progress .total').text(@questionDataOrder.length)

  # Sets the game difficulty
  setDifficulty: (@difficulty) -> @

  # Gets the current question data
  getQuestion: ->
    @questionDataOrder[@currentQuestionIndex]

  # Loads the next person (if available)
  nextQuestion: ->
    ++@currentQuestionIndex
    if @gameIsOver()
      @gameOverCb()
    else
      questionData = @getQuestion()
      @guess = ''
      
      # Update DOM
      @$name.removeClass('correct')
      @$page.find('.person .picture').attr('src', questionData.image)
      @$page.find('.person .title').text(questionData.title)
      @updateGuess()

  # ## Guessing

  # Returns true if the character is a valid guess
  isValidChar: (char) ->
    return @validCharacters.has(char)

  # Adds a character to the guess
  addChar: (char) ->
    @guess += char
    @guess = @guess.substring(0, @getQuestion().firstName.length)
    @checkGuess()

  # Removes a character from the guess
  removeChar: ->
    @guess = @guess.substring(0, @guess.length - 1)
    @checkGuess()

  # Checks if a guess is correct
  checkGuess: ->
    @updateGuess()
    if @guessIsCorrect()
      ++@score
      @$page.find('.progress .current').text(@score)
      # Make name flash green
      @$name.addClass('correct')
      # Delay next question
      setTimeout =>
        @nextQuestion()
      , 500
    else # incorrect
      if @guess.length == @getQuestion().firstName.length
        @$name.addClass('incorrect')
      else
        @$name.removeClass('incorrect')

  # Updates the guess state
  updateGuess: ->
    firstName = @getQuestion().firstName
    remainingChars = firstName.length - @guess.length
    starChars = ''
    for i in [0...remainingChars]
      starChars += '*'
    displayName = ucfirst(@guess) + starChars
    @$name.text(displayName)

  # Returns true if the current guess is correct
  guessIsCorrect: ->
    questionData = @getQuestion()
    return (@guess == questionData.firstName.toLowerCase())

  # Game state
  setGameOverCb: (cb) ->
    @gameOverCb = cb

  # Returns true if the game is over
  gameIsOver: ->
    return @currentQuestionIndex == @questionDataOrder.length

module.exports = Game