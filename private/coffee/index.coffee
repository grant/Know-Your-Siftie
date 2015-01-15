$ = require 'jquery'

$ ->
  $page = {}
  setup = ->
    $page =
      intro: $ '.page.intro'
      game: $ '.page.game'
      results: $ '.page.results'

    # $.getJSON '/api', (response) ->
    #   data = response
    #   console.log data
    setPage 'intro', false

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