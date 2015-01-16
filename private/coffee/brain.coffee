brain = require 'brain'

toEncoding = (response) ->
  if response == 'correct'
    return 1
  else if response == 'incorrect' or response == 'skip'
    return 0

# A neural net wrapper
module.exports =
  getProbability: (data, personData) ->
    ioData = []
    for answer in data
      wordKeys = answer.personData.description
        .toLowerCase()
        .replace(/[\.,-\/#!$%\^&\*;:{}=\-_`~()]/g, " ")
        .split(' ')

      # Create the word dict
      inputDict = {}
      for word in wordKeys
        if inputDict[word]
          ++inputDict[word]
        else
          inputDict[word] = 1
      # Normalize the weights
      maxWeight = 0
      for key of inputDict
        maxWeight = Math.max(inputDict[key], maxWeight)
      for key of inputDict
        inputDict[key] = inputDict[key] / maxWeight

      polishedAnswer =
        input: inputDict
        output: [toEncoding answer.response]
      ioData.push polishedAnswer

    if ioData.length != 0
      # Run the classifier
      net = new brain.NeuralNetwork();
      net.train ioData
      result = net.run personData
      result = Math.round(100 * result)
    else
      # default 50%
      result = 50
    return result