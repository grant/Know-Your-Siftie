$ = require 'jquery'
debug = true

$ ->
  # Global variables
  $page = {}
  data = {}
  # mode = { 'easy', 'hard' }
  mode = ''

  # Sets up the website for the first time
  setup = ->
    $page =
      intro: $ '.page.intro'
      game: $ '.page.game'
      results: $ '.page.results'

    setPage 'intro', false

    $easyButton = $('.easy.button')
    $hardButton = $('.hard.button')

    # Load the data then enable intro button clicks
    loadData ->
      $easyButton.click ->
        startGame('easy')
      $hardButton.click ->
        startGame('hard')

  # Starts a new game
  startGame = (type) ->
    mode = type
    setPage('game')

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