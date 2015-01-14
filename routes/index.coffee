express = require 'express'
request = require 'request'
cheerio = require 'cheerio'
router = express.Router()

# GET home page. 
router.get '/', (req, res) ->
  res.render 'index',
    title: 'Express'

# GET api
router.get '/api', (req, res) ->
  baseUrl = 'http://siftscience.com'
  request baseUrl + '/about', (err, response, body) ->
    $ = cheerio.load body
    # Parse the team profiles
    data = []
    $('.team').each (i) ->
      $team = $ @
      personData =
        image: baseUrl + $team.find('img').attr('src')
        name: $team.find('h2').text()
        title: $team.find('h3').text()
        description: $team.find('p').text()
      data.push personData

    res.json data

module.exports = router