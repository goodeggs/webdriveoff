class GLOBAL.scenario extends GLOBAL.describe
  constructor: (description, callback) ->
    super description, callback

class GLOBAL.given extends GLOBAL.describe
  constructor: (description, callback) ->
    super "given #{description}", callback

GLOBAL.stopTest = ->
  it 'stops test', (done) ->
    console.log 'stopping test...'
    @timeout 0
