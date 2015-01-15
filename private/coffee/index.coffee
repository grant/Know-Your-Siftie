$ = require 'jquery'

$ ->
  $page = {}
  # mode = { 'easy', 'hard' }
  mode = ''

  setup = ->
    $page =
      intro: $ '.page.intro'
      game: $ '.page.game'
      results: $ '.page.results'

    # $.getJSON '/api', (response) ->
    #   data = response
    #   console.log data
    setPage 'intro', false

    $easyButton = $('.easy.button')
    $hardButton = $('.hard.button')

    $easyButton.click ->
      mode = 'easy'
      setPage('game')
    $hardButton.click ->
      mode = 'hard'
      setPage('game')

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