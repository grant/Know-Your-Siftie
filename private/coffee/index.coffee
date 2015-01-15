$ = require 'jquery'
Game = require './game'

debug = true

$ ->
  # Global variables
  $page = {}
  data = {}
  # mode = { 'easy', 'hard' }
  mode = ''
  game = undefined

  # Sets up the website for the first time
  setup = ->
    $page =
      intro: $ '.page.intro'
      game: $ '.page.game'
      results: $ '.page.results'

    setPage 'intro', false

    $easyButton = $('.easy.button')
    $hardButton = $('.hard.button')
    $skipButton = $('.skip.button')

    # Load the data then enable intro button clicks
    loadData ->
      $easyButton.click ->
        startGame('easy')
      $hardButton.click ->
        startGame('hard')
      $skipButton.click ->
        game.nextQuestion()

    # Listen for keyboard events
    $('body').keydown (e) ->
      # Check backspace
      if e.which == 8
        backspace = true
      else
        char = String.fromCharCode(e.which).toLowerCase()
      if game
        if backspace
          game.removeChar()
          return false
        else if game.isValidChar(char)
          game.addChar(char)


  # Starts a new game
  startGame = (difficulty) ->
    mode = difficulty
    setPage('game')
    game = new Game(data, $page.game)
    game.setDifficulty difficulty
    game.setGameOverCb ->
      setPage 'results'
    game.nextQuestion()

  # Loads the data for the game
  loadData = (cb) ->
    if debug
      data = require '../../public/data/data'
      cb()
    else
      $.getJSON '/api', (response) ->
        data = response
        cb()

  # Sets the state of the pages
  setPage = (newPageName, transition = true) ->
    for pageName of $page
      if pageName is newPageName
        if transition
          $page[pageName].fadeIn()
        else
          $page[pageName].show()
      else
        if transition
          $page[pageName].fadeOut()
        else
          $page[pageName].hide()


  setup()